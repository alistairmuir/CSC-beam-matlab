function [S, freqs, Length] = func_CalcScsc(seg_dir, segment_names, orthogonal_matrices_dir)
% A function to carry out Scsc-beam for generalized matrices representing adjecent
% sections of beam path. The list order in segment_names dictates the section order.
%
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen, E. Gjonaj, H.W. Glock - 2020
%
% :param seg_dir: Directory containing files for all the generalized matrices (GM).
% :type  seg_dir: string
% :param segment_names: List of filenames, each file contains GM, freqs and Length of a segment.
% :type  segment_names: string
% :param orthogonal_matrices_path: Filepath to file containing orthogonal matrices P and F.
% :type  orthogonal_matrices_path: string
% 
% :returns: S (N-by-M-by-M), freqs (1-by-N), Length


% Physical constants
[~, ~, c0] = func_EM_PhysicalConstants() ;

% Load first segment generalized matrix.
seg_matrix = load(seg_dir+"/"+segment_names(1)) ;

% Retrieve sample frequencies and number of samples.
freqs = seg_matrix.f ;
N_f = length(freqs) ;

% Retrieve number of segments.
N_segs = length(segment_names) ;

% Construct array of segment lengths and populate first element.
L_segs = zeros(1,N_segs) ;
L_segs(1) = seg_matrix.Length ;

% Calculate number of modes from GM of first segment.
N_size  = length(seg_matrix.S(1,1,:)) ;
N_modes = (N_size-1)/2 ;

% Construct path for orthogonal matrices file.
orthogonal_matrices_path = orthogonal_matrices_dir + "/" + ...
    N_segs + "segments_" + N_modes + "modes" ;

% Load permutation matrix, P, and feedback matrix, F.
load(orthogonal_matrices_path, 'P', 'F')

% Total number of all internal modes being concatenated throughout entire structure.
N_intmodes = length(F) ;  %   includes both ports, i.e. N_intmodes = 2*N_int, usually.

% Intialize final generalized matrix for complete path.
S = complex(zeros(N_f,N_size,N_size)) ;


%%% Carry out CSC-beam for each sample frequency.
for fi = 1:N_f
        
    % Initialize block matrix and phase array.
    S_tot    = [] ;
    phi_segs = zeros(1,N_segs) ;
    
    
    % Cycle through all segments to create block S matrix, S_tot, and arrays for length and phi.
    for segi=1:N_segs
        
        % Load S-matrix.
        seg_matrix = load(seg_dir+"/"+segment_names(segi)) ;
        
        % S block diagonal matrix.
        S_tot = blkdiag(S_tot, squeeze(seg_matrix.S(fi,:,:))) ;
        
        % Retrieve segment length.
        L_segs(segi) = seg_matrix.Length ;
        
        % Phase at end of each segment.
        phi_segs(segi) = func_CalcPhase(deg2rad(freqs(fi)), sum(L_segs(1:segi)), 0, c0) ;
        
    end
        
    % Create matrix for applying phase adjustment (ignoring downstream ext. port)
    M = func_ConstructM(phi_segs, N_modes) ;
    
    % Reorder block matrix according to internal and external quantities
    % and according to current and voltages.
    G = func_CalcG(S_tot, P) ;
    
    % Determine generalized matrices of the concatenated structure.
    S(fi,:,:) = func_CalcSfinal(M, G, F, N_intmodes) ;
    
end

% Sum lengths for total length.
Length = sum(L_segs) ;

end

