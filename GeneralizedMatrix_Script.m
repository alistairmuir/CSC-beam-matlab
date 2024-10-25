%% Script to produce a generalized S-parameter matrix
% 
% Script to retrieve CST results from Hi-Freq and Wakefield simulations,
% calculate all unknown elements of S_csc for the simulation's frequency
% range and subsequently construct the S_csc.
% 
% The resultant S matrix can be used in Scsc_Script.m to carry out CSC-beam, see Ref. [1].
% 
% Created by Alistair Muir, August 2023
% Last updated by Alistair Muir, June 2024
% 
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen et al - 2020

clear
clc


%% Add dependent paths
addpath("Functions")
addpath("Plotting Scripts")
addpath("Configs")



%% Run configuration script
Config_GeneralizedMatrix



%% Run GM function
[S, Length] = func_CalcGM(wake_dir, freq_dir, ...
    freqs_FM, freqs_GM, ...
    f_CST2SI, s_CST2SI, m_CST2SI, ...
    Pmodes, Length, ...
    import_FFT, ...
    f_label) ;
 


%% Save the matrix and corresponding frequencies
func_SaveGM(save_dir, save_filename, S, func_ConvertUnits(freqs_GM, f_CST2SI), Length)



%% Plot
if plot_on
    % Return freqs to CST units for plotting.
    f = freqs_GM ;
    
    % Run plotting script
    Plot_GeneralizedMatrix
end


%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

