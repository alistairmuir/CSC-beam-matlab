function [P, F] = func_OrthoMatrices_FELIS(N_segs, nTE1, nTM1, nTE2, nTM2)
% Function to create and output orthogonal matrices P and F, as described in [1], 
% for a CSC-beam problem with the input number of segments and modes.
%
% References:
% 1. "Generalization of coupled S-parameter calculation to compute beam
% impedances in particle accelerators" - T. Flisgen, E. Gjonaj, H.W. Glock - 2020
%
% :param N_segs: Number of segments to be concatenated by CSC-beam.
% :type  N_segs: integer
% :param nTE1: List of number of TE modes for port 1 of all segments.
% :type  nTE1: integer
% :param nTM1: List of number of TM modes for port 1 of all segments.
% :type  nTM1: integer
% :param nTE2: List of number of TE modes for port 2 of all segments.
% :type  nTE2: integer
% :param nTM2: List of number of TM modes for port 2 of all segments.
% :type  nTM2: integer
% :returns: P (N-by-N), F (M-by-M) where M = number of internal port modes and N = total number of all modes + N_segs


% Consistency check.
for ii=1:N_segs-1
    if ((nTE2(ii) ~= nTE1(ii+1)) || (nTM2(ii) ~= nTM1(ii+1)))
        error('inconsistent port modes!');
    end
end


%%% Permutation matrix, P %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calc total number of modes for each port
nMode1 = zeros(N_segs,1);
nMode2 = zeros(N_segs,1);
for ii=1:N_segs
    nMode1(ii)=nTE1(ii)+nTM1(ii);
    nMode2(ii)=nTE2(ii)+nTM2(ii);
end

% Initialize permutation matrix
dim = sum(nMode1(1:N_segs))+sum(nMode2(1:N_segs))+N_segs;
P = zeros(dim,dim);

% Create list of number of modes for each block in each cell:
% for every cell there are 3 blocks of colums (Port1,Port2,Beam). Total number of
% such blocks is 3*Ncell. Store dimensions of each block in @list.
list=[];
for ii=1:N_segs
    list = [list nMode1(ii), nMode2(ii), 1];
end


%%% INTERNAL PORTS
row_index1 = 0;

for ii = 1:N_segs
    if (ii==1) % First cell: port2 block index 
        blck_index=(ii-1)*3+2; 
        col_index1=sum(list(1:(blck_index-1)))+1;
        col_index2=sum(list(1:(blck_index))); 
        row_index2=row_index1+nMode2(ii);
        row_index1=row_index1+1;     
        P(row_index1:row_index2,col_index1:col_index2) = eye(nMode2(ii));
        row_index1 = row_index2;

    elseif (ii==N_segs) % Last cell: port1 block index 
        blck_index=(ii-1)*3+1;
        col_index1=sum(list(1:(blck_index-1)))+1;
        col_index2=sum(list(1:(blck_index)));
        row_index2=row_index1+nMode1(ii);
        row_index1=row_index1+1;     
        P(row_index1:row_index2,col_index1:col_index2) = eye(nMode1(ii));
        row_index1 = row_index2;

    else
        % Internal cell: port1 block index 
        blck_index=(ii-1)*3+1; 
        col_index1=sum(list(1:(blck_index-1)))+1;
        col_index2=sum(list(1:(blck_index)));    
        row_index2=row_index1+nMode1(ii);
        row_index1=row_index1+1;
        P(row_index1:row_index2,col_index1:col_index2) = eye(nMode1(ii));   
        row_index1 = row_index2;
        
        % Internal cell: port2 block index 
        blck_index=(ii-1)*3+2; 
        col_index1=sum(list(1:(blck_index-1)))+1;
        col_index2=sum(list(1:(blck_index)));
        row_index2=row_index1+nMode2(ii);
        row_index1=row_index1+1;
        P(row_index1:row_index2,col_index1:col_index2) = eye(nMode2(ii));
        row_index1 = row_index2;
    end
end

% Store end index of internal ports
end_index_internal = row_index1;

%%% EXTERNAL PORTS
% First cell, port 1
blck_index=1;
col_index1=sum(list(1:(blck_index-1)))+1;
col_index2=sum(list(1:(blck_index)));
row_index2=row_index1+nMode1(1);
row_index1=row_index1+1;
P(row_index1:row_index2,col_index1:col_index2) = eye(nMode1(1));
row_index1 = row_index2;

% Last cell, port 2
blck_index=(N_segs-1)*3+2; %port2 block index
col_index1=sum(list(1:(blck_index-1)))+1;
col_index2=sum(list(1:(blck_index)));   
row_index2=row_index1+nMode2(N_segs);
row_index1=row_index1+1;
P(row_index1:row_index2,col_index1:col_index2) = eye(nMode2(N_segs));
row_index1 = row_index2;

%%% BEAM MODES
for ii=1:N_segs
    blck_index=(ii-1)*3+3; %beam block index
    col_index1=sum(list(1:(blck_index-1)))+1;
    col_index2=sum(list(1:(blck_index)));
    row_index1=row_index1+1;
    P(row_index1,col_index1:col_index2) = 1;
end


%%% Feedback matrix, F %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F = [zeros(nMode2(1),nMode2(1)), eye(nMode2(1));
    eye(nMode2(1)), zeros(nMode2(1),nMode2(1))];

% For each port 1-port 2 couple, repeat same feedback matrix.
for ii=2:N_segs-1
    F = blkdiag(F,...
        [zeros(nMode2(ii),nMode2(ii)), eye(nMode2(ii));
        eye(nMode2(ii)), zeros(nMode2(ii),nMode2(ii))]);
end
end
