%% Script to plot the CSC-Beam permutation matrix
% Permutation matrices are plotted from user-specified directory.
% (All non-zero elements are marked with a dot.)
% :param filepath: path to the file containing the orthogonal matrices to be plotted.
% :param N_modes_int: Number of internal modes.
% :param N_modes_ext: Number of external modes.
% :param N_segs: Number of segments to be concatenated in CSC-beam.
% :param markercolour: RGB colour to mark the non-zero elements in the plots.



%% USER INPUT
filepath = ...
    "/home/alistair/Matlab/S_CSC Script/Matrices/TESLA/Orthogonal_Matrices/"+...
    "orthogonal_matrices" ;

%%% Info regarding modes and segments (for plotting axes)
N_modes_int = 18 ;    % number of internal modes expected
N_modes_ext = 18 ;    % number of external modes expected
N_segs      = 11 ;    % number of segments expected

markercolour = [0.7,0,0.7] ;


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
%xticklabels(0:N_segs)
%yticklabels(0:N_segs)
xlim([0,Np])
ylim([0,Np])
grid on
title("Permutation Matrix, P")

figure(2); clf;
plt2 = axes ;
plot(1:Nf,fcols,'.', 'MarkerSize', 7, 'MarkerEdgeColor', markercolour)
set(plt2, 'Ydir', 'reverse')
xticks(0:N_modes_int+N_modes_ext:Nf)
yticks(0:N_modes_int+N_modes_ext:Nf)
%xticklabels(0:N_segs)
%yticklabels(0:N_segs)
xlim([0,Nf])
ylim([0,Nf])
grid on
title("Feedback Matrix, F")

