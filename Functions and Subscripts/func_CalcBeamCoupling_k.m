function k = func_CalcBeamCoupling_k(portmodesFD, currentFD)
% Function to calculate the coupling between port modes and beam current, see
% "Generalization of coupled S-parameter calculation to compute beam impedances
% in particle accelerators" - T. Flisgen et al - 2020
%   k(x) = b(x)/current     (See Eq.[1])
%
%
% :param portmodesFD: Vector or matrix containing freq. domain (FD) wave amplitudes for
%   one or multiple port modes respectively.
% :type portmodesFD: complex double
% :param currentFD: Vector containing FD current of the beam.
% :type currentFD: complex double
%
% :returns: k

k = portmodesFD./currentFD(:) ;
end