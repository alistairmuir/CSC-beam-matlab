%% Script to plot full S matrix from Thomas results.

% Add paths to matrices and results for easy access to all S matrices.
addpath(genpath("Matrices"))
addpath(genpath("Results"))


%% USER INPUT
% Directory for the S-matrix .mat file
S_dir = "Matrices/Thomas/Alistair/2cavityCSC_BEAM_Alistair" ;

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
else
    f_CST2SI = 1 ;
end

f = f./f_CST2SI ;

% Plotting bits
figi = 1 ;
clear_plots =  true ;
marker_col  = '#A0A' ;
mkr         = 'X' ;
marker_size = 10 ;
legend_labels = "Thomas" ;

Plot_GeneralizedMatrix


%%% Comparing k and h elements.
% figure(3); clf
% hold on
% plot(f,(abs(S(:,3,1))), 'ro')
% plot(f,(abs(S(:,1,3))), 'bx')
% grid on
% grid minor
% set(gca,'YScale','log')
% legend(["S(3,1)","S(1,3)^H"])
% xlabel("Frequency / GHz")
% ylabel("Amplitude / dB")
% 
% figure(4); clf
% hold on
% plot(f, rad2deg(angle(S(:,3,1))), 'ro')
% plot(f, rad2deg(angle(squeeze(S(:,1,3))')), 'bx')
% grid on
% grid minor
% legend(["S(3,1)","S(1,3)^H"])
% xlabel("Frequency / GHz")
% ylabel("Phase / \circ")

%%%%%%%%%%%%   END   %%%%%%%%%%%%