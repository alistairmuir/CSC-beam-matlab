%% Script to carry out CSC-Beam method on ready-made generalized matrices
% =======================================================================
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
%
clear
clc


%% Add directories containing dependent functions and configuration files.
addpath("Functions and Subscripts")
addpath("Config Files")


%% RUN CONFIGURATION SCRIPT
Config_Scsc_Pillbox


%% Carry out CSC-beam and return generalized matrix along with freqs and length of structure.
[S, f, Length] = func_CalcScsc(seg_dir, segment_names, orthogonal_matrices_dir) ;


%% Save resultant generalized matrix.
func_SaveGM(save_dir, save_filename, S, f, Length)


%% Plot
if plot_on
    f = f./f_CST2SI ;  % Plotting units == CST units
    Plot_GeneralizedMatrix
end


%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

