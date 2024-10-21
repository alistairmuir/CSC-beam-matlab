function S = func_CalcSfinal(M, G, F, N_intmodes)
% A function to calculate the final generalized matrix as given CSC-beam method given in ref [1].
%
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen, E. Gjonaj, H.W. Glock - 2020
%
% :param M:
% :type  M:
% :param G:
% :type  G:
% :param F:
% :type  F:
% :param N_intmodes:
% :type  N_intmodes:
% 
% :returns: S (N+1-by-N+1, where N = number of external modes)


% Split block matrix G into quadrants ready for concatenation (Ref. [1])
G11 = G(1:N_intmodes, 1:N_intmodes) ;
G12 = G(1:N_intmodes, 1+N_intmodes:end) ;

G21 = G(1+N_intmodes:end, 1:N_intmodes) ;
G22 = G(1+N_intmodes:end, 1+N_intmodes:end) ;

% Calculate the generalized matrix by mode-matching the internal modes, adding them to the external
% modes, and applying the phase-adjustment by matrix-multiplying with M (Ref. [1]).
% Note: M' == the Hermitian of M.
S = M'*(G22+G21*((F-G11)\G12))*M ;

end