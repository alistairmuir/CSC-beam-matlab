function phase = func_CalcPhase(freq, distance, phi0, speed)
% Function to return phase of a wave of a given frequency
% after travelling a given distance at a given speed.
% Note: Conversion to radians (2*pi) is applied.
%
% :param freq: Wave frequency.
% :param length: Distance travelled.
% :param phi0: phase at zero distance.
% :param speed: Speed of propagation.
%
% :returns: phase

phase = phi0 + 2*pi*freq*distance/speed ;
end