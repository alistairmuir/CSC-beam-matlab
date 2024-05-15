%% Construct and save permutation matrices P and F for Scsc_Script.
% From user input relating to the problem, this script calculates the permutation
% matrices needed to carry out CSC-beam and stores them in a single .mat file in the 
% user-given directory.
% :param N_modes: Number of modes included in all generalized matrices.
% :type N_modes: integer
% :param N_segs: Number of segments to be concatenated.
% :type N_segs: integer
% :param save_dir: Directory in which the permutation matrices will be saved.
% :type save_dir: string



%% USER INPUT
N_modes = 1 ;    % Number of modes in matrix.
N_segs  = 2 ;    % Number of segments

save_dir = "Matrices/Pillbox/Orthogonal_Matrices/"+...
    N_segs+"segments_"+N_ext+"modes" ;


%% Initialization
N_int = N_modes ;    % Number of internal modes (N_int)
N_ext = N_modes ;    % Number of external modes (N_ext)
N_matsection = N_int+N_ext+1 ;
Psize =  N_segs*N_matsection ;
Fsize = (N_segs-1)*2*N_int ;

P = zeros(Psize) ;
F = zeros(Fsize) ;


%% Row/column expressions for the different sections of matrices
%%% P - beam impedance
Prows_beam = Psize-N_segs+1:Psize ;
Pcols_beam = N_matsection:N_matsection:Psize ;


%%% P - internal modes
Prows_int  = 1:(N_segs-1)*2*N_int ;
Pcols_int  = (1:N_int) + N_ext ;

for seg = 1:N_segs-2
    Pcols_int  = [Pcols_int, seg*N_matsection+(1:2*N_int)] ;
end

Pcols_int = [Pcols_int, Pcols_int(end)+2:Pcols_int(end)+N_int+1] ;


%%% P - extermal modes
Prows_ext = (N_segs-1)*(2*N_int)+(1:2*N_ext) ;
Pcols_ext = [1:N_ext, Psize-N_ext:Psize-1] ;

%%% Put em all together
Prows = [Prows_beam, Prows_int, Prows_ext] ;
Pcols = [Pcols_beam, Pcols_int, Pcols_ext] ;

%%% F
Frows = 1:Fsize;
Fcols = zeros(1,Fsize) ;

for segi=1:N_segs-1
    cols_i = (segi-1)*2*N_int + (1:2*N_int) ;
    Fcols(cols_i) = (segi-1)*2*N_int + [N_int + (1:N_int), 1:N_int] ;
end



%% Loop over all coords to fix the permutations.
%%% P
for ii=1:Psize
    P(Prows(ii), Pcols(ii)) = 1 ;
end

%%% F
for ii=1:Fsize
    F(Frows(ii), Fcols(ii)) = 1 ;
end


%% Save P and F matrices
save(save_dir,'P','F')


%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%
