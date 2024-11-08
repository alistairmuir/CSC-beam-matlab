%% Script to plot full S matrix from CSC-beam.
clc
clear

% Add paths to matrices and results for easy access to all S matrices.
addpath(genpath("Matrices"))
addpath(genpath("Results"))


%% USER INPUT
% Directory for the S-matrix .mat file
S_dir = "Z_2pillbox_TM01" ;

% Plot limits
y_axis_limits = [0,0] ;
f_label = "GHz" ;
 

%% Import
% Load S matrix, with frequencies and Length.
load(S_dir)


%% Plotting
% Convert freqs to correct plotting units (CST).
if f_label=="GHz"
    f_CST2SI = 1e9 ;
end

f = f./f_CST2SI ;

Plot_GeneralizedMatrix


%% Display S for a single frequency
disp(S(1,:,:))


%%%%%%%%%%%%   END   %%%%%%%%%%%%

