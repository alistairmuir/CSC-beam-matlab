%% Script to compare beam impedances from S_CSC calculations with numerical results.
clear
clc


%% Load S_csc and direct wakes
pmode = [1:8] ;

S1 = load("Results/Pillbox/Z_2pillbox_TM01_hifi_new.mat");
    Slabel_a(1) = "TM01" ;
    
S2 = load("Results/Pillbox/Z_2pillbox_3TM_hifi_new.mat");
    Slabel_a(2) = "3 TM" ;

%%% Import direct simulation no.1
S_direct1 = readmatrix("CST Files/Pillbox/Z_2pillbox_10GHz_15cpw_10modes_100k_10sigma.txt") ;
S_d1.f = S_direct1(:,1) ;
S_d1.S = S_direct1(:,2) + 1i*S_direct1(:,3) ;
Slabel_a(3) = "Direct" ;

%%% Import direct impedance for 1 pillbox
S_d3 = load("Matrices/Pillbox/Generalized_Matrices/pillbox_TM01_10GHz_15cpw") ;
Slabel_b(1) = Slabel_a(2) ;
Slabel_b(2) = Slabel_a(3) ;

%%% Turn on one-cavity plot
plot_1cav = true ;
d3_factor = 2 ;   % Multiply 1-cavity direct impedance for comparison.
Slabel_b(3) = "Direct: 1 cavity x "+d3_factor ;

%%% Plotting units
convert_dB = true ; % true=convert to dB, false=plot magnitude.


%% Cut-off freq
% Choose port mode for which the cut-off frequency will be plotted.
plt_port  = 1 ;

% Filename for cut-off frequency.
file_fco = "CST Files/Pillbox/Wake_10GHz_15cpw_8modes_10sigma/Export/Port Information/Cutoff Frequency/"+...
    plt_port+"("+pmode+").txt" ;

for ii=1:length(pmode)
    f_co(ii) = load(file_fco(ii)) ;
end


%% Interpolate direct result for error calculation
Sd1_interpolant = griddedInterpolant(S_d1.f*1e9,S_d1.S) ;
Sd1_terp        = Sd1_interpolant(S1.f) ;

%%% Calc difference
S_diff = S2.S(:,end,end) - Sd1_terp ;
%Slabel(pii) = "Error on "+Slabel(2) ;


%% Convert dB
if convert_dB==true
    S1_plot  = squeeze(20*log10(abs(S1.S(:,end,end)))) ;
    S2_plot  = squeeze(20*log10(abs(S2.S(:,end,end)))) ;

    Sd1_plot      = squeeze(20*log10(abs(S_d1.S))) ;
    S_diff_plot   = squeeze(20*log10(abs(S_diff))) ;
    
    Sd3_plot = squeeze(20*log10(d3_factor*abs(S_d3.S(:,end,end)))) ;
    ylimits   = [-10,100] ;
    imp_units = "|\Omega|dB" ;

else
    S1_plot  = squeeze(abs(S1.S(:,end,end))) ;
    S2_plot  = squeeze(abs(S2.S(:,end,end))) ;
    
    Sd1_plot    = squeeze(abs(S_d1.S)) ;
    S_diff_plot = squeeze(abs(S_diff)) ;
    
    Sd3_plot = squeeze(d3_factor*abs(S_d3.S(:,end,end))) ;
    ylimits  = [min([S1_plot(:) ; S2_plot(:) ; Sd1_plot(:)]), ...
                10*max([S1_plot(:) ; S2_plot(:) ; Sd1_plot(:)])] ;

    imp_units = "|\Omega|" ;
end


%% Plots
%%% Beam impedance
figure(10); clf

hold on

plot(S1.f./1e9,  S1_plot, 'bx', 'LineWidth', 1.5)
plot(S2.f./1e9,  S2_plot, 'rx', 'LineWidth', 1)
plot(S_d1.f,    Sd1_plot,  'k')
%plot(S_d3.f./1e9,    Sd3_plot, 'k--', 'LineWidth', 1)
%plot(S1.f./1e9, S_diff_plot, 'kx', 'LineWidth', 0.5)

for ii=1:length(pmode)
    xline(f_co(ii),":",'Color',[0,(ii+1)/(length(pmode)+1),0], 'LineWidth', 1.5)
end

hold off

ax1 = gca ;
ax1.FontSize = 12 ;

xlim([0,10])
ylim(ylimits)

if convert_dB == false
    set(gca, 'YScale', 'log')
end

grid on
grid minor

legend(Slabel_a, 'FontSize', 9, 'Location', 'northeast')

xlabel("Frequency / GHz")
ylabel("Impedance / "+imp_units)


%%% Phase
figure(20); clf

hold on
plot(S1.f./1e9, squeeze(rad2deg(angle(S1.S(:,end,end)))), 'bx',  'LineWidth', 1.5)
plot(S2.f./1e9, squeeze(rad2deg(angle(S2.S(:,end,end)))), 'rx',  'LineWidth', 1)
plot(S_d1.f, squeeze(rad2deg(angle(S_d1.S))), 'k')
plot(S_d3.f/1e9, squeeze(rad2deg(angle(S_d3.S(:,end,end)))), 'k--', 'LineWidth', 1)
for ii=1:length(pmode)
    xline(f_co(ii),":",'Color',[0,(ii+1)/(length(pmode)+1),0], 'LineWidth', 1.5)
end

hold off

ax2 = gca ;
ax2.FontSize = 12 ;

grid on
grid minor

legend(Slabel_a, 'FontSize', 9, 'Location', 'northwest')

xlim([0,10])
ylim([-200,200])
xlabel("Frequency / GHz")
ylabel("Phase / \circ")


if plot_1cav==true
    %%% Beam impedance
    figure(11); clf

    hold on
    
    plot(S2.f./1e9,   S2_plot,  'rx', 'LineWidth', 1)
    plot(S_d1.f,      Sd1_plot, 'k')
    plot(S_d3.f./1e9, Sd3_plot, 'k--', 'LineWidth', 1)
    %plot(S1.f./1e9,   S_diff_plot, 'kx', 'LineWidth', 0.5)

    for ii=1:length(pmode)
        xline(f_co(ii),":",'Color',[0,(ii+1)/(length(pmode)+1),0], 'LineWidth', 1.5)
    end

    hold off

    ax1 = gca ;
    ax1.FontSize = 12 ;

    xlim([0,10])
    ylim(ylimits)

    if convert_dB == false
        set(gca, 'YScale', 'log')
    end

    grid on
    grid minor

    legend(Slabel_b, 'FontSize', 9, 'Location', 'northeast')

    xlabel("Frequency / GHz")
    ylabel("Impedance / "+imp_units)


    %%% Phase
    figure(21); clf

    hold on
    
    plot(S2.f./1e9,  squeeze(rad2deg(angle(S2.S(:,end,end)))), 'rx',  'LineWidth', 1)
    plot(S_d1.f,     squeeze(rad2deg(angle(S_d1.S))), 'k')
    plot(S_d3.f/1e9, squeeze(rad2deg(angle(S_d3.S(:,end,end)))), 'k--', 'LineWidth', 1)
    
    for ii=1:length(pmode)
        xline(f_co(ii),":",'Color',[0,(ii+1)/(length(pmode)+1),0], 'LineWidth', 1.5)
    end

    hold off

    ax2 = gca ;
    ax2.FontSize = 12 ;

    grid on
    grid minor

    legend(Slabel_a, 'FontSize', 9, 'Location', 'northwest')

    xlim([0,10])
    ylim([-200,200])
    xlabel("Frequency / GHz")
    ylabel("Phase / \circ")

end