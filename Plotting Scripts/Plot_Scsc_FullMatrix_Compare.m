%% Script to plot full S matrix from CSC-beam.
clear
clc

% Add paths to matrices and results for easy access to all S matrices.
addpath(genpath("Matrices"))

%% USER INPUT

%%% S-matrices directories
% seg1
S_dir1 = "Matrices/Stepped Rectangular Waveguide/Generalized_Matrices/steprect_veryfine_1order_40modes_seg1" ;
S_dir2 = "ErionCSC/seg1_erion" ;

% seg2
%S_dir1 = "Matrices/Stepped Rectangular Waveguide/Generalized_Matrices/steprect_veryfine_1order_40modes_seg2" ;
%S_dir2 = "ErionCSC/seg2_erion" ;

%%% Plot bits
plot_switch = "real" ;
clear_plots = false ;

marker_col = '#000' ;
marker_size = 8 ;
mkr = 'o' ;

y_axis_limits = [0,0] ;
f_label = "GHz" ;
legend_labels = ["Diffs"] ;



%% Load S matrix.
load(S_dir1)
S1 = S ;
f1 = f ;
Nf1 = length(f1) ;
choose_f1 = 1:Nf1 ;
clear S f Length

load(S_dir2)
S2 = S ;
f2 = f ;
Nf2 = length(f2) ;
choose_f2 = choose_f1 ;


%% Check freqs match
if any(f1(choose_f1) ~= f2(choose_f2))
    disp("FREQUENCIES DO NOT MATCH FOR BOTH S-MATRICES")
    return
end


%% Select like-freqs.
S1 = S1(choose_f1,:,:) ;
f  = f1(choose_f1) ;
S2 = S2(choose_f2,:,:) ;


%% Calculate differences
Sdiffs = S2-S1 ;


%% Calc number of rows and columns
Nrows  = length(Sdiffs(1,:,1)) ;
Ncols  = length(Sdiffs(1,1,:)) ;


%% Plotting
cmap = colormap(winter(Nrows)) ;

%%% goodfits
figure(10); clf
hold on
for ii=[1:40, Nrows]
   for jj=[1:40, Ncols]
        plot(f,real(Sdiffs(:,ii,jj)), 'o', 'Color', cmap(ii,:), 'MarkerSize',jj/10)
   end
end

%%% badfits
figure(11); clf
hold on
for ii = Nrows
   for jj = 41:Ncols-1
        plot(f,real(Sdiffs(:,ii,jj)), 'o', 'Color', cmap(ii,:), 'MarkerSize',jj/10)
   end
end

% figure(11); clf
% hold on
% for ii=1:Nrows
%     for jj=2
%         plot(f,imag(Sdiffs(:,ii,jj)), 'o', 'MarkerSize', 5)
%     end
% end
% ylim([-10,10])


% Convert freqs to correct plotting units (CST).
% if f_label=="GHz"
%     f_CST2SI = 1e9 ;
% end
% 
% f = f./f_CST2SI ;
% 
% switch plot_switch
%     case "real"
%         Plot_GeneralizedMatrix_ReIm
% 
%     case "mag"
%         Plot_GeneralizedMatrix
% end

%%%%%%%%%%%%   END   %%%%%%%%%%%%