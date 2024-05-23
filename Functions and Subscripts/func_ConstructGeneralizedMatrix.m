function S = func_ConstructGeneralizedMatrix(Sp, k, h, z_b)
% A function which constructs a generalized matrix for a single frequency from given
% S-parameter matrix, coupling vectors and wake impedance.
%
% :param Sp: S-parameter matrix
% :param k: coupling from beam current to reflected port mode wave amplitudes.
% :param h: coupling from port modes to beam voltage.
% :param z_b: direct beam impedance with no influence from port modes.
%
% :returns: S

% Concatenate S-matrix with k vector.
Sp_k = [Sp, k(:)] ;

% Concatenate S-k-matrix with [h, z_b] horizontal vector ensuring complex conjugate is not taken.
S = [Sp_k ; [h(:).', z_b]] ;

end