%% Script for plotting the generalized matrix (real and imag)
% 
% This script is called by both GeneralizedMatrix_Script.m and Scsc_Script.m.
% It assumes the generalized matrix is held in variable, S.
%
% Two plots showing whole matrix, the first plot showing magnitude and the second showing
% phase. Two additional plots show only the beam impedance (lower right subplot of first plots).
%
% :param S: The generalized S-parameter matrix whose data will be plotted (M-by-N-by-N).
% :type  S: double


%% Plotting aesthetics
% Plot full S-matrix or only z_b
if ~exist('plot_full', 'var')
    plot_full = true ;
end

% Font size for all axes.
if ~exist('plt_fontsize', 'var')
    plt_fontsize = 10 ;
end

% Line width for cut-off frequencies.
fco_lw = 1 ;

% Tick marks for x-axis
if ~exist('plt_xticks', 'var')
    plt_xticks = (1:10) ;
end

% Set default y-axis limits if not given.
if ~exist('y_axis_limits', 'var')
    y_axis_limits = [1e-5, 1e5] ;
end

% Figure numbers
if ~exist('figi', 'var')
    figi=1;
end

% Clear figures by default.
if ~exist('clear_plots', 'var')
    clear_plots = true ;
end

% Default marker colour.
if ~exist('marker_col', 'var')
    marker_col = '#A0A' ;
end

% Default marker
if ~exist('mkr', 'var')
    mkr = 'X' ;
end

% Default marker size
if ~exist('marker_size', 'var')
    marker_size = 8 ;
end

% Legend
if ~exist('legend_on', 'var')
    legend_on = true ;
end

if ~exist('legend_labels', 'var')
    legend_labels = 'CSC-beam' ;
end

% Plot cut-off freq
if ~exist('plot_fco', 'var')
    plot_fco = true ;
end


%% Calculations from S matrix
% Get number of port modes, if not already known.
if ~exist('N_modes', 'var')
    switch mod(length(S(1,1,:)),2)
        case 0
            N_modes = length(S(1,1,:))/2 ;   % without beam.
        case 1
            N_modes = (length(S(1,1,:))-1)/2 ;   % with beam.
    end
end


%% Cut-off frequencies
% If the port modes and directory to CST wake simulation results are available, retrieve
% cut-off freqs.
if exist('Pmodes', 'var') && exist('wake_dir', 'var')

    % Default port is port 1.
    if ~exist('plt_port', 'var')
        plt_port = 1 ;
    end
    
    % Construct filenames for cut-off frequencies.
    file_fco = wake_dir+"/Port Information/Cutoff Frequency/"+...
        plt_port+"("+Pmodes+").txt" ;

    % Initialize array for cut_off freqs.
    f_co = zeros(1,length(file_fco)) ;

    % Retrieve cut-off freqs for all modes.
    for fii=1:length(file_fco)
        f_co(fii) = load(file_fco(fii)) ;
    end
    
end


%% Y-axis limits for magnitudes.
if y_axis_limits(1)==0 && y_axis_limits(2)==0
    
    if N_modes==1
        % Default y-axis limits - good for pillbox test case.
        plt_y_mins = [1e-22, 1e-22, 1e-5 ;
                      1e-22, 1e-22, 1e-5 ;
                       1e-5,  1e-5, 1e-3 ] ;

        plt_y_maxs = [ 1e0,  1e0,  1e4 ;
                       1e0,  1e0,  1e4 ;
                       1e4,  1e4,  1e5 ] ;

    else
        % Generate grid of plot limits from default values.
        plt_y_mins = y_axis_limits(1)*ones(2*N_modes + 1) ;
        plt_y_maxs = y_axis_limits(2)*ones(2*N_modes + 1) ;

    end
    
else
    
    % Generate grid of plot limits from user-given values.
    plt_y_mins = y_axis_limits(1)*ones(2*N_modes + 1) ;
    plt_y_maxs = y_axis_limits(2)*ones(2*N_modes + 1) ;

end


%% The plotting
%%% Only plot whole generalized S-matrix if it is not too large.
if N_modes < 3 && plot_full
    
    %%% y-axis units
    yunits = [repmat("",1,2*N_modes), "dB\surd\Omega"] ;
    yunits = repmat(yunits, 2*N_modes, 1) ;
    yunits = [yunits ; repmat("dB\surd\Omega",1,2*N_modes), "dB\Omega"] ;
    
    %%% Plot: generalized matrix magntidue
    figure(figi);
    
    if clear_plots
        clf
    end
    
    for pii=1:2*N_modes+1
        for pjj=1:2*N_modes+1

            %%% Construct labels
            if pii<2*N_modes+1
                if pjj<2*N_modes+1
                    S_symbol = "Real(S_{"+string(pii)+string(pjj)+"})" ;
                else
                    S_symbol = "Real(k_{"+string(pii)+"})" ;
                end
            else
                if pjj<2*N_modes+1
                    S_symbol = "Real(h_{"+string(pjj)+"})" ;
                else
                    S_symbol = "Real(z_b)" ;
                end
            end                

            % Create this element's plot
            plti = (2*N_modes+1)*(pii-1)+pjj ;
            subplot(2*N_modes+1,2*N_modes+1,plti)

            % Plot
            hold on    % Hold on - to allow multiple results.
            plot(f(:),abs(real(S(:,pii,pjj))), mkr, 'MarkerSize', marker_size, 'MarkerEdgeColor', marker_col)
            ylim([plt_y_mins(pii,pjj),plt_y_maxs(pii,pjj)])
            
            grid on
            ax = gca ;
            ax.FontSize = plt_fontsize ;
            xlabel("f / "+f_label, 'FontSize', plt_fontsize)
            ylabel("|"+S_symbol+"| / "+yunits(plti), 'FontSize', plt_fontsize)
            
            xticks(plt_xticks)
            
            if exist('f_co', 'var')
                xline(f_co, 'b--', 'LineWidth', fco_lw)
            end
            
            legend(legend_labels, 'Location', 'southeast')
            set(gca, 'YScale', 'log')
            title(S_symbol)

        end
    end
    
    
    %%% Plot: imag(S)
    figure(figi+1);
    
    if clear_plots
        clf
    end
    
    for pii=1:2*N_modes+1
        for pjj=1:2*N_modes+1

            %%% Construct labels
            if pii<2*N_modes+1
                if pjj<2*N_modes+1
                    S_symbol = "Imag(S_{"+string(pii)+string(pjj)+"})" ;
                else
                    S_symbol = "Imag(k_{"+string(pii)+"})" ;
                end
            else
                if pjj<2*N_modes+1
                    S_symbol = "Imag(h_{"+string(pjj)+"})" ;
                else
                    S_symbol = "Imag(z_b)" ;
                end
            end
            
            % Create this element's plot
            plti = (2*N_modes+1)*(pii-1)+pjj ;
            subplot(2*N_modes+1,2*N_modes+1,plti)
            
            % Plot
            hold on    % Hold on - to allow multiple results.
            plot(f(:), abs(imag(S(:,pii,pjj))), mkr, 'MarkerSize', marker_size, 'MarkerEdgeColor', marker_col)
            
            ylim([plt_y_mins(pii,pjj),plt_y_maxs(pii,pjj)])
            grid on
            
            ax = gca ;
            ax.FontSize = plt_fontsize ;
            xlabel("f / "+f_label, 'FontSize', plt_fontsize)
            ylabel("|"+S_symbol+"| / "+yunits(plti), 'FontSize', plt_fontsize)

            xticks(plt_xticks)

            if exist('f_co', 'var')
                xline(f_co, 'b--', 'LineWidth', fco_lw)
            end
            
            set(gca, 'YScale', 'log')
            legend(legend_labels, 'Location', 'southeast')
            title(S_symbol)
            
        end
    end
            
else
    %%% Just Beam impedance (z_b)
    % Real
    figure(figi);
    if clear_plots
        clf
    end

    hold on    % Hold on - to allow multiple results.
    plot(f(:),abs(real(S(:,end,end))), mkr, 'MarkerSize', 8, 'MarkerEdgeColor', marker_col)
    grid on
    grid minor
    xlabel("f / "+f_label, 'FontSize', plt_fontsize)
    ylabel("|Re(z_b)| / \Omega", 'FontSize', plt_fontsize)

    if exist('plt_xticks', 'var')
        xticks(plt_xticks)
    end

    title("Beam Impedance (Real Component)", 'FontSize', 15)
    set(gca, 'YScale', 'log')
    ylim([plt_y_mins(end,end), plt_y_maxs(end,end)])

    if exist('f_co', 'var') && plot_fco
        xline(f_co, 'b--', 'LineWidth', fco_lw)
    end
    
    ledg = legend(legend_labels, 'Location', 'best') ;
            
    if ~legend_on
        set(ledg,'visible','off')
    end

    % Imag
    figure(figi+1);
    if clear_plots
        clf
    end
    
    hold on    % Hold on - to allow multiple results.
    plot(f(:),abs(imag(S(:,end,end))), mkr, 'MarkerSize', 8, 'MarkerEdgeColor', marker_col)
    grid on
    grid minor
    xlabel("f / "+f_label, 'FontSize', plt_fontsize)
    ylabel("|Im(z_b)| / \Omega", 'FontSize', plt_fontsize)

    if exist('plt_xticks', 'var')
        xticks(plt_xticks)
    end

    title("Beam Impedance (Imaginary Component)", 'FontSize', 15)
    set(gca, 'YScale', 'log')
    ylim([plt_y_mins(end,end), plt_y_maxs(end,end)])

    if exist('f_co', 'var') && plot_fco
        xline(f_co, 'b--', 'LineWidth', fco_lw)
    end
    
    ledg = legend(legend_labels, 'Location', 'best') ;
            
    if ~legend_on
        set(ledg,'visible','off')
    end

end