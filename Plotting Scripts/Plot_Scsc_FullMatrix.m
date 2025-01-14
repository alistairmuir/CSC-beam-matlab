%% Script to plot full S matrix from CSC-beam.

% Add paths to matrices and results for easy access to all S matrices.
addpath(genpath("Matrices"))


%% USER INPUT
%%% Directory for the S-matrix .mat file
S_dir = "Matrices/2Pillbox/Generalized_Matrices/2pillbox_direct_TM01_Dec5" ;
marker_col = '#000' ;
marker_size = 8 ;
mkr = 'o' ;

% S_dir = "Matrices/2Pillbox/2pillbox_TM01_Dec5" ;
% marker_col = '#A0A' ;
% marker_size = 8 ;
% mkr = 'x' ;

%%% Plot bits
figi = 1 ;

plot_switch = "real" ;
clear_plots = false ;
y_axis_limits = [0,0] ;
f_label = "GHz" ;
legend_labels = ["Direct", "CSC-beam"] ;


%% Import
% Load S matrix, with frequencies and Length.
load(S_dir)


%% Plotting
% Convert freqs to correct plotting units (CST).
if f_label=="GHz"
    f_CST2SI = 1e9 ;
end

f = f./f_CST2SI ;

switch plot_switch
    case "real"
        Plot_GeneralizedMatrix_ReIm
        
    case "mag"
        Plot_GeneralizedMatrix
end

%%%%%%%%%%%%   END   %%%%%%%%%%%%