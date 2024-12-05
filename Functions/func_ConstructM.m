function M = func_ConstructM(phi_segs, N_ext)
% A function to construct the phase-adjustment M matrix in CSC-beam method given in ref [1].
%
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen, E. Gjonaj, H.W. Glock - 2020
%
% :param phi_segs: Array of phase angles for port 2 of all segments.
% :type  phi_segs: double array
% :param N_ext: Number of external port modes to be concatenated.
% :type  N_ext: integer
% 
% :returns: M (2*N_ext-by-2*N_ext+1)


% Array containing the phases at beginning of all segments.
d = [1, exp(-1i*phi_segs)] ;

% Create matrix for applying phase adjustment.
% (Applying factor of two for the two ports.)
M = blkdiag(eye(2*N_ext), d(:)) ;

end