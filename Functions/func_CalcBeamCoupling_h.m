function h = func_CalcBeamCoupling_h(VoltagesFD, portsignalsFD)
% Function to calculate the coupling between port modes and beam current, see
% "Generalization of coupled S-parameter calculation to compute beam impedances
% in particle accelerators" - T. Flisgen et al - 2020
% h(x) = v(x)/a(x)      (See Eq.[1] in Ref [1].)
% Note: input port signals a(x) are normalized to 1 sqrt(W) peak power. See:
% https://space.mit.edu/RADIO/CST_online/...
% ...mergedProjects/3D/special_overview/special_overview_waveguideover.htm
%
% :param VoltagesFD: N-by-M matrix containing freq. domain (FD) beam voltages.
% :type VoltagesFD: complex double
% :param portsignalsFD: N-by-M matrix containing FD port signals.
% :type portsignalsFD: complex double
%
% :returns: h

h = VoltagesFD./portsignalsFD ;
end