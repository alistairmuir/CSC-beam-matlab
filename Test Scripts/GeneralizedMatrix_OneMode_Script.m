%{
Script to retrieve CST results from Hi-Freq and Wakefield simulations,
calculate all unknown elements of S_csc for the simulation's frequency
range and subsequently construct the S_csc.

The result can be used in Erion's code to retrieve the Beam Impedance.

Created by Alistair Muir, August 2023

References:
1 - "Generalization of coupled S-parameter calculation to compute beam
impedances in particle accelerators" - T. Flisgen et al - 2020
%}
clear
clc


%% Physical constants
% Physical constants
mu0  = 1.25663706212*1e-6 ;  %  N/A^2, vacuum permeability.
eps0 = 8.854187*1e-12 ;      %  F/m, vacuum permittivity.
c    = 1./sqrt(mu0*eps0) ;   %  m/s, speed of light in vacuum.


%% USER INPUT
%%% Directories for CST results folders for both problem types.
wake_dir = "CST Files/Wake/Export" ;  % Wake problem CST directory
hifreq_dir = "CST Files/HiFreq/Export" ;  % High Freq problem CST directory

%%% Save directory (for generalized matrices)
Smat_savedir = "Results/Generalized Matrices/Pillbox" ;

%%% Conversion factors.
f_CST2SI =  1e9 ;   % Frequency: CST in GHz.
f_pltlabel = "GHz" ;  % for plotting.
s_CST2SI = 1e-9 ;   %   Seconds: CST in ns.
m_CST2SI = 1e-3 ;   %    Metres: CST in mm.

%%% Frequencies measured by Field Monitors in HiFreq simulation.
freqs_FM = (0.125:0.125:10.25)' ;
Nf_FM    = length(freqs_FM) ;

%%% Frequencies at which to evaluate S-matrix.
% Usually best to use freqs of Field Monitors - all other components will 
% have more dense frequency sets, thus more reliably interpolated.
freqs_Smat = freqs_FM ;
Nf_mat    = length(freqs_Smat) ;

%%% Plot results?
plot_results = true ;


%%% CST Export files structure - keeps same structure as CST navigation bar.
% Wakefield and current
wake_Z_dir = wake_dir+...
    "/Particle Beams/ParticleBeam1/Wake impedance/Z.txt" ;
current_dir = wake_dir+...
    "/Particle Beams/ParticleBeam1/Current.txt" ;

%%% S-parameters
S_dir = hifreq_dir+"/S-Parameters/" ;

% Choose mode to retrieve.
Smode = 3 ;

% Port signals directories, all modes (wake sim)
o1_dir = wake_dir+"/Port signals/o1("+Smode+"),pb.txt" ;
o2_dir = wake_dir+"/Port signals/o2("+Smode+"),pb.txt" ;

% E-field directories for both ports, all modes (hifreq sim).
E1_dir = hifreq_dir+"/e-field (f=0.125) (1("+Smode+"))_Z (Z)/" ;
E2_dir = hifreq_dir+"/e-field (f=0.125) (2("+Smode+"))_Z (Z)/" ;


%% Load wake, current, port wave amplitudes into matrices

% Wake impedence
wake_Z = readmatrix(wake_Z_dir) ;
wake_Z_cplx = wake_Z(:,2)+1i*wake_Z(:,3) ;

% Current
current = readmatrix(current_dir) ;

% Load port signals files.
o1 = readmatrix(o1_dir) ;
o2 = readmatrix(o2_dir) ;


%% Populate S-matrix

% Port labels.
prt_label=["1", "2"] ;

% Loop through all CST S-parameters, populating matrix.
for si=1:2
    for sj=1:2

        % Construct filename for this element of the S-matrix.
        Sij_dir = ...
        S_dir+"S"+prt_label(si)+...
            "("+Smode+"),"+...
            prt_label(sj)+"("+...
            Smode+").txt" ;

        Sparam_ij = readmatrix(Sij_dir) ;   % Read S(i,j) file.

        % Initialise S-parameter matrix in first pass.
        if si==1 && sj==1
            freqs_S = Sparam_ij(:,1) ;   % Retrieve frequencies
            Nf_S = length(freqs_S) ;
            S = complex(zeros(Nf_S, 2, 2)) ;
        end

        % Populate S-matrix.
        S(:,si,sj) = Sparam_ij(:,2)+1i*Sparam_ij(:,3) ;
        
    end
end


%% Calculate h

% Initialise Voltage vector.
V1 = zeros(Nf_FM,1) ;
V2 = zeros(Nf_FM,1) ;

for freq=1:Nf_FM
    
    %%% Retrieve E-field along z-axis for this frequency.
    E1_filename = E1_dir + string(freqs_FM(freq)) + " GHz.txt" ;
    E1_imprt = readmatrix(E1_filename) ;
    
    E2_filename = E2_dir + string(freqs_FM(freq)) + " GHz.txt" ;
    E2_imprt = readmatrix(E2_filename) ;
    
    
    % Distance
    z1 = E1_imprt(:,1)*m_CST2SI ;  % z-axis distance, converted to metres.
    z2 = E2_imprt(:,1)*m_CST2SI ;  % z-axis distance, converted to metres.

    
    % E-field integrand. (Eq.32 of ref. 1)
    E1_z = E1_imprt(:,2) + 1i*E1_imprt(:,3) ;  % Complex Ez field.
    E1_z_integrand = E1_z.*exp(1i*2*pi*freqs_FM(freq)*f_CST2SI*z1/c) ;
    
    E2_z = E2_imprt(:,2) + 1i*E2_imprt(:,3) ;  % Complex Ez field.
    E2_z_integrand = E2_z.*exp(1i*2*pi*freqs_FM(freq)*f_CST2SI*z2/c) ;
    
    
    %%% Integrate to retrieve beam voltage for this frequency.
    V1(freq) = trapz(z1, E1_z_integrand) ;
    V2(freq) = trapz(z2, E2_z_integrand) ;
    
end


%% Fourier Transforms

%%% Ensure data has even number of freq. samples (cuts off final odd sample).
Nmod = mod(length(o1(:,1)),2) ; % o1,o2,current will always have same length.
o1 = o1(1:end-Nmod,:) ;
o2 = o2(1:end-Nmod,:) ;
current = current(1:end-Nmod,:) ;
Tl = length(o1(:,1)) ;

%%% Sample frequencies
Ts = (o1(end,1)-o1(1,1))*s_CST2SI/Tl ;   % Sample period.
fs = 1/Ts ;   % Sampling freq.
freqs_FT = fs*(0:Tl/2-1)/Tl ;   % Frequencies for one-sided spectrum.
freqs_FT = freqs_FT/f_CST2SI ;   % Convert frequencies to CST units (for interp.)

%%% Fourier transforms
o1_FT = fft(o1(:,2)) ;
o2_FT = fft(o2(:,2)) ;
current_FT = fft(current(:,2)) ;

%%% Calc. one-sided spectrums
o1_FT = (o1_FT(1:Tl/2))/Tl ;
o1_FT(1:end-1) = 2*o1_FT(1:end-1) ;

o2_FT = (o2_FT(1:Tl/2))/Tl ;
o2_FT(1:end-1) = 2*o2_FT(1:end-1) ;

current_FT = (current_FT(1:Tl/2))/Tl ;
current_FT(1:end-1) = 2*current_FT(1:end-1) ;


%% Interpolations

%%% Ensures all components of an S(freq) matrix share the same frequency.
% Voltage
V1_interpolant = griddedInterpolant(freqs_FM, V1) ;
V1_ip = V1_interpolant(freqs_Smat) ;

V2_interpolant = griddedInterpolant(freqs_FM, V2) ;
V2_ip = V2_interpolant(freqs_Smat) ;

% Wake
Z_interpolant = griddedInterpolant(wake_Z(:,1), wake_Z_cplx) ;
Z_cplx_ip = Z_interpolant(freqs_Smat) ;

% Port signals
o1FT_interpolant = griddedInterpolant(freqs_FT, o1_FT) ;
o1FT_ip = o1FT_interpolant(freqs_Smat) ;

o2FT_interpolant = griddedInterpolant(freqs_FT, o2_FT) ;
o2FT_ip = o2FT_interpolant(freqs_Smat) ;

% Current
currentFT_interpolant = griddedInterpolant(freqs_FT, current_FT) ;
currentFT_ip = currentFT_interpolant(freqs_Smat) ;

% S-parameters
S_ip = complex(zeros(Nf_mat,2,2)) ;
S_interpolant = cell(2) ;

% Create S-paramater matrix at interpolated freqs.
for si=1:2
    for sj=1:2
    	S_interpolant{si,sj} = ...
            griddedInterpolant(freqs_S, squeeze(S(:,si,sj))) ;
        S_ip(:,si,sj) = S_interpolant{si,sj}(freqs_Smat) ;
    end
end


%% Calculate k
k1 = o1FT_ip./currentFT_ip ;
k2 = o2FT_ip./currentFT_ip ;


%% Calculate h at both ports for all freqs.
h1 = V1_ip;
%h1 = V1_ip./o1FT_ip ;
h2 = V2_ip;
%h2 = V2_ip./o2FT_ip ;


%% Generate generalized S-matrices

S_mat = complex(zeros(Nf_mat,3,3)) ;

for oO=1:Nf_mat
    S_mat(oO,:,:) = ...
        [S_ip(oO,1,1)  S_ip(oO,1,2)  k1(oO)        ;
         S_ip(oO,2,1)  S_ip(oO,2,2)  k2(oO)        ;
         h1(oO)        h2(oO)        Z_cplx_ip(oO) ] ;
end


%% Save the matrix with frequencies somewhere handy.
S = S_mat ;
f = freqs_Smat ;
save(Smat_savedir, "S", "f")

clear S f

%% Plotting
if plot_results==true
    
    %%% S_mat Magntidue
    S_db = 10*log(abs(S_mat)) ;   % Converting to decibels.

    %%% Plot limits matching Thomas' slides.
    % For magnitude
    ylims_Mag_max = [   0,    0, 100,    0,    0, 100,  50,  50, 100] ;
    ylims_Mag_min = [-150, -100, -50, -100, -150, -50, -50, -50, -50] ;

    % For phase
    ylims_ph_max = [ 200,  200,  200,  200,  200,  200,  200,  200,  100] ;
    ylims_ph_min = [-200, -200, -200, -200, -200, -200, -200, -200, -200] ;

    %%% y-axis units
     yunits = ["dB", "dB", "dB\surd\Omega", ...
        "dB", "dB", "dB\surd\Omega", ...
        "dB\surd\Omega", "dB\surd\Omega", "dB\Omega"] ;


    figure(1); clf
    for pii=1:3
        for pjj=1:3
            plti=3*(pii-1)+pjj;   % Plot number
            subplot(3,3,plti)
            plot(freqs_Smat(:),S_db(:,pii,pjj), ...
                 'X', 'MarkerSize', 8, ...
                'MarkerEdgeColor', '#A0A')
            xlim([0,10])
            ylim([ylims_Mag_min(plti),ylims_Mag_max(plti)])
            grid on
            %grid minor
            ax = gca ;
            ax.FontSize = 20 ;
            xlabel("f / "+f_pltlabel, 'FontSize', 20)
            ylabel("|S_{"+string(pii)+string(pjj)+"}| / "+yunits(plti), 'FontSize', 20)
            xticks(0:5:10)
            xline(5.74, 'r--', 'LineWidth', 2)
        end
    end

    %%% S_mat Phase
    phase_S = rad2deg(angle(S_mat)) ;

    figure(2); clf
    for pii=1:3
        for pjj=1:3
            plti=3*(pii-1)+pjj;   % Plot number

            subplot(3,3,plti)
            plot(freqs_Smat(:), phase_S(:,pii,pjj), ...
                 'X', 'MarkerSize', 8, ...
                'MarkerEdgeColor', '#A0A')
            xlim([0,10])
            ylim([ylims_ph_min(plti),ylims_ph_max(plti)])
            grid on
            %grid minor
            ax = gca ;
            ax.FontSize = 20 ;
            xlabel("f / "+f_pltlabel, 'FontSize', 20)
            ylabel("arg(S_{"+string(pii)+string(pjj)+"}) / \circ", 'FontSize', 20)
            xticks(0:5:10)
            xline(5.74, 'r--', 'LineWidth', 2)
        end
    end

    %%% Just Beam impedance (z_b)
%     figure(3); clf
%     plot(freqs_Smat(:),S_db(:,end,end), ...
%          'X', 'MarkerSize', 8, ...
%         'MarkerEdgeColor', '#A0A')
%     xlim([0,10])
%     ylim([ylims_Mag_min(end),ylims_Mag_max(end)])
%     grid on
%     %grid minor
%     ax = gca ;
%     ax.FontSize = 20 ;
%     xlabel("f / "+f_pltlabel, 'FontSize', 20)
%     ylabel("|z_b| / "+yunits(end), 'FontSize', 20)
%     xticks(0:5:10)
%     xline(5.74, 'r--')
end