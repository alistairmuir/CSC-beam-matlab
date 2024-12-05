function [S, Length] = func_CalcGM(wake_dir, freq_dir, ...
    freqs_FM, freqs_GM, ...
    f_CST2SI, s_CST2SI, m_CST2SI, ...
    Pmodes, Length, ...
    import_FFT, ...
    f_label)
% This function calculates and returns the generalized S-parameter matrix from CST simulation
% results of a beam segment, as proscribed in Ref [1].
%
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen, E. Gjonaj, H.W. Glock - 2020
%
% :param wake_dir: Directory containing results files from wake CST simulation of segment in the
% default folder structure of CST's navigation bar.
% :type  wake_dir: string
% :param freq_dir: Directory containing results files from wake CST simulation of segment in the
% default folder structure of CST's navigation bar.
% :type  freq_dir: string
% :param freqs_FM: Array of frequencies corresponding to FD results.
% :type  freqs_FM: double
% :param freqs_GM: Array of frequencies at which to calculate GM.
% :type  freqs_GM: double
% :param f_CST2SI: Conversion factor of freqeuncy, Hz - CST units to SI units.
% :type  f_CST2SI: double
% :param s_CST2SI: Conversion factor of seconds - CST units to SI units.
% :type  s_CST2SI: double
% :param m_CST2SI: Conversion factor of metres - CST units to SI units.
% :type  m_CST2SI: double
% :param Pmodes: List of port modes to include in GM.
% :type  Pmodes: double
% :param Length: Length of segment represented by GM.
% :type  Length: double
% :param import_FFT: Use FFTs calculated in CST post-processing (false = FFTs carried out in
% function.)
% :type  import_FFT: boolean
% :param f_label: String of CST frequency units, used for filenames.
% :type  f_label: string
%
% returns: S, Length (Generalized S-parameter matrix of a segment and the segment's length in SI.)


%%% Physical constants
[~, ~, c0] = func_EM_PhysicalConstants() ;


%%% Convert to SI units
% Make string of FM freqs in CST units, for folder names and plotting.
freqs_FM_str = string(freqs_FM) ;

% Convert frequency arrays to SI units.
freqs_FM = func_ConvertUnits(freqs_FM, f_CST2SI) ;
freqs_GM = func_ConvertUnits(freqs_GM, f_CST2SI) ;

% Convert segment length to SI units.
Length = func_ConvertUnits(Length, m_CST2SI) ;


%%% CST export directories
% Note: these functions assume the same folder structure as the CST Export results folders.
[wake_Z_dir, current_dir, o1_dir, o2_dir] = func_CSTfilenames_Wake(wake_dir, Pmodes) ;
[S_dir, E1_dir, E2_dir] = func_CSTfilenames_Freq(freq_dir, freqs_FM_str(1), Pmodes) ;


%%% Retrieve S-parameter frequencies using first active mode S-parameter file.
[freqs_S, ~] = func_Import_CSTdata(S_dir+"S1("+Pmodes(1)+"),1("+Pmodes(1)+").txt", f_CST2SI) ;

%%% Find length of vectors for constructing matrices.
Nf_FM   = length(freqs_FM) ;   % Field monitor frequencies.
Nf_GM   = length(freqs_GM) ;   % Final S_matrix frequencies (chosen by user).
Nf_Sp   = length(freqs_S) ;    % Frequencies in S-parameters CST files.
N_modes = length(Pmodes) ;     % Number of modes per port.

%%% Initialise matrices
V = zeros(Nf_FM, 2*N_modes) ;        % Multi-modal voltage matrix.
V_final = zeros(Nf_GM,2*N_modes) ;   % Final interpolated multi-modal voltage matrix.

portFD_final = zeros(Nf_GM,2*N_modes) ;   % Final matrix for port signals.

Sp = complex(zeros(Nf_Sp,   2*N_modes,2*N_modes)) ;         % Imported S-parameter matrix.
Sparams_final = complex(zeros(Nf_GM,2*N_modes,2*N_modes)) ; % Interpolated S-parameter matrix.
S = complex(zeros(Nf_GM,2*N_modes+1,2*N_modes+1)) ;         % Final generalized matrix.


%%% Load direct wake impedance and corresponding frequency samples
[freqs_wake, wake_Z] = func_Import_CSTdata(wake_Z_dir, f_CST2SI) ;


%%% Populate S-parameter matrix
%%%% Loop through all CST S-parameters, populating matrix.

% (Column element - cycle through all modes at each port.)
for porti=1:2
    for modi=1:N_modes
    
        % ith row of S-parameter matrix
        si = modi + N_modes*(porti-1) ;
        
        % (Row element - cycle through all modes at each port.)
        for portj=1:2
            for modj=1:N_modes
                
                % jth column of S-parameter matrix
                sj = modj + N_modes*(portj-1) ;
                
                % Construct filename for this element of the S-matrix.
                Sij_dir = S_dir+"S"+porti+"("+Pmodes(modi)+"),"+...
                            portj+"("+Pmodes(modj)+").txt" ;
                
                % Populate S-matrix.
                [~, Sp(:,si,sj)] = func_Import_CSTdata(Sij_dir, f_CST2SI) ;
                
            end
        end
    end
end


%%% Calculate beam voltages for all modes
% (Equation 5 in Ref [1].)

% Loop over all modes, all frequencies, and carry out integration.
for freqi=1:Nf_FM
    for modi=1:N_modes
        
        %%% Construct file paths for the Ez CST data, port 1 and port 2.
        E1_filepath = E1_dir(modi) + freqs_FM_str(freqi) + " " + f_label + ".txt" ;
        E2_filepath = E2_dir(modi) + freqs_FM_str(freqi) + " " + f_label + ".txt" ;

        %%% Carry out integration and return the voltages.
        V(freqi, modi) = func_CalcVoltage_Ez_CSTdata(...           % Port 1
            E1_filepath, freqs_FM(freqi), c0, m_CST2SI) ;
        V(freqi, N_modes+modi) = func_CalcVoltage_Ez_CSTdata(...   % Port 2
            E2_filepath, freqs_FM(freqi), c0, m_CST2SI) ;
        
    end
end



%%% Fourier transforms
switch import_FFT
    
    %%%% Use imported CST FFTs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case true
        
        % Filenames of CST FFTs.
        o1_FT_dir      = wake_dir+"/o1("+Pmodes+"),pb_FT.txt" ;
        o2_FT_dir      = wake_dir+"/o2("+Pmodes+"),pb_FT.txt" ;
        current_FT_dir = wake_dir+"/Current_FT.txt" ;
        
        % Retrieve freqs from first file of first signal.
        [freqs_portmodes, ~] = func_Import_CSTdata(o1_FT_dir(1), f_CST2SI) ;
        
        % Create port signals matrix.
        portsignals_FD = complex(zeros(length(freqs_portmodes), 2*N_modes)) ;
        
        
        % Import all port signals in fourier domain.
        for modi=1:N_modes
            
            %%% Port mode indices
            port1 = modi ;
            port2 = N_modes + modi ;
            
            %%% Populate matrix.
            [~, portsignals_FD(:,port1)] = func_Import_CSTdata(o1_FT_dir(modi), f_CST2SI) ;
            [~, portsignals_FD(:,port2)] = func_Import_CSTdata(o2_FT_dir(modi), f_CST2SI) ;
            
        end
        
        % Import Current FD.
        [freqs_current, current_FD] = func_Import_CSTdata(current_FT_dir, f_CST2SI) ;
        
        
        
    %%% Carry out FFTs on CST timeseries data %%%%%%%%%%%%%%%%%%
    case false
        
        %%% Load beam current
        [time_samples, beam_current] = func_Import_CSTdata(current_dir, s_CST2SI) ;
        
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
            [~, port_signals(:,port1)] = func_Import_CSTdata(o1_dir(modi), s_CST2SI) ;
            [~, port_signals(:,port2)] = func_Import_CSTdata(o2_dir(modi), s_CST2SI) ;
            
        end
        
        
        %%% Carry out FFTs. (Port signals and current share the same time samples.)
        [freqs_portmodes, portsignals_FD] = func_FFT_CSTdata(port_signals, time_samples) ;
        [freqs_current,   current_FD]     = func_FFT_CSTdata(beam_current, time_samples) ;
        
end


%%% Interpolations
% (Ensures all components of a generalized matrix share the same frequency.)

%%% Interpolate: Wake
Z_final = func_Interpolate_CSTdata(wake_Z, freqs_wake, freqs_GM) ;

%%% Interpolate: Current
currentFD_final = func_Interpolate_CSTdata(current_FD, freqs_current, freqs_GM) ;

%%% Interpolate: Port signals and voltages
for modi=1:2*N_modes
    
    % Voltages
    V_final(:,modi) = func_Interpolate_CSTdata(V(:,modi), freqs_FM, freqs_GM) ;
    
    % Port signals
    portFD_final(:,modi) = func_Interpolate_CSTdata(portsignals_FD(:,modi), ...
        freqs_portmodes, freqs_GM) ;
    
end


%%% Interpolate: S-parameters and store in a full S-parameter matrix.
for si=1:2*N_modes
    for sj=1:2*N_modes
        
        Sparams_final(:,si,sj) = func_Interpolate_CSTdata(Sp(:,si,sj), freqs_S, freqs_GM) ;
        
    end
end


%%% Calculate k and h
% See Eq. 1 in Ref. [1]
k_final = func_CalcBeamCoupling_k(portFD_final, currentFD_final) ;
h_final = func_CalcBeamCoupling_h(V_final, ones(size(V_final))) ;


%%% Construct generalized S-matrix for all frequencies
% Loop of all S-parameter frequencies.
for fi=1:Nf_GM
    
    % Call the function to create GM for this frequency.
    S(fi,:,:) = func_ConstructGeneralizedMatrix(...
        squeeze(Sparams_final(fi,:,:)), k_final(fi,:), h_final(fi,:), Z_final(fi)) ;
    
end

end

