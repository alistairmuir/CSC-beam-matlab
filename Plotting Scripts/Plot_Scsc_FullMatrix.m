%% Script to plot full S matrix from CSC-beam.

% Add paths to matrices and results for easy access to all S matrices.
addpath(genpath("Matrices"))
close all
clear all

%% USER INPUT
% Choose which plots to include in graph (edit the switch cases below).
choose_plots = [2,3] ;

% Adjust legend for above plots (include empty entry in between CSC plots
% to avoid including cut-off frequency plots in legend).
legend_labels = ["Tom CSC", "", "Ali CSC", "", "Direct (CST)"] ;
legend_labels = ["CSC^{Beam}", "", "Direct (CST)"] ;

% Include cut-off frequency line?
plot_fco = true ;
wake_dir = "CST Files/2Pillbox/Wake/Export" ;
Pmodes   = 3 ;

% Include legend on every plot?
legend_on = true ;

% Plot full S matrix or z_b only?
plot_full = true ;

%%% Plot bits
figi = 1 ;
plot_switch = "mag" ;
f_label = "GHz" ;

% Plotting aesthetics
plt_fontsize = 10 ;
y_axis_limits = [0,0] ;


%% FOR loop through all desired results.
for which_plot = choose_plots
    switch which_plot
        case 1
            %%% S-matrix 1
            S_dir = "Matrices/Thomas/Alistair/2cavity_Thomas" ;
            clear_plots = true ;
            
            marker_col = '#003' ;
            marker_size = 5 ;
            mkr = 'o' ;
        
        case 2
            %%% S-matrix 2
            S_dir = "Matrices/2Pillbox/Generalized_Matrices/2pillbox_15GHz_TM01_March" ;
            clear_plots = false ;

            marker_col = '#A0A' ;
            marker_size = 8 ;
            mkr = 'x' ;
        
        case 3
            %%% Directory for the S-matrix .mat file (and CST export folder for f_co).
            S_dir = "Matrices/2Pillbox/Generalized_Matrices/2pillbox_direct_TM01_Dec5" ;
            clear_plots = false ;

            marker_col = '#3B3' ;
            marker_size = 8 ;
            mkr = 'k-' ;
    end

    %%% Import
    % Load S matrix, with frequencies and Length.
    load(S_dir)
    
    
    %%% Plotting
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
end

%%%%%%%%%%%%   END   %%%%%%%%%%%%