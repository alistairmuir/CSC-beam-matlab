function [S_dir, E1_dir, E2_dir] = func_CSTfilenames_Freq(freq_dir, freq1, Pmodes)
% 
% 
% 
% returns: strings for filenames of wake_Z, current, o1, o2

% S-parameters
S_dir = freq_dir+"/S-Parameters/" ;

% E-field directories for both ports, all modes (freq. domain sim).
E1_dir = freq_dir+"/e-field (f="+freq1+") (1("+Pmodes+"))_Z (Z)/" ;
E2_dir = freq_dir+"/e-field (f="+freq1+") (2("+Pmodes+"))_Z (Z)/" ;

end