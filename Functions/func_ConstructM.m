function M = func_ConstructM(phi_segs, N_modes)
% A function to construct the phase-adjustment M matrix in CSC-beam method given in ref [1].
%
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen, E. Gjonaj, H.W. Glock - 2020
%
% :param phi_segs: Array of phase angles for port 2 of all segments.
% :type  phi_segs: double array
% :param N_modes: Number of total port modes to be concatenated.
% :type  N_modes: integer
% 
% :returns: M (2*N_modes-by-2*N_modes+1)


% Array containing the phases at beginning of all segments.
d = [1, exp(-1j*phi_segs(1:end-1))] ;

% Create matrix for applying phase adjustment (ignoring downstream ext. port)
M = blkdiag(eye(2*N_modes), d.') ;

end