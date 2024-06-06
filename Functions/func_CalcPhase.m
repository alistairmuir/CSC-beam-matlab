function phase = func_CalcPhase(freq, distance, phi0, speed)
% Function to return phase of a wave of a given frequency after travelling a given distance 
% at a given speed. If inputs are arrays, they must be the same length.
% Note: phi0 and freq assumed to be in radians.
%
% :param freq: Wave frequency.
% :type freq: double
% :param length: Distance travelled.
% :type length: double
% :param phi0: Phase at zero distance.
% :type phi0: double
% :param speed: Speed of propagation.
% :type speed: double
%
% :returns: phase

phase = phi0 + freq.*distance./speed ;
end