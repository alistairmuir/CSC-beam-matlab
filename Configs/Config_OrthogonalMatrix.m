%% Configuration file for OrthogonalMatrices_Script.m
%  ==================================================
%
% This script constructs and saves orthogonal matrices P and F.
% 
% From user input given here, the script calculates the permutation matrices needed to carry
% out CSC-beam and stores them in a single .mat file in the user-given directory. The saved matrices 
% are ready to be loaded and used by Scsc_Script.m.
%
% :param N_ext: Number of external modes included in all generalized matrices.
% :type  N_ext: integer
% :param N_int: Number of internal modes included in all generalized matrices.
% :type  N_int: integer
% :param N_segs: Number of segments to be concatenated.
% :type  N_segs: integer
% :param save_dir: Directory in which the permutation matrices will be saved.
% :type  save_dir: string

% Problem name (used only for defining save_dir in this config file.)
problem_name = "Pillbox" ;


%% Number of things
% Number of external modes.
N_ext = 10 ;

% Number of internal modes.
N_int = 10 ;

% Number of segments to be concatenated.
N_segs  = 2 ;


%% Save results
% Create full filepath for these matrices.
save_dir = "Matrices/"+problem_name+"/Orthogonal_Matrices" ;



