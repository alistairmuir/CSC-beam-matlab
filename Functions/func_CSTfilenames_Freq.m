function [S_dir, E1_dir, E2_dir] = func_CSTfilenames_Freq(freq_dir, freq1, Pmodes)
% Function that outputs lists of directories for CST results in the CST Navigation
% tree folder structure.
%
% :param freq_dir: Directory containing the CST simulation results in frequency domain.
% :type  freq_dir: string
% :param freq1: First frequency where electric field was monitored (CST uses this frequency
%               for its filename convention.
% :type  freq1: double
% :param Pmodes: List of modes to be included in generalized matrix.
% :type  Pmodes: integer
% 
% 
% :returns: S_dir, E1_dir (Nmodes-by-1), E2_dir (Nmodes-by-1)

% S-parameters
S_dir = freq_dir+"/S-Parameters/" ;

% E-field directories for both ports, all modes (freq. domain sim).
E1_dir = freq_dir+"/e-field (f="+freq1+") (1("+Pmodes+"))_Z (Z)/" ;
E2_dir = freq_dir+"/e-field (f="+freq1+") (2("+Pmodes+"))_Z (Z)/" ;

end