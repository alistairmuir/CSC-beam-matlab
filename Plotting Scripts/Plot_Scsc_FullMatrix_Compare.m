%% Script to plot full S matrix from CSC-beam.

% Add paths to matrices and results for easy access to all S matrices.
addpath("Functions")
addpath(genpath("Matrices"))


%% USER INPUT
%%% Plot bits
figi = 1 ;

plot_switch = "real" ;
clear_plots = false ;

marker_col = '#000' ;
marker_size = 8 ;
mkr = 'o' ;

y_axis_limits = [0,0] ;
f_label = "GHz" ;
legend_labels = ["Diffs"] ;


%%% Import GM #1
% Directory and graph appearance
S_dir1 = "Matrices/2Pillbox/Generalized_Matrices/2pillbox_direct_TM01_Dec5" ;

% Directory and graph appearance
S_dir2 = "Matrices/2Pillbox/2pillbox_TM01_Dec5" ;


%% Load S matrix.
load(S_dir1)
S1 = S ;
f1 = f ;
Nf1 = length(f1) ;
choose_f1 = 1:Nf1 ;

load(S_dir2)
S2 = S ;
f2 = f ;
Nf2 = length(f2) ;
choose_f2 = 4:Nf2 ;


%% Check freqs match
if any(f1(choose_f1) ~= f2(choose_f2))
    disp("FREQUENCIES DO NOT MATCH FOR BOTH S-MATRICES")
    return
end


%% Select like-freqs.
S1 = S1(choose_f1,:,:) ;
f  = f1(choose_f1:end) ;

S2 = S2(choose_f2,:,:) ;


%% Calculate differences
S = func_CalcDiffs(S1,S2) ;


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