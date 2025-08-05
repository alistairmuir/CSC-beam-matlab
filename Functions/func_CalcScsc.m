function [S, freqs, Length] = func_CalcScsc(seg_dir, segment_names, N_modes, orthogonal_matrices_path)
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
% :param N_modes: 2D-array giving number of port modes for all segments in the form:
%                 [port1(seg1,seg2,...) ;
%                  port2(seg1,seg2,...) ]
% :type N_modes: integer
% :param orthogonal_matrices_path: Filepath to file containing orthogonal matrices P and F.
% :type  orthogonal_matrices_path: string
% 
% :returns: S (N-by-M-by-M), freqs (N-by-1), Length


% Physical constants
[~, ~, c0] = func_EM_PhysicalConstants() ;


%%% Initialization
% Retrieve number of segments.
N_segs = length(segment_names) ;

% Total numbers of internal and external modes
N_intmodes = sum([N_modes(1,2:end), N_modes(2,1:end-1)]) ;
N_extmodes = N_modes(1,1) + N_modes(2,end) ;

% Initialize array for segment lengths.
L_segs = zeros(1,N_segs) ;

% Intialize struct for storing S-matrices for all segments.
seg_matrix = struct ;

% Retrieve S-matrices and physical lengths for all segments.
for segi=1:N_segs
    seg_struct = load(seg_dir+"/"+segment_names(segi)) ;
    
    % Store GM in a struct array.
    seg_matrix(segi).S = seg_struct.S ;
    seg_matrix(segi).f = seg_struct.f ;
    
    % Store segment lengths in an array for easy summing.
    L_segs(segi) = seg_struct.Length ;
end

clear seg_struct   % remove temporary struct from memory.

% Number of frequency samples.
N_f = length(seg_matrix(1).f) ;

% Sum lengths for total length of structure.
Length = sum(L_segs(:)) ;

% Intialize final S-matrix 
S = complex(zeros(N_f, N_extmodes+1, N_extmodes+1)) ;

% Load permutation matrix, P, and feedback matrix, F.
load(orthogonal_matrices_path, 'P', 'F')


%%%% SANITY CHECKS
% Check the length of N_modes is the same as the length of the list of segment names.
if length(N_modes(1,:)) ~= N_segs
    error("Length of N_modes does not match number of segments.")
end

% For each segment, carry out checks.
for ii=1:N_segs-1
    % Check that number of modes match for each port 
    if N_modes(2,ii)~=N_modes(1,ii+1)
        error("Number of modes between segments "+num2str(ii)+" and "+num2str(ii+1)+" do not match.")
    end

    % Check sample frequencies for all segments are the same.
    if isequal(seg_matrix(ii).f, seg_matrix(ii+1).f)
        error('Inconsistent frequencies in segment S-matrices.');
    end
end

% Check orthogonal matrices sizes
if N_intmodes ~= length(F)
    error("Orthogonal matrix, F, is the wrong size.")
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CSC-BEAM for each frequency sample
for fi = 1:N_f
        
    % Initialize block matrix and phase array.
    S_tot    = [] ;
    phi_segs = zeros(1,N_segs) ;
    
    
    % Cycle through all segments to create block S matrix, S_tot, and arrays for length and phi.
    for segi=1:N_segs
        
        % S block diagonal matrix.
        S_tot = blkdiag(S_tot, squeeze(seg_matrix(segi).S(fi,:,:))) ;
                
        % Phase at end of each segment.
        phi_segs(segi) = func_CalcPhase(seg_matrix(1).f(fi), sum(L_segs(1:segi)), 0, c0) ;
        
    end
    
    % Create matrix for applying phase adjustment at each port 1.
    M = func_ConstructM(phi_segs(1:end-1), N_extmodes) ;
    
    % Reorder block matrix according to internal and external quantities
    % and according to current and voltages.
    G = func_CalcG(S_tot, P) ;
    
    % Determine generalized matrices of the concatenated structure.
    S(fi,:,:) = func_CalcSfinal(M, G, F) ;
    
end
end

