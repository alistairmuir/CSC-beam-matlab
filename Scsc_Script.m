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

% Return freqs to CST units for plotting.
f = f./f_CST2SI ;

% Plot Mag/Phase or Real/Imag depending on the plot switch.
switch plot_switch
    case "mag" || "phase"
    % Run plotting script for Mag/Phase plots.
    Plot_GeneralizedMatrix
    
    case "real" || "imag" || "reim" || "ReIm"
    % Run plotting script for Real/Imag plots.
    Plot_GeneralizedMatrix_ReIm
end

%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

