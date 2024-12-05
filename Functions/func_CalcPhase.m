function phase = func_CalcPhase(freq, distance, phi0, speed)
% Function to return phase of a wave of a given frequency after travelling a given distance 
% at a given speed. All parameters must be either vectors or matrices of common size, or otherwise
% singles.
% Note: phi0 and freq assumed to be in radians.
%
% :param freq: Wave frequency in Hz (N-by-M or single).
% :type  freq: double
% :param distance: Distance travelled (N-by-M or single).
% :type  distance: double
% :param phi0: Phase at zero distance (N-by-M or single).
% :type  phi0: double
% :param speed: Speed of propagation (N-by-M or single).
% :type  speed: double
%
% :returns: phase (N-by-M)

phase = phi0 + 2*pi*freq.*distance./speed ;

end