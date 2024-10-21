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
clc; clear

%% Number of things
% Number of external modes.
N_ext = 3 ;

% Number of internal modes.
N_int = 3 ;

% Number of segments to be concatenated.
N_segs  = 2 ;

%%% Directory for results
% Note: Filename is automatic, and includes number of modes and segments.
save_dir = "Matrices/Pillbox/Orthogonal_Matrices" ;


%% Initialization
% Number of elements in external segments (also the column containing beam impedance for seg 1).
N_extsegment = N_ext+N_int ;

% Number of elements per internal segment.
N_intsegment = 2*N_int ;

% Size of P matrix.
Psize = (N_segs-1)*N_intsegment + N_extsegment ;

% Size of F matrix.
Fsize = (N_segs-1)*2*N_int ;

P = zeros(Psize) ;
F = zeros(Fsize) ;

% Create full filepath for these matrices.
save_path = save_dir+"/NoBeam_"+N_segs+"segments_"+N_ext+"modes" ;



%% P: Create arrays containing indices for non-zero rows and columns
%%% Internal modes
% P int: rows containing internal modes.
Prows_int  = 1:(N_segs-1)*2*N_int ;

% P int: columns containing internal modes.
Pcols_int  = (1:Fsize) + N_ext ;

%%% External modes
% P ext: rows containing external modes.
Prows_ext = Fsize + (1:2*N_ext) ;

% P ext: columns containing external modes.
Pcols_ext = [1:N_ext, (N_ext+Fsize)+(1:N_ext)] ;

%%% Put em all together ([beam, internal, external] rows and columns).
Prows = [Prows_int, Prows_ext] ;
Pcols = [Pcols_int, Pcols_ext] ;



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



