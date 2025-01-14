%% Constructs permutation matrices P and F for Scsc_Script.m
% ==========================================================
%
% From user input relating to the problem, this script calculates the permutation
% matrices needed to carry out CSC-beam (Ref. 1) and stores them in a single .mat file in the 
% user-given directory.
% 
% Created by Alistair Muir, January 2024.
% Last updated by Alistair Muir, June 2024.
%
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen, E. Gjonaj, H.W. Glock - 2020


%% Add dependent paths
addpath("Configs")
addpath("Functions")


%% Load config file
Config_OrthogonalMatrix


%% Call function
[P,F] = func_OrthoMatrices(N_ext, N_int, N_segs) ;


%% Save P and F matrices
% Check given folder exists, and if not, create it.
if ~exist(save_dir, 'dir')
    mkdir(save_dir)
end

% Create directory for saving .mat in save_dir 
% (assumes N_ext and N_int are the same - to be updated later). !!!!!!!!!!!
save_path = save_dir+"/"+N_segs+"segments_"+N_ext+"modes" ;

% Save the .mat file.
save(save_path,'P','F')


%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%



