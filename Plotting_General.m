%% Script for Plotting Impedances
% This script can plot impedance results from CSC-beam, FELIS or CST all together.
clear
clc


%% USER INPUT

%%%% Plot type
plot_type   = "real" ;    % real/imag plots, mag/phase plots, real plot only, otherwise both re/im and mag/phase
log_yaxis   = true ;      % Set to true to plot magnitude in dB.
xlims       = 'tight' ;   % limits to x-axis.
ylims       = 'tight' ;   % y-axis limits == 'tight' or [min,max] ; 
plot_error  = true ;      % Plot the error between 1st and 2nd file.

% Plotting style
linestyle = repmat(['x','o','*','d','+'],1,5) ;
msize  = 14 ;
lwidth = 2 ;

%%%% Data to plot
rfolders = ["C:\Users\alistair\git\Impedance Results\FELIS Files\CPMU17\cpmu17_full_4GHz\G-Matrix\B1", ...
            "C:\Users\alistair\git\CSC-beam-matlab\Matrices\CPMU17\Generalized_Matrices"] ;

files = ["B1.txt", "CSCbeam_cpmu17_9segs_4GHz_40modes"]  ;

legend_list = ["FELIS - CPMU17", "CSC-beam (9 segs)"] ;

your_xlabel = 'f / GHz' ;
convert_to_GHz = 1e-9 ;


%% Import data
plot_num = length(files) ;
data = struct ;

for ii=1:plot_num
    % Turn string into chars for finding extension.
    charfilename = char(files(ii)) ;

    % If .txt file, assume CST format, 
    % otherwise assume Scsc_Script.m output file format.
    switch charfilename(end-2:end)
        case 'txt'
            temp = readmatrix(rfolders(ii)+"\"+files(ii)) ;

            % If only 2 columns present, assume real values, otherwise take
            % columns 2 and 3 as real and imag respectively.
            switch length(temp(1,:))
                case 2
                    data(ii).freqs = temp(:,1) ;
                    data(ii).z     = temp(:,2) ;

                otherwise
                    data(ii).freqs = temp(:,1) ;
                    data(ii).z     = temp(:,2) + 1i*(temp(:,3)) ;
            end

        otherwise
            temp = load(rfolders(ii)+"/"+files(ii)) ;
            data(ii).freqs = temp.f.*convert_to_GHz ;  % Convert to GHz
            data(ii).z     = temp.S(:,end,end) ;
    end
end


%% Calculate error
% Calc the difference between first and second data vectors.
if plot_error
    error = data(2).z - data(1).z ;
    legend_list = [legend_list, "Error"] ;
end


%% Plotting
%%%% Plotting options
if plot_num>3
    colors = cool(plot_num)*0.8 ;
    colors = [0,0,0 ; colors] ;
else
    colors = [0,0,0.7 ; 1,0,1 ; 0.8,0,0] ;
end

%%%% REAL and IMAG parts of impedance
switch plot_type
    case {"mag", "phase"}
        %%%% MAG and PHASE of beam impedance

        figure(1)
        clf
        subplot(2,1,1);
        set(gca,'FontSize',15);
        hold on
        for ii=1:plot_num
            if log_yaxis
                tempdata = convert2db(data(ii).z) ;
            else
                tempdata = abs(data(ii).z) ;
            end
            plot(data(ii).freqs, tempdata, linestyle(ii), 'MarkerSize', msize, 'LineWidth',lwidth, 'Color',colors(ii,:))
        end
        xlabel(your_xlabel)
        if log_yaxis
            ylabel('|Z_b| / dB\Omega')
        else
            ylabel('|Z_b| / \Omega')
        end
        grid

        if plot_error
            if log_yaxis
                tempdata = convert2db(error) ;
            else
                tempdata = abs(error) ;
            end
            
            plot(data(1).freqs, tempdata, linestyle(end), 'MarkerSize', msize/1.5, 'LineWidth',lwidth, 'Color',[0,0,0])
        end

        legend(legend_list,'Location','best')
        xlim([0,min([data(1).freqs(end), data(2).freqs(end)])])
        ylim(ylims)


        subplot(2,1,2);
        set(gca,'FontSize',15);
        hold on
        for ii=1:plot_num
             plot(data(ii).freqs,180/pi*(angle(data(ii).z)), linestyle(ii), 'MarkerSize', msize, 'LineWidth',lwidth, 'Color',colors(ii,:))
        end
        xlabel(your_xlabel)
        ylabel('Phase / deg')
        grid
        legend(legend_list,'Location','best')
        xlim(xlims)
        ylim([-200,200])
        hold off

    case {"real", "imag"}
        %%%% REAL and IMAG components of beam impedance
        figure(1)
        clf
        subplot(2,1,1);
        set(gca,'FontSize',15);
        hold on
        for ii=1:plot_num
            if log_yaxis
                tempdata = convert2db(real(data(ii).z)) ;
                your_ylabel = '\Re(Z) / dB\Omega' ;
            else
                tempdata = real(data(ii).z) ;
                your_ylabel = '\Re(Z) / \Omega' ;
            end
            plot(data(ii).freqs, tempdata, linestyle(ii), 'MarkerSize', msize, 'LineWidth',lwidth, 'Color',colors(ii,:))
        end

        if plot_error
            if log_yaxis
                tempdata = convert2db(real(error)) ;
            else
                tempdata = real(error) ;
            end

            plot(data(1).freqs, tempdata, linestyle(end), 'MarkerSize', msize/1.5, 'LineWidth',lwidth, 'Color',[0,0,0])
        end

        xlabel(your_xlabel)
        ylabel(your_ylabel)
        grid
        legend(legend_list,'Location','best')
        xlim(xlims)
        ylim(ylims)
        hold off
        
        subplot(2,1,2);
        set(gca,'FontSize',15);
        hold on
        for ii=1:plot_num
            if log_yaxis
                tempdata = convert2db(imag(data(ii).z)) ;
                your_ylabel = '\Im(Z) / dB\Omega' ;
            else
                tempdata = imag(data(ii).z) ;
                your_ylabel = '\Im(Z) / \Omega' ;
            end
            plot(data(ii).freqs,tempdata, linestyle(ii), 'MarkerSize', msize, 'LineWidth',lwidth, 'Color',colors(ii,:))
        end

        if plot_error
             if log_yaxis
                tempdata = convert2db(imag(error)) ;
            else
                tempdata = imag(error) ;
            end
            
            plot(data(1).freqs, tempdata, linestyle(end), 'MarkerSize', msize/1.5, 'LineWidth',lwidth, 'Color',[0,0,0])
        end

        xlabel(your_xlabel)
        ylabel(your_ylabel)
        grid
        legend(legend_list,'Location','best')
        xlim(xlims)
        ylim(ylims)
        hold off

    case "real only"
        %%%% REAL
        figure(1)
        clf
        set(gca,'FontSize',15);
        hold on
        for ii=1:plot_num
            if log_yaxis
                tempdata = convert2db(real(data(ii).z)) ;
                your_ylabel = '\Re(Z) / dB\Omega' ;
            else
                tempdata = real(data(ii).z) ;
                your_ylabel = '\Re(Z) / \Omega' ;
            end
            plot(data(ii).freqs,tempdata, linestyle(ii), 'MarkerSize', msize, 'LineWidth',lwidth, 'Color',colors(ii,:))
        end
        xlabel(your_xlabel)

        if plot_error
            if log_yaxis
                tempdata = convert2db(real(error)) ;
            else
                tempdata = real(error) ;
            end

            plot(data(1).freqs, tempdata, linestyle(end), 'MarkerSize', msize/1.5, 'LineWidth',lwidth, 'Color',[0,0,0])
        end
        
        if log_yaxis
            ylabel('|Z_b| / dB\Omega')
        else
            ylabel('|Z_b| / \Omega')
        end
        grid
        legend(legend_list,'Location','best')
        xlim(xlims)
        ylim(ylims)
        hold off
        

    otherwise
        %%%% otherwise plot both REAL/IMAG and MAG/PHASE figures

        %%%% MAG/PHASE
        figure(1)
        clf
        subplot(2,1,1);
        set(gca,'FontSize',15);
        hold on
        for ii=1:plot_num
            if log_yaxis
                tempdata = convert2db(data(ii).z) ;
            else
                tempdata = data(ii).z ;
            end
            plot(data(ii).freqs,tempdata, linestyle(ii), 'MarkerSize', msize, 'LineWidth',lwidth, 'Color',colors(ii,:))
        end

        if plot_error
            if log_yaxis
                tempdata = convert2db(error) ;
            else
                tempdata = abs(error) ;
            end
            
            plot(data(1).freqs, tempdata, linestyle(end), 'MarkerSize', msize/1.5, 'LineWidth',lwidth, 'Color',[0,0,0])
        end
        
        xlabel(your_xlabel)
        if log_yaxis
            ylabel('|Z_b| / dB\Omega')
        else
            ylabel('|Z_b| / \Omega')
        end
        grid
        legend(legend_list,'Location','best')
        xlim(xlims)
        ylim(ylims)
        hold off
        
        subplot(2,1,2);
        set(gca,'FontSize',15);
        hold on
        for ii=1:plot_num
             plot(data(ii).freqs,180/pi*(angle(data(ii).z)), linestyle(ii), 'MarkerSize', msize, 'LineWidth',lwidth, 'Color',colors(ii,:))
        end
        xlabel(your_xlabel)
        ylabel('Phase / deg')
        grid
        legend(legend_list,'Location','best')
        xlim([0,min([data(1).freqs(end), data(2).freqs(end)])])
        ylim(ylims)
        hold off

        %%%% REAL/IMAG
        figure(2)
        clf
        subplot(2,1,1);
        set(gca,'FontSize',15);
        hold on
        for ii=1:plot_num
            if log_yaxis
                tempdata = convert2db(real(data(ii).z)) ;
                your_ylabel = '\Re(Z) / dB\Omega' ;
            else
                tempdata = real(data(ii).z) ;
                your_ylabel = '\Re(Z) / \Omega' ;
            end
            plot(data(ii).freqs,tempdata, linestyle(ii), 'MarkerSize', msize, 'LineWidth',lwidth, 'Color',colors(ii,:))
        end

        if plot_error
            if log_yaxis
                tempdata = convert2db(real(error)) ;
            else
                tempdata = real(error) ;
            end

            plot(data(1).freqs, tempdata, linestyle(end), 'MarkerSize', msize/1.5, 'LineWidth',lwidth, 'Color',[0,0,0])
        end

        xlabel(your_xlabel)
        ylabel(your_ylabel)
        grid
        legend(legend_list,'Location','best')
        xlim(xlims)
        ylim(ylims)
        hold off
        
        subplot(2,1,2);
        set(gca,'FontSize',15);
        hold on
        for ii=1:plot_num
            if log_yaxis
                tempdata = convert2db(imag(data(ii).z)) ;
                your_ylabel = '\Im(Z) / dB\Omega' ;
            else
                tempdata = imag(data(ii).z) ;
                your_ylabel = '\Im(Z) / \Omega' ;
            end
            plot(data(ii).freqs,tempdata, linestyle(ii), 'MarkerSize', msize, 'LineWidth',lwidth, 'Color',colors(ii,:))
        end

        if plot_error
             if log_yaxis
                tempdata = convert2db(imag(error)) ;
            else
                tempdata = imag(error) ;
            end
            
            plot(data(1).freqs, tempdata, linestyle(end), 'MarkerSize', msize/1.5, 'LineWidth',lwidth, 'Color',[0,0,0])
        end

        xlabel(your_xlabel)
        ylabel(your_ylabel)
        grid
        legend(legend_list,'Location','best')
        xlim(xlims)
        ylim(ylims)
        hold off
end
