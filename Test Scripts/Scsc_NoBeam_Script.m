%% Script to carry out CSC-Beam method on ready-made generalized matrices
% 
% Script to calculate S_csc from S matrices provided by "GeneralizedMatrix_Script.m".
% Adapted from code in SUPPLEMENTARY MATERIAL of Ref. [1].
% 
% Created by Alistair Muir, September 2023
% Last updated by Alistair Muir, June 2024
% 
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen, E. Gjonaj, H.W. Glock - 2020

clear
clc


%% Add dependent paths
addpath("Functions")
addpath("Subscripts")
addpath("Configs")


%% Run configuration script
Config_Scsc_Pillbox_NoBeam


%% Carry out CSC-beam
[S, f, Length] = func_CalcScsc_NoBeam(seg_dir, segment_names, orthogonal_matrices_dir) ;


%% Save new GM
func_SaveGM(save_dir, save_filename, S, f, Length)


%% Plot
if plot_on
    f = f./f_CST2SI ;  % Plotting units == CST units
    Plot_GeneralizedMatrix
end


%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%
