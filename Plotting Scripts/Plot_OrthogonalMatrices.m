%% Script to plot the CSC-Beam permutation matrix
%
% Permutation matrices are plotted from user-specified directory.
% The plots portray the matrix with rows on Y-axis, columns on X-axis, and all non-zero elements
% marked with a dot.
%
% :param filepath: path to the file containing the orthogonal matrices to be plotted.
% :type  filepath: string
% :param N_modes_int: Number of internal modes.
% :type  N_modes_int: integer
% :param N_modes_ext: Number of external modes.
% :type  N_modes_ext: integer
% :param N_segs: Number of segments to be concatenated in CSC-beam.
% :type  N_segs: integer
% :param markercolour: [R,G,B] colour to mark the non-zero elements in the plots.
% :type  markercolour: double
clc
clear


%% USER INPUT
filepath = ...
    "/home/alistair/git/CSC-beam-matlab/Matrices/Pillbox/Orthogonal_Matrices/"+...
    "NoBeam_2segments_3modes" ;

%%% Info regarding modes and segments (for plotting axes)
N_modes_int = 3 ;    % number of internal modes expected
N_modes_ext = 3 ;    % number of external modes expected
N_segs      = 2 ;    % number of segments expected

markercolour = [0.7, 0, 0.7] ;


%% Load the permutation matrix
load(filepath) ;


%% Initialize
Np = length(P) ;
prows = zeros(Np,1) ;
pcols = zeros(Np,1) ;

Nf = length(F) ;
frows = zeros(Nf,1) ;
fcols = zeros(Nf,1) ;


%% Find positions of non-zero elements.
for ii=1:Np
    prows(ii) = find(P(ii,:)) ;
    pcols(ii) = find(P(:,ii)) ;
end

for ii=1:Nf
    frows(ii) = find(F(ii,:)) ;
    fcols(ii) = find(F(:,ii)) ;
end


%% Plots
%%% Plot in the form of the matrix (i.e. the [1,1] element is top left), 
%%% indicating the non-zero element positions.
figure(1); clf;
plt1 = axes ;
plot(1:Np,pcols,'.', 'MarkerSize', 7, 'MarkerEdgeColor', markercolour)
set(plt1, 'Ydir', 'reverse')
xticks(0:N_modes_int+N_modes_ext+1:Np)
yticks(0:N_modes_int+N_modes_ext+1:Np)
xticklabels(1:N_segs)
yticklabels(1:N_segs)
xlim([0,Np])
ylim([0,Np])
grid on
grid minor
title("Permutation Matrix, P")

figure(2); clf;
plt2 = axes ;
plot(1:Nf,fcols,'.', 'MarkerSize', 7, 'MarkerEdgeColor', markercolour)
set(plt2, 'Ydir', 'reverse')
xticks(0:N_modes_int+N_modes_ext:Nf)
yticks(0:N_modes_int+N_modes_ext:Nf)
xticklabels(1:N_segs)
yticklabels(1:N_segs)
xlim([0,Nf])
ylim([0,Nf])
grid on
grid minor
title("Feedback Matrix, F")

