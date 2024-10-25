function [wake_Z_dir, current_dir, o1_dir, o2_dir] = func_CSTfilenames_Wake(wake_dir, Pmodes)
% 
% 
% 
% returns: strings for filenames of wake_Z, current, o1, o2

% Wakefield and current
wake_Z_dir  = wake_dir+"/Particle Beams/ParticleBeam1/Wake impedance/Z.txt" ;
current_dir = wake_dir+"/Particle Beams/ParticleBeam1/Current.txt" ;

% Port signals directories, all modes (wake sim)
o1_dir = wake_dir+"/Port signals/o1("+Pmodes+"),pb.txt" ;
o2_dir = wake_dir+"/Port signals/o2("+Pmodes+"),pb.txt" ;


end