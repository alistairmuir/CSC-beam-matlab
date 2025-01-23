%% Script to compare beam impedances from S_CSC calculations with numerical results.
clear
clc


%% Load S_csc and direct wakes
pmode = [1:3] ;

plotlabels(1) = "Alistair Cylinder" ;
plotlabels(2) = "Thomas Cylinder" ;

S1 = load("Matrices/2Example_CylindricalCavity/2ali_gm_segment_left_1_mode.mat") ;
S2 = load("Matrices/2Example_CylindricalCavity/CylindricalCavity_Thomas_1mode.mat") ;

%%% Turn on one-cavity plot
plot_1cav = false ;

plot_fco = false ;

% Import direct impedance for 1 pillbox
% S2.S = load("Matrices/Pillbox/Generalized_Matrices/pillbox_3TM_hifi_new") ;
% d3_factor = 2 ;   % Multiply 1-cavity direct impedance for comparison.

%%% Plotting units
convert_dB = true ; % true=convert to dB, false=plot magnitude.


%% Cut-off freq
% Choose port mode for which the cut-off frequency will be plotted.
plt_port  = 1 ;

% Filename for cut-off frequency.
file_fco = "CST Files/Pillbox/Wake_10GHz_15cpw_8modes_10sigma/Export/Port Information/Cutoff Frequency/"+...
    plt_port+"("+pmode+").txt" ;

f_co = zeros(1,length(pmode)) ;

for ii=1:length(pmode)
    f_co(ii) = load(file_fco(ii)) ;
end


%% Interpolate direct result for error calculation
Sd1_interpolant = griddedInterpolant(S2.f*1e9,S2.S) ;
Sd1_terp        = Sd1_interpolant(S1.f) ;

%%% Calc difference
S_diff = S1.S(:,end,end) - Sd1_terp ;
%Slabel(pii) = "Error on "+Slabel(2) ;


%% Convert dB
if convert_dB==true
    S1_plot = squeeze(20*log10(abs(S1.S(:,end,end)))) ;
    S2_plot = squeeze(20*log10(abs(S2.S(:,end,end)))) ;

    S_diff_plot = squeeze(20*log10(abs(S_diff))) ;
    
    ylimits   = [-10,100] ;
    imp_units = "|\Omega|dB" ;

else
    S1_plot = squeeze(abs(S1.S(:,end,end))) ;
    S2_plot = squeeze(abs(S2.S(:,end,end))) ;
    
    S_diff_plot = squeeze(abs(S_diff)) ;
    
    ylimits  = [min([S1_plot(:) ; S2_plot(:) ; S2_plot(:)]), ...
                10*max([S1_plot(:) ; S2_plot(:) ; S2_plot(:)])] ;

    imp_units = "|\Omega|" ;

    % S1_plot   = squeeze(20*log10(abs(S1.S(:,end,end)))) ;
    % ylimits   = [-10,100] ;
    % imp_units = "|\Omega|dB" ;
end


%% Plots
%%% Beam impedance
figure(1); clf

hold on

plot(S1.f./1e9, S1_plot, 'bx', 'LineWidth', 1.5)
plot(S2.f./1e9, S2_plot, 'ko')

if plot_fco
    for ii=1:length(pmode)
        xline(f_co(ii),":",'Color',[0,(ii+1)/(length(pmode)+1),0], 'LineWidth', 1.5)
    end
end

hold off

ax1 = gca ;
ax1.FontSize = 12 ;

xlim([min(S1.f),max(S1.f)]/1e9)
ylim(ylimits)

if convert_dB == false
    set(gca, 'YScale', 'log')
end

grid on
grid minor

legend(plotlabels, 'FontSize', 9, 'Location', 'northeast')

xlabel("Frequency / GHz")
ylabel("Impedance / "+imp_units)


%%% Phase
figure(2); clf

hold on
plot(S1.f./1e9, squeeze(rad2deg(angle(S1.S(:,end,end)))), 'bx',  'LineWidth', 1.5)
plot(S2.f./1e9, squeeze(rad2deg(angle(S2.S(:,end,end)))), 'ko')

if plot_fco
    for ii=1:length(pmode)
        xline(f_co(ii),":",'Color',[0,(ii+1)/(length(pmode)+1),0], 'LineWidth', 1.5)
    end
end

hold off

ax2 = gca ;
ax2.FontSize = 12 ;

grid on
grid minor

legend(plotlabels, 'FontSize', 9, 'Location', 'northwest')

xlim([min(S1.f),max(S1.f)]/1e9)
ylim([-200,200])
xlabel("Frequency / GHz")
ylabel("Phase / \circ")
