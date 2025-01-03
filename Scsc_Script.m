%% Script to carry out CSC-Beam method on ready-made generalized matrices
% 
% Script to calculate S_csc from S matrices provided by "GeneralizedMatrix_Script.m".
% Adapted from code in SUPPLEMENTARY MATERIAL of Ref. [1].
% 
% Created by Alistair Muir, September 2023
% Last updated by Alistair Muir, October 2024
% 
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen, E. Gjonaj, H.W. Glock - 2020

clear
clc


%% Add dependent paths
addpath("Functions")
addpath("Plotting Scripts")
addpath(genpath("Configs"))


%% Run configuration script
Config_Scsc


%% Carry out CSC-beam
[S, f, Length] = func_CalcScsc(seg_dir, segment_names, orthogonal_matrices_dir) ;


%% Save new GM
func_SaveGM(save_dir, save_filename, S, f, Length)


%% Plot
if plot_on
    f = f./f_CST2SI ;  % Plotting units == CST units
    figi=5;
    Plot_GeneralizedMatrix
end


%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

