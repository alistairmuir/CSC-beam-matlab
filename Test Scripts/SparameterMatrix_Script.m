%% Generate S-parameter matrices from generalized matrices.
clc; clear
addpath('Functions')

%% USER INPUT
% Directory to stored GM
gm_dir = "Matrices/Pillbox/Generalized_Matrices/pillbox_3TM_hifi_new" ;

% Save directory
save_dir      = "Matrices/Pillbox/Generalized_Matrices/" ;
save_filename = "pillbox_3TM_NoBeam" ;


%% Load GM and remove beam elements.
% Import generalized matrix
load(gm_dir) ;

% Remove beam elements (k, h, z_b)
S = S(:, 1:end-1, 1:end-1) ;


%% Store new matrix
func_SaveGM(save_dir, save_filename, S, f, Length) ;