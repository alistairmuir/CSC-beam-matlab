%% Script to produce a generalized S-parameter matrix
% ===================================================
% 
% Script to retrieve CST results from Hi-Freq and Wakefield simulations,
% calculate all unknown elements of S_csc for the simulation's frequency
% range and subsequently construct the S_csc.
% 
% The result can be used in Erion's code to retrieve the Beam Impedance.
% 
% Created by Alistair Muir, August 2023
% 
% References:
% #. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen et al - 2020

clear
clc

% Add directories containing dependent functions and configuration files.
addpath("Functions and Subscripts")
addpath("Config files")



%% RUN CONFIGURATION SCRIPT
Config_GeneralizedMatrix



%% Physical constants
PhysicalConstants



%% CST Export Directories (assumes same folder structure as CST navigation bar)
% Wakefield and current
wake_Z_dir  = wake_dir+"/Particle Beams/ParticleBeam1/Wake impedance/Z.txt" ;
current_dir = wake_dir+"/Particle Beams/ParticleBeam1/Current.txt" ;

% S-parameters
S_dir = hifreq_dir+"/S-Parameters/" ;

% Port signals directories, all modes (wake sim)
o1_dir = wake_dir+"/Port signals/o1("+Pmodes+"),pb.txt" ;
o2_dir = wake_dir+"/Port signals/o2("+Pmodes+"),pb.txt" ;

% Create string series for field monitor directories.
freqs_FM_str = string(freqs_FM) ;

% E-field directories for both ports, all modes (hifreq sim).
E1_dir = hifreq_dir+"/e-field (f="+freqs_FM_str(1)+") (1("+Pmodes+"))_Z (Z)/" ;
E2_dir = hifreq_dir+"/e-field (f="+freqs_FM_str(1)+") (2("+Pmodes+"))_Z (Z)/" ;



%% Convert frequencies and lengths to SI units.
% Convert frequency arrays
freqs_FM = freqs_FM*f_CST2SI ;
freqs_GM = freqs_GM*f_CST2SI ;

% Convert segment lengths
Length   = Length*m_CST2SI ;



%% Initialization
%%% Port labels for constructing CST directory names.
prt_label=["1", "2"] ;

%%% Load first S-parameter to initialize S-matrix.
% Construct filename for first S-matrix element.
Sij_dir = S_dir+"S"+prt_label(1)+"("+Pmodes(1)+"),"+prt_label(1)+"("+Pmodes(1)+").txt" ;

Sparam_ij = readmatrix(Sij_dir) ;   % Read S(i,j) file.
freqs_S   = Sparam_ij(:,1).*f_CST2SI ;   % Retrieve frequencies

%%% Length of vectors.
Nf_FM   = length(freqs_FM) ;   % Field monitor frequencies.
Nf_Smat = length(freqs_GM) ;   % Final S_matrix frequencies (chosen by user).
Nf_S    = length(freqs_S) ;    % Frequencies in S-parameters CST files.
N_modes = length(Pmodes) ;     % Number of modes


% Initialise multi-modal voltage matrix.
V = zeros(Nf_FM, 2*N_modes) ;

%%% Initialize interpolants
V_interpolant      = cell(2*N_modes,1) ;    % Voltage (vector)
portFT_interpolant = cell(2*N_modes,1) ;    % Port signal (vector)
S_interpolant      = cell(2*N_modes) ;      % S-parameters (matrix)

% Initialize final matrices
V_final      = zeros(Nf_Smat,2*N_modes) ;    % Voltage
portFT_final = zeros(Nf_Smat,2*N_modes) ;    % Port signals
k = complex(zeros(Nf_Smat,2*N_modes)) ;      % k vectors (beam-port coupling)
h = complex(zeros(Nf_Smat,2*N_modes)) ;      % h vectors (mode-beam coupling)

S_matrix     = complex(zeros(Nf_S,   2*N_modes,2*N_modes)) ;  % Raw S-matrix.
S_mat_interp = complex(zeros(Nf_Smat,2*N_modes,2*N_modes)) ;  % Interpolated S-matrix.



%% Load wake, current, port wave amplitudes into matrices
% Wake impedence
loadwake   = readmatrix(wake_Z_dir) ;
freqs_wake = loadwake(:,1)*f_CST2SI ;
wake_Z     = loadwake(:,2)+1i*loadwake(:,3) ;

% Load beam current
beam_current = readmatrix(current_dir) ;
time_samples = beam_current(:,1) ;
Tl           = length(time_samples) ;   % Number of time samples.

% Initialize port signals matrix
port_signals = zeros(Tl, 2*N_modes) ;

% Load port signals files.
for modi=1:N_modes
    
    % Port indices for this mode.
    port1 = modi ;
    port2 = N_modes+modi ;
    
    % Read in port signals for this mode.
    o1_modi = readmatrix(o1_dir(modi)) ;
    o2_modi = readmatrix(o2_dir(modi)) ;
    
    % Load 'em into signals matrix.
    port_signals(:,port1) = o1_modi(:,2) ;   % First N_modes are from port 1.
    port_signals(:,port2) = o2_modi(:,2) ;   % Second N_modes are from port 2.
    
end

% Clear placeholder matrices
clear o1_modi o2_modi



%% Populate S-matrix
%%% Loop through all CST S-parameters, populating matrix.
for modi=1:N_modes
    for porti=1:2
    
        % ith row of S-parameter matrix
        si = modi + N_modes*(porti-1) ;
        
        for modj=1:N_modes
            for portj=1:2
                
                % jth column of S-parameter matrix
                sj = modj + N_modes*(portj-1) ;
                
                % Construct filename for this element of the S-matrix.
                Sij_dir = S_dir+"S"+prt_label(porti)+"("+Pmodes(modi)+"),"+...
                            prt_label(portj)+"("+Pmodes(modj)+").txt" ;
                
                % Load S-parameter, if no file exists, assume its negligible and issue warning.
                try
                    Sparam_ij = readmatrix(Sij_dir) ;    % Read S(i,j) file.
                catch
                    disp("======================================================")
                    disp("WARNING")
                    disp("No file with name: " + Sij_dir)
                    disp("S-parameter will be assumed negligble.")
                    disp("======================================================")
                    
                    Sparam_ij = zeros(complex(Nf_S),3) ;
                end
                
                % Populate S-matrix.
                S_matrix(:,si,sj) = Sparam_ij(:,2)+1i*Sparam_ij(:,3) ;
                
            end
        end
    end
end

% Clear placeholder/redundant matrices.
clear Sparam_ij Sij_dir



%% Calculate beam voltages for all modes
%%% Equation 31 in Ref [1].

%%% Loop over all modes, all frequencies, and carry out integration.
for freq=1:Nf_FM
    for modi=1:N_modes
        
        %%% Retrieve E-field along z-axis for this frequency.
        E1_filename = E1_dir(modi) + freqs_FM_str(freq) + " " + f_label + ".txt" ;
        E1_import = readmatrix(E1_filename) ;
        
        E2_filename = E2_dir(modi) + freqs_FM_str(freq) + " " + f_label + ".txt" ;
        E2_import = readmatrix(E2_filename) ;
        
        %%% Distance
        z1 = E1_import(:,1)*m_CST2SI ;   % z-axis distance, converted to m.
        z2 = E2_import(:,1)*m_CST2SI ;   % z-axis distance, converted to m.
        
        %%% Construct complex Ez field vectors.
        E1_z = E1_import(:,2) + 1i*E1_import(:,3) ;
        E2_z = E2_import(:,2) + 1i*E2_import(:,3) ;
        
        %%% E-field integrand.
        dV1z_integrand = E1_z.*exp(1i*2*pi*freqs_FM(freq)*z1/c0) ;
        dV2z_integrand = E2_z.*exp(1i*2*pi*freqs_FM(freq)*z2/c0) ;
        
        %%% Integrate to retrieve beam voltage for this frequency.
        V(freq, modi)         = trapz(z1, dV1z_integrand) ;   % port 1 modes first N_modes
        V(freq, N_modes+modi) = trapz(z2, dV2z_integrand) ;   % port 2 modes second N_modes
        
    end
end



%% Fourier Transforms
%%% Ensure data has even number of samples (cuts off final odd sample).
% Number of samples
Tl = length(time_samples(:,1)) ;

% Ensure signals have even number of samples for FFT.
Nmod2 = mod(Tl, 2) ;
Tl = Tl - Nmod2 ;
port_signals = port_signals(1:end-Nmod2,:) ;

%%% Fourier transforms and one-sided spectra %%%%%%%%%%%%%%%%%%%%%
switch import_FFT
    
    %%%% Use imported CST FFTs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case true
        %%% Import port signals and current FFTs from CST results.
        
        % Filenames of CST FFTs.
        o1_FT_dir      = wake_dir+"/o1("+Pmodes+"),pb_FT.txt" ;
        o2_FT_dir      = wake_dir+"/o2("+Pmodes+"),pb_FT.txt" ;
        current_FT_dir = wake_dir+"/Current_FT.txt" ;

        % Cycle through all modes, (port 1 and port 2 are adjacent for each mode).
        for modi=1:N_modes
            
            %%% Port mode indices
            port1 = modi ;
            port2 = N_modes + modi ;
            
            %%% Read raw files.
            ps1_FT = readmatrix(o1_FT_dir(modi)) ;
            ps2_FT = readmatrix(o2_FT_dir(modi)) ;
            
            % Initialize
            if modi==1
                len_FT          = min(length(ps1_FT), length(ps2_FT)) ;
                port_signals_FT = complex(zeros(len_FT,2*N_modes)) ;
                freqs_FFT       = ps1_FT(:,1) ;
            end
            
            
            %%% Retrieve desired data.
            port_signals_FT(:,port1) = ...
                ps1_FT(1:len_FT,2) + 1i*ps1_FT(1:len_FT,3) ;
            
            port_signals_FT(:,port2) = ...
                ps2_FT(1:len_FT,2) + 1i*ps2_FT(1:len_FT,3) ;
            
        end
        
        % Current.
        I_FTimport    = readmatrix(current_FT_dir)  ;
        freqs_current = I_FTimport(:,1) ;
        current_FT    = I_FTimport(:,2) + 1i*I_FTimport(:,3) ;
        
        
        
    %%%% Carry out FFTs here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case false
        %%% Import TD port signals and beam current carry out FFTs here.
        
        %%% Port signals FFT
        % Initialize freq-domain port signals matrix.
        port_signals_FT = complex(zeros(Tl/2,2*N_modes)) ;
        
        %%% Sample frequencies
        Ts = (time_samples(end)-time_samples(1))*s_CST2SI/Tl ;   % Sample period.
        fs = 1/Ts ;   % Sampling freq.
        freqs_FFT = fs*(0:Tl/2-1)/Tl ;     % Frequencies for one-sided spectrum.
        
        % Cycle through all modes.
        for modi=1:2*N_modes
            
            % Carry out FFT
            port_FFT = fft(port_signals(:,modi)) ;
            
            % Calc one-sided spectrum.
            port_signals_FT(:,modi)       = port_FFT(1:Tl/2)/Tl ;
            port_signals_FT(2:end-1,modi) = 2*port_signals_FT(2:end-1,modi) ;
            
        end

        clear port_FFT   % Clear redundant large matrices
        
        %%% Beam current FFT.
        freqs_current = freqs_FFT ;    % Time samples for current are same as port signals.
        beam_current = beam_current(1:end-Nmod2,:) ;
        current_FT   = fft(beam_current(:,2)) ;
        % current_FT   = abs(current_FT(1:Tl/2))/Tl ;   % Take absolute?
        current_FT = (current_FT(1:Tl/2))/Tl ;
        current_FT(2:end-1) = 2*current_FT(2:end-1) ;
        
end



%% Interpolations
% Ensures all components of an S(freq) matrix share the same frequency.

%%% Interpolate: Wake
Z_interpolant = griddedInterpolant(freqs_wake, wake_Z) ;
Z_final       = Z_interpolant(freqs_GM) ;

%%% Interpolate: Current
currentFT_interpolant = griddedInterpolant(freqs_current, current_FT) ;
currentFT_final       = currentFT_interpolant(freqs_GM) ;

%%% Interpolate: Every mode of signals and voltages
for modi=1:2*N_modes
    
    % Voltages (create interpolant, then interpolate at target freqs.)
    V_interpolant{modi} = griddedInterpolant(freqs_FM, V(:,modi)) ;
    V_final(:,modi)     = V_interpolant{modi}(freqs_GM) ;
    
    % Port signals (create interpolant, then interpolate at target freqs.)
    portFT_interpolant{modi} = ...
        griddedInterpolant(freqs_FFT, port_signals_FT(:,modi)) ;
    portFT_final(:,modi) = portFT_interpolant{modi}(freqs_GM) ;
    
end

%%% Interpolate: S-parameters (and construct matrix)
for si=1:2*N_modes
    for sj=1:2*N_modes
        
        % Interpolate S-parameter and store in S-matrix.
    	S_interpolant{si,sj}  = griddedInterpolant(freqs_S, squeeze(S_matrix(:,si,sj))) ;
        S_mat_interp(:,si,sj) = S_interpolant{si,sj}(freqs_GM) ;
        
    end
end



%% Calculate k and h 
for modi=1:2*N_modes
    
    % k(x) = b(x)/current     (See Eq.[1] in Ref [1].)
    k(:,modi) = portFT_final(:,modi)./currentFT_final ;
    
    % h(x) = v(x)/a(x)      (See Eq.[1] in Ref [1].)
    h(:,modi) = V_final(:,modi) ;
    
    % Note: input port signals a(x) are normalized to 1 sqrt(W) peak power. See:
    % https://space.mit.edu/RADIO/CST_online/...
    %        ...mergedProjects/3D/special_overview/special_overview_waveguideover.htm

end



%% Generate generalized S-matrices
%%% Initialize generalized S-matrix
S = complex(zeros(Nf_Smat,2*N_modes+1,2*N_modes+1)) ;

for fi=1:Nf_Smat
    
    % Concatenate S-matrix with k vector for this frequency.
    Sk_mat = [squeeze(S_mat_interp(fi,:,:)), k(fi,:).'] ;
    
    % Concatenate S-and-k-matrix with [h,z_b] horizontal vector for
    % generalized S-matrix for this frequency.
    Skhz_mat = [Sk_mat ; [h(fi,:), Z_final(fi)]] ;
    
    % Write this frequency's S-matrix to generalized matrix.
    S(fi,:,:) = Skhz_mat ;
    
end



%% Save the matrices and corresponding frequencies.

if save_matrix == true

    % A little housekeeping.
    if exist(genmat_savedir, 'file')==0
        mkdir(genmat_savedir)
    end

    % Construct complete directory.
    Smat_savedir = genmat_savedir + "/" + genmat_filename ;

    % Save the file.
    f = freqs_GM ;
    save(Smat_savedir, "S", "f", "Length")

end



%% Plotting
if plot_results==true
    f = freqs_GM./f_CST2SI ;
    Plot_GeneralizedMatrix
end


%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

