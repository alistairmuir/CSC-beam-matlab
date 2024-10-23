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


%% Number of things
% Number of external modes.
N_ext = 8 ;

% Number of internal modes.
N_int = 8 ;

% Number of segments to be concatenated.
N_segs  = 2 ;


%% Directory for results
% Note: Filename is automatic, and includes number of modes and segments.
save_dir = "Matrices/Pillbox/Orthogonal_Matrices" ;

