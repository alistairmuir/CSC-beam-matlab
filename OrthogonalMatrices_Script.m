%% Constructs permutation matrices P and F for Scsc_Script.m
% ==========================================================
%
% From user input relating to the problem, this script calculates the permutation
% matrices needed to carry out CSC-beam (Ref. 1) and stores them in a single .mat file in the 
% user-given directory.
% 
% Created by Alistair Muir, January 2024.
% Last updated by Alistair Muir, June 2024.
%
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen, E. Gjonaj, H.W. Glock - 2020


%% Add dependent paths
addpath("Configs")

% Functionalising to be done in a later update.
% addpath("Functions")
% addpath("Subscripts")



%% Load config file
Config_OrthogonalMatrix



%% Initialization
% Number of elements in external segments.
N_extsegment = N_ext+N_int+1 ;

% Number of elements per internal segment.
N_intsegment = N_int*2+1 ;

% Size of P matrix.
Psize = 2*((N_segs-1)*N_int + N_ext + 1) ;

% Size of F matrix.
Fsize = (N_segs-1)*2*N_int ;

P = zeros(Psize) ;
F = zeros(Fsize) ;

% Create full filepath for these matrices.
save_path = save_dir+"/"+N_segs+"segments_"+N_ext+"modes" ;



%% P: Create arrays containing indices for non-zero rows and columns
%%% P beam: rows containing beam are the final N_segs rows.
Prows_beam = Psize-N_segs+1:Psize ;

%%% P beam: columns containing beam are final column for each segment.
Pcols_beam = N_extsegment:N_intsegment:Psize ;

%%% P int: rows containing internal modes.
Prows_int  = 1:(N_segs-1)*2*N_int ;

%%% P int: columns containing internal modes.
% First segment
Pcols_int  = (1:N_int) + N_ext ;

% Internal segments:
for segi = 2:N_segs-1
    Pcols_int  = [Pcols_int, N_extsegment+(segi-2)*N_intsegment+(1:2*N_int)] ;
    % It is (segi-2), because both the first segment and the current segment is subtracted in order
    % for index to be 1 for the current segment's first column.
end

% Final segment
Pcols_int = [Pcols_int, Pcols_int(end)+2:Pcols_int(end)+N_int+1] ;

%%% P ext: rows containing external modes.
Prows_ext = (N_segs-1)*(2*N_int)+(1:2*N_ext) ;

%%% P ext: columns containing external modes.
Pcols_ext = [1:N_ext, Psize-N_ext:Psize-1] ;

%%% Put em all together ([beam, internal, external] rows and columns).
Prows = [Prows_beam, Prows_int, Prows_ext] ;
Pcols = [Pcols_beam, Pcols_int, Pcols_ext] ;



%% F: Create arrays containing indices for non-zero rows and columns
%%% Initialize F rows and columns arrays.
Frows = 1:Fsize;
Fcols = zeros(1,Fsize) ;

for segi=1:N_segs-1
    cols_i = (segi-1)*2*N_int + (1:2*N_int) ;
    Fcols(cols_i) = (segi-1)*2*N_int + [N_int + (1:N_int), 1:N_int] ;
end



%% Loop over all co-ordinates to populate the matrices
%%% P
for ii=1:Psize
    P(Prows(ii), Pcols(ii)) = 1 ;
end

%%% F
for ii=1:Fsize
    F(Frows(ii), Fcols(ii)) = 1 ;
end



%% Save P and F matrices
if exist(save_dir, 'dir')==0
    mkdir(save_dir)
end

save(save_path,'P','F')


%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%



