function M = func_ConstructM(phases, N_ext)
% A function to construct the phase-adjustment M matrix in CSC-beam method given in ref [1].
%
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen, E. Gjonaj, H.W. Glock - 2020
%
% :param phases: Array of phase angles for all internal ports.
% :type  phases: double array
% :param N_ext: Number of external port modes.
% :type  N_ext: integer
% 
% :returns: M (N_ext-by-N_ext+1)


% Array containing the phases at beginning of all segments.
d = [1, exp(-1i*phases)] ;

% Create matrix for applying phase adjustment.
% (Applying factor of two for the two ports.)
M = blkdiag(eye(N_ext), d(:)) ;

end