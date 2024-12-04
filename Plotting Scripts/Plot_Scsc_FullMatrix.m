%% Script to plot full S matrix from CSC-beam.

% Add paths to matrices and results for easy access to all S matrices.
addpath(genpath("Matrices"))
addpath(genpath("Results"))


%% USER INPUT
% Directory for the S-matrix .mat file
S_dir = "Matrices/2Pillbox/2cavityCSC_BEAM_Alistair" ;

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

% Plotting bits
figi = 1 ;
clear_plots = false ;
marker_col = '#0AD' ;
marker_size = 5 ;
mkr = 'o' ;
legend_labels = ["Thomas", "Alistair", "Alistair"] ;

Plot_GeneralizedMatrix


%%%%%%%%%%%%   END   %%%%%%%%%%%%