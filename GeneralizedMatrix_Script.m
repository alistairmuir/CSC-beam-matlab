%% Script to produce a generalized S-parameter matrix
% ===================================================
% 
% Script to retrieve CST results from Hi-Freq and Wakefield simulations,
% calculate all unknown elements of S_csc for the simulation's frequency
% range and subsequently construct the S_csc.
% 
% The resultant S matrix can be used in Scsc_Script.m to carry out CSC-beam, see Ref. [1].
% 
% Created by Alistair Muir, August 2023
% 
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen et al - 2020

clear
clc

% Add directories containing dependent functions and configuration files.
addpath("Functions and Subscripts")
addpath("Config Files")



%% RUN CONFIGURATION SCRIPT
Config_GeneralizedMatrix


%% Physical constants
[mu0, eps0, c0] = func_EM_PhysicalConstants() ;


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



%% Convert input arrays to SI units.
% Convert frequency arrays
freqs_FM = freqs_FM*f_CST2SI ;
freqs_GM = freqs_GM*f_CST2SI ;

% Convert segment length
Length = Length*m_CST2SI ;



%% Initialize all matrices.
%%% Retrieve S-parameter frequencies using first active mode S-parameter file.
[freqs_S, ~] = func_import_CSTdata(...
    S_dir+"S1("+Pmodes(1)+"),1("+Pmodes(1)+").txt", f_CST2SI) ;

%%% Find length of vectors for constructing matrices.
Nf_FM   = length(freqs_FM) ;   % Field monitor frequencies.
Nf_Smat = length(freqs_GM) ;   % Final S_matrix frequencies (chosen by user).
Nf_Sp   = length(freqs_S) ;    % Frequencies in S-parameters CST files.
N_modes = length(Pmodes) ;     % Number of modes per port.

% Initialise multi-modal voltage matrix.
V = zeros(Nf_FM, 2*N_modes) ;

% Initialize final interpolated multi-modal voltage matrix.
V_final = zeros(Nf_Smat,2*N_modes) ;

% Initialize final matrix for port signals.
portFD_final = zeros(Nf_Smat,2*N_modes) ;

% Initialize import S-parameter matrix
Sp = complex(zeros(Nf_Sp,   2*N_modes,2*N_modes)) ;

% Initialize interpolated S-parameter matrix.
Sp_final = complex(zeros(Nf_Smat,2*N_modes,2*N_modes)) ;



%% Load wake impedance and corresponding frequency samples.
[freqs_wake, wake_Z] = func_import_CSTdata(wake_Z_dir, f_CST2SI) ;



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
                Sij_dir = S_dir+"S"+porti+"("+Pmodes(modi)+"),"+...
                            portj+"("+Pmodes(modj)+").txt" ;
                
                % Populate S-matrix.
                [~, Sp(:,si,sj)] = func_import_CSTdata(Sij_dir, f_CST2SI) ;
                
            end
        end
    end
end



%% Calculate beam voltages for all modes
%%% Equation 31 in Ref [1].

%%% Loop over all modes, all frequencies, and carry out integration.
for freq=1:Nf_FM
    for modi=1:N_modes
        
        %%% Construct file paths for the Ez CST data.
        E1_filepath = E1_dir(modi) + freqs_FM_str(freq) + " " + f_label + ".txt" ;
        E2_filepath = E2_dir(modi) + freqs_FM_str(freq) + " " + f_label + ".txt" ;

        %%% Carry out integration and return the voltages.
        V(freq, modi) = func_calcVoltage_Ez_CSTdata(...
            E1_filepath, freqs_FM(freq), c0, m_CST2SI) ;
        
        V(freq, N_modes+modi) = func_calcVoltage_Ez_CSTdata(...
            E2_filepath, freqs_FM(freq), c0, m_CST2SI) ;
        
    end
end



%% Fourier Transforms
switch import_FFT
    
    %%%% Use imported CST FFTs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case true
        
        % Filenames of CST FFTs.
        o1_FT_dir      = wake_dir+"/o1("+Pmodes+"),pb_FT.txt" ;
        o2_FT_dir      = wake_dir+"/o2("+Pmodes+"),pb_FT.txt" ;
        current_FT_dir = wake_dir+"/Current_FT.txt" ;

        % Retrieve freqs from first file of first signal.
        [freqs_portmodes, ~] = func_import_CSTdata(o1_FT_dir(1), f_CST2SI) ;
        
        % Create port signals matrix.
        portsignals_FD = complex(zeros(length(freqs_portmodes), 2*N_modes)) ;
        
        
        % Import all port signals in fourier domain.
        for modi=1:N_modes
            
            %%% Port mode indices
            port1 = modi ;
            port2 = N_modes + modi ;
            
            %%% Populate matrix.
            [~, portsignals_FD(:,port1)] = func_import_CSTdata(o1_FT_dir(modi), f_CST2SI) ;
            [~, portsignals_FD(:,port2)] = func_import_CSTdata(o2_FT_dir(modi), f_CST2SI) ;

        end
        
        % Import Current FD.
        [freqs_current, current_FD] = func_import_CSTdata(current_FT_dir, f_CST2SI) ;
        
        
        
    %%%% Carry out FFTs on CST timeseries data %%%%%%%%%%%%%%%%%%
    case false
        
        %%% Load beam current
        [time_samples, beam_current] = func_import_CSTdata(current_dir, s_CST2SI) ;

        % Number of time samples.
        N_ts = length(time_samples) ;

        %%% Initialize port signals matrix
        port_signals = zeros(N_ts, 2*N_modes) ;

        %%% Load port signals.
        for modi=1:N_modes

            % Port indices for this mode.
            port1 = modi ;
            port2 = N_modes+modi ;

            % Import port signals.
            [~, port_signals(:,port1)] = func_import_CSTdata(o1_dir(modi), s_CST2SI) ;
            [~, port_signals(:,port2)] = func_import_CSTdata(o2_dir(modi), s_CST2SI) ;

        end
        
        
        %%% Carry out FFTs. (Port signals and current share the same time samples.)
        [freqs_portmodes, portsignals_FD] = func_FFT_CSTdata(port_signals, time_samples) ;
        [freqs_current, current_FD]       = func_FFT_CSTdata(beam_current, time_samples) ;
        
end



%% Interpolations
% Ensures all components of a generalized matrix share the same frequency.

%%% Interpolate: Wake
Z_final = func_interpolate_CSTdata(wake_Z, freqs_wake, freqs_GM) ;

%%% Interpolate: Current
currentFD_final = func_interpolate_CSTdata(current_FD, freqs_current, freqs_GM) ;

%%% Interpolate: Port signals and voltages
for modi=1:2*N_modes
    
    % Voltages
    V_final(:,modi) = func_interpolate_CSTdata(V(:,modi), freqs_FM, freqs_GM) ;
    
    % Port signals
    portFD_final(:,modi) = func_interpolate_CSTdata(portsignals_FD(:,modi), ...
        freqs_portmodes, freqs_GM) ;
    
end

%%% Interpolate: S-parameters and store in a full S-parameter matrix.
for si=1:2*N_modes
    for sj=1:2*N_modes
        
        Sp_final(:,si,sj) = func_interpolate_CSTdata(Sp(:,si,sj), freqs_S, freqs_GM) ;
        
    end
end



%% Calculate k and h
% See Eq. 1 in Ref. [1]
k = func_CalcBeamCoupling_k(portFD_final, currentFD_final) ;
h = func_CalcBeamCoupling_h(V_final, ones(size(V_final))) ;



%% Construct generalized S-matrix for all frequencies.
%%% Initialize generalized S-matrix
S = complex(zeros(Nf_Smat,2*N_modes+1,2*N_modes+1)) ;

for fi=1:Nf_Smat
    
    % Call the function to create GM for this frequency.
    S(fi,:,:) = func_ConstructGeneralizedMatrix(...
        squeeze(Sp_final(fi,:,:)), k(fi,:), h(fi,:), Z_final(fi)) ;
    
end



%% Save the matrices and corresponding frequencies.
func_SaveGM(save_dir, save_filename, S, freqs_GM, Length)



%% Plotting
if plot_results==true
    % Return freqs to CST units for plotting.
    f = freqs_GM./f_CST2SI ;
    
    % Run plotting script
    Plot_GeneralizedMatrix
end


%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

