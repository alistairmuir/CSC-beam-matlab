%% Script for plotting the generalized matrix
% ===========================================
% 
% This script is called by both GeneralizedMatrix_Script.m and Scsc_Script.m.
% It assumes the generalized matrix is present in the workspace, along with some plotting
% variables.
%
% :param S: The generalized S-parameter matrix (GM) whose data will be plotted (M-by-N-by-N).
% :type S: double


%% Plotting aesthetics
% Font size for all axes.
plt_fontsize = 10 ;

% Line width for cut-off frequencies.
fco_lw = 1 ;

% Y-axes limits
if ~exist('y_axis_limits', 'var')
    % Default plot limits
    y_axis_limits = [-150, 100] ;
end


%% Calculations from S matrix
% Get number of port modes, if not already known.
if ~exist('N_modes', 'var')
    N_modes = (length(S(1,1,:))-1)/2 ;   % assumes number of modes at port1 and port2 are same.
end

% Calc GM magnitude in dB.
S_db = 20*log10(abs(S)) ;

% Calc phase of generalized matrix.
S_phase = rad2deg(angle(S)) ;


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
    
else
    % Set values to draw a zero-width line (avoids more messy IF-statements in the plotting bit).
    f_co   = 0 ;
    fco_lw = 0 ;
end


%% Y-axis limits for magnitudes.
if y_axis_limits(1)==0 && y_axis_limits(2)==0
    
    if N_modes==1
        % T. Flisgen's plot limits
        plt_y_mins = [-150, -100, -50 ;
                      -100, -150, -50 ;
                       -50,  -50, -50 ] ;

        plt_y_maxs = [   0,    0,  100 ;
                         0,    0,  100 ;
                        50,   50,  100 ] ;

    else
        % Default plot limits
        y_axis_limits = [-150, 100] ;

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
if N_modes < 4
    
    %%% y-axis units
    yunits = [repmat("dB",1,2*N_modes), "dB\surd\Omega"] ;
    yunits = repmat(yunits, 2*N_modes, 1) ;
    yunits = [yunits ; repmat("dB\surd\Omega",1,2*N_modes), "dB\Omega"] ;
    

    %%% Plot: generalized matrix magntidue
    figure(1); clf
    for pii=1:2*N_modes+1
        for pjj=1:2*N_modes+1

            %%% Construct labels
            if pii<2*N_modes+1
                if pjj<2*N_modes+1
                    Sgen_symbol = "S_{"+string(pii)+string(pjj)+"}" ;
                else
                    Sgen_symbol = "k_{"+string(pii)+"}" ;
                end
            else
                if pjj<2*N_modes+1
                    Sgen_symbol = "h_{"+string(pjj)+"}" ;
                else
                    Sgen_symbol = "z_b" ;
                end
            end                

            % Create this element's plot
            plti = (2*N_modes+1)*(pii-1)+pjj ;
            subplot(2*N_modes+1,2*N_modes+1,plti)

            % Plot
            plot(f(:),S_db(:,pii,pjj), 'X', 'MarkerSize', 8, 'MarkerEdgeColor', '#A0A')
            %xlim([0,10])
            ylim([plt_y_mins(pii,pjj),plt_y_maxs(pii,pjj)])
            grid on
            %grid minor
            ax = gca ;
            ax.FontSize = plt_fontsize ;
            xlabel("f / "+f_label, 'FontSize', plt_fontsize)
            ylabel("|"+Sgen_symbol+"| / "+yunits(plti), 'FontSize', plt_fontsize)
            xline(f_co, 'b--', 'LineWidth', fco_lw)

        end
    end

    %%% Plot: SGen_Mat phase
    figure(2); clf
    for pii=1:2*N_modes+1
        for pjj=1:2*N_modes+1

            %%% Construct labels
            if pii<2*N_modes+1
                if pjj<2*N_modes+1
                    Sgen_symbol = "S_{"+string(pii)+string(pjj)+"}" ;
                else
                    Sgen_symbol = "k_{"+string(pii)+"}" ;
                end
            else
                if pjj<2*N_modes+1
                    Sgen_symbol = "h_{"+string(pjj)+"}" ;
                else
                    Sgen_symbol = "z_b" ;
                end
            end
            
            % Create this element's plot
            plti = (2*N_modes+1)*(pii-1)+pjj ;
            subplot(2*N_modes+1,2*N_modes+1,plti)
            
            % Plot
            plot(f(:), S_phase(:,pii,pjj), 'X', 'MarkerSize', 8, 'MarkerEdgeColor', '#A0A')
            %xlim([0,10])
            ylim([-200,200])
            grid on
            %grid minor
            ax = gca ;
            ax.FontSize = plt_fontsize ;
            xlabel("f / "+f_label, 'FontSize', plt_fontsize)
            ylabel("arg("+Sgen_symbol+") / \circ", 'FontSize', plt_fontsize)
            xline(f_co, 'b--', 'LineWidth', fco_lw)

        end
    end
            
else
    %%% Just Beam impedance (z_b)
    % Magnitude
    figure(3); clf
    plot(freqs_Smat(:),SGen_db(:,end,end), 'X', 'MarkerSize', 8, 'MarkerEdgeColor', '#A0A')
    grid on
    grid minor
    ax = gca ;
    ax.FontSize = 20 ;
    xlabel("f / "+f_label, 'FontSize', 20)
    ylabel("|z_b| / "+yunits(end), 'FontSize', 20)
    xticks(0:5:10)
    xline(5.74, 'r--')
    title("Beam Impedance (Magnitude)", 'FontSize', 15)

    % Phase
    figure(4); clf
    plot(freqs_Smat(:),phase_SGen(:,end,end), 'X', 'MarkerSize', 8, 'MarkerEdgeColor', '#A0A')
    grid on
    grid minor
    ax = gca ;
    ax.FontSize = 20 ;
    xlabel("f / "+f_label, 'FontSize', 20)
    ylabel("arg(|z_b|) / \circ", 'FontSize', 20)
    xticks(0:5:10)
    xline(5.74, 'r--')
    title("Beam Impedance (Phase)", 'FontSize', 15)

end