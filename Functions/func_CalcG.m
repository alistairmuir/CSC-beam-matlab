function G = func_CalcG(S_tot, P)
% A function to calculate the G matrix in CSC-beam method given in ref [1].
%
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen, E. Gjonaj, H.W. Glock - 2020
%
% :param S_tot: Block diagonal matrix containing unaltered generalized matrices of all segments.
% :type  S_tot: double
% :param P: Permutation matrix as defined in ref [1].
% :type  P: integer
% 
% :returns: G (size of S_tot)

% Reorder block matrix according to internal and external quantities
% and according to current and voltages.
G = P*S_tot*P' ;

end