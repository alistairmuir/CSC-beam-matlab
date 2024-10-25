function [P, F] = func_OrthoMatrices(N_ext, N_int, N_segs)
% Function that returns the permutation matrix, P, and feedback matrix, F, as defined in Ref [1],
% for given number of modes and segments.
%
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen et al - 2020
%
% :param N_ext: Number of external modes
% :type  N_ext: integer
% :param N_int: Number of internal modes
% :type  N_int: integer
% :param N_segs: Number of segments to be concatenated by Scsc_Script.
% :tpye  N_segs: integer
%
% :returns: P, F (permutation matrix and feedback matrix, both are orthogonal matrices)


%%% Initialization
% Number of elements in external segments.
N_extsegment = N_ext+N_int+1 ;

% Number of elements per internal segment.
N_intsegment = N_int*2+1 ;

% Size of P matrix.
Psize = 2*((N_segs-1)*N_int + N_ext + 1) ;

% Size of F matrix.
Fsize = (N_segs-1)*2*N_int ;

% Create matrices.
P = zeros(Psize) ;
F = zeros(Fsize) ;


%%% P: Create arrays containing indices for non-zero rows and columns
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


%%% F: Create arrays containing indices for non-zero rows and columns
%%% Initialize F rows and columns arrays.
Frows = 1:Fsize;
Fcols = zeros(1,Fsize) ;

for segi=1:N_segs-1
    cols_i = (segi-1)*2*N_int + (1:2*N_int) ;
    Fcols(cols_i) = (segi-1)*2*N_int + [N_int + (1:N_int), 1:N_int] ;
end


%%% Loop over all co-ordinates to populate the matrices
%%% P
for ii=1:Psize
    P(Prows(ii), Pcols(ii)) = 1 ;
end

%%% F
for ii=1:Fsize
    F(Frows(ii), Fcols(ii)) = 1 ;
end

end