%% Script to carry out CSC-Beam method on ready-made generalized matrices
% =======================================================================
% 
% Script to calculate S_csc from S matrices provided by "GeneralizedMatrix_Script.m".
% Adapted from code in SUPPLEMENTARY MATERIAL of Ref. [1].
% 
% Created by Alistair Muir, September 2023
% 
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen, E. Gjonaj, H.W. Glock - 2020

clear
clc

% Add directories containing dependent functions and configuration files.
addpath("Functions and Subscripts")
addpath("Config Files")



%% RUN CONFIGURATION SCRIPT
Config_Scsc_Pillbox



%% Load physical constants
[mu0, eps0, c0] = func_EM_PhysicalConstants() ;



%% Loading S Matrices
% Number of segments.
N_segs = length(segment_names) ;
L_segs = zeros(1, N_segs) ;

% Load first generalized matrix to measure length for matrix initialization.
seg_matrix = load(seg_dir+"/"+segment_names(1)) ;
f          = seg_matrix.f ;
N_samples  = length(f) ;

% Load permutation matrix, P, and feedback matrix, F
load(orthogonal_matrices_dir)

% Number of internal modes being concatenated through entire structure.
N_concatmodes = length(F) ;

%%% Initialize final generalized S matrix.
S = zeros(N_samples, N_modes*2+1, N_modes*2+1) ;



%% Check segment S-matrices and import segment lengths.
for segi=1:N_segs

    % Load S-matrix.
    seg_matrix = load(seg_dir+"/"+segment_names(segi)) ;

    % Check frequencies match.
    if all(f~=seg_matrix.f)
        disp("   =====================================================")
        disp("     FREQUENCIES IN GENERALIZED MATRICES DO NOT MATCH   ")
        disp("   =====================================================")
        return
    end
    
    % Check that user-specified N_modes matches generalized matrix size.
    if length(seg_matrix.S(1,1,:))~=2*N_modes+1
        disp("   ========================================================================")
        disp("     GENERALIZED MATRIX IS NOT CORRECT SIZE FOR SPECIFIED NUMBER OF MODES  ")
        disp("   ========================================================================")
        disp("     Matrix size for segment ("+segi+"): "+string(size(seg_matrix.S(1,:,:))))
        return
    end
    
    % Construct array of segment lengths.
    L_segs(segi) = seg_matrix.Length ;

end



%% S_CSC construction
% Loop through all frequency samples.
for fi = 1:N_samples
        
    % Initialize block matrix and phase array.
    S_tot    = [] ;
    phi_segs = zeros(1,N_segs) ;
    
    
    % Cycle through all segments.
    for segi=1:N_segs
        
        % Load S-matrix.
        seg_matrix = load(seg_dir+"/"+segment_names(segi)) ;

        % S block diagonal matrix.
        S_tot = blkdiag(S_tot, squeeze(seg_matrix.S(fi,:,:))) ;
        
        % Phase at end of each segment.
        phi_segs(segi) = func_CalcPhase(f(fi), sum(L_segs(1:segi)), 0, c0) ;
        
    end
    
    
    % Array of phases at beginning of all segments.
    d = [1, exp(-1j*phi_segs(1:end-1))] ;
    
    % Create matrix for applying phase adjustment (ignoring downstream ext. port)
    M = blkdiag(eye(2*N_modes), d.') ;
    
    % Reorder block matrix according to internal and external quantities
    % and according to current and voltages.
    G = P*S_tot*P' ;
    
    % Split block matrix G into quadrants ready for concatenation (Ref. [1])
    G11 = G(1:N_concatmodes, 1:N_concatmodes) ;
    G12 = G(1:N_concatmodes, 1+N_concatmodes:end) ;
    
    G21 = G(1+N_concatmodes:end, 1:N_concatmodes) ;
    G22 = G(1+N_concatmodes:end, 1+N_concatmodes:end) ;
    
    % Determine generalized matrices of the concatenated structure.
    % M' == the Hermitian of M.
    S(fi,:,:) = M'*(G22+G21*((F-G11)\G12))*M ;
    
end



%% Save beam impedance
Length = sum(L_segs) ;

% Create save directory if needed.
if exist(save_dir,'dir')==0
    mkdir(save_dir)
end

save(save_filename, 'S', 'f', 'Length')



%% Plot
if plot_on
    f = f./f_CST2SI ;  % Plotting units == CST units
    Plot_GeneralizedMatrix
end


%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

