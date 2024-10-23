%% Script to plot a number of beam impedances from S_csc results.
clear
clc
rng(10)


%% Load S_csc and direct wakes
%%% Load results
S1 = load("Results/Pillbox/Z_2pillbox_TM_test2.mat");

%%% Plot in decibels or magnitude
decibles = true ;


%% Unpack S
f = S1.f ;
S_phase = squeeze(rad2deg(angle(S1.S))) ;

if decibles==true
    S = squeeze(20*log(abs(S1.S))) ;
    yaxis_maglabel = "Magnitude / XdB" ;
else
    S = abs(S1.S) ;
    yaxis_maglabel = "Absolute Magnitude" ;
end

clear S1


%% Plots
S_size   = length(S(1,1,:)) ;
plt_char = repmat(['o', 'd', 'x'],1,3) ;
plt_col =  [0.7713    0.7488    0.1981    0.0883    0.0000 ;
            0.0208    0.4985    0.7605    0.6854    0.3000 ;
            0.6336    0.2248    0.1691    0.9534    0.8126] ;

%plt_col = 0.9*[0.2,ij,ij]/S_size ;
%ledg = repmat("",1,S_size.^2) ;
%ledg(i) = "S("+ii+", "+ij+")" ;


%% Magnitudes (in dB)
for ii=1:S_size
    figure(ii); clf

    hold on
    i=1;
    ledg = repmat("",1,S_size) ;

    for ij=1:S_size
        plot(f./1e9*(1+0.01*ij), S(:,ii,ij), ...
            plt_char(1), ...
            'MarkerSize', 10, ...
            'MarkerEdgeColor', plt_col(:,ij), ...
            'MarkerFaceColor', plt_col(:,ij))
        
        ledg(i) = "S("+ii+", "+ij+")" ;
        i=i+1;
    end
    
    hold off

    ax1 = gca ;
    ax1.FontSize = 12 ;

    if decibles
        set(gca, 'YScale', 'log')
    end
    
    grid on
    grid minor

    legend(ledg)
    xlim([0,1])
    %ylim([-20,120])
    %xlabel("Frequency / GHz")
    ylabel(yaxis_maglabel)

end


%% Phase
figure(20); clf
hold on
for ii=1:S_size
    for ij=1:S_size
        plot(f./1e9, S_phase(:,ii,ij), ...
            plt_char(ii), ...
            'MarkerSize', S_size+15-ii*3, ...
            'MarkerEdgeColor', plt_col(:,ij), ...
            'MarkerFaceColor', [0.7,1,1])
    end
end
hold off

legend(ledg)

ax2 = gca ;
ax2.FontSize = 12 ;

grid on
grid minor

%xlim([0,10])
%ylim([-200,200])
xlabel("Frequency / GHz")
ylabel("Phase / \circ")

