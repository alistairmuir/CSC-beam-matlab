function [mu0, eps0, c0] = func_EM_PhysicalConstants()
% This function returns the following physical constants:
%
%  - vacuum permeability,  mu0 (N/A^2)
%  - vacuum permittivity, eps0 (F/m)
%  - vacuum speed of light, c0 (m/s)
%
% :returns: mu0, eps0, c0

mu0  = 1.25663706212*1e-6 ;  %  N/A^2, vacuum permeability.
eps0 = 8.854187*1e-12 ;      %  F/m, vacuum permittivity.
c0   = 1./sqrt(mu0*eps0) ;   %  m/s, speed of light in vacuum.
end
