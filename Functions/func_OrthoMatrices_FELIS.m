function [P, F] = func_OrthoMatrices_FELIS(N_segs, nTE1, nTM1, nTE2, nTM2)
%
%
%
% :returns: P (N-by-N), F (N_int-by-N_int)

%%% Permutation matrix, P %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Consistency check.
for i=1:N_segs-1
    if ((nTE2(i) ~= nTE1(i+1)) || (nTM2(i) ~= nTM1(i+1)))
        error('inconsistent port modes!');
    end
end

% Calc total number of modes for each port
nMode1 = zeros(N_segs,1);
nMode2 = zeros(N_segs,1);
for i=1:N_segs
    nMode1(i)=nTE1(i)+nTM1(i);
    nMode2(i)=nTE2(i)+nTM2(i);
end

% Initialize permutation matrix
dim = sum(nMode1(1:N_segs))+sum(nMode2(1:N_segs))+N_segs;
P = zeros(dim,dim);

% Create list of number of modes for each block in each cell:
% for every cell there are 3 blocks of colums (Port1,Port2,Beam). Total number of
% such blocks is 3*Ncell. Store dimensions of each block in @list.
list=[];
for i=1:N_segs
    list = [list nMode1(i), nMode2(i), 1];
end


%%% INTERNAL PORTS
row_index1 = 0;

for i = 1:N_segs
    if (i==1) % First cell: port2 block index 
        blck_index=(i-1)*3+2; 
        col_index1=sum(list(1:(blck_index-1)))+1;
        col_index2=sum(list(1:(blck_index))); 
        row_index2=row_index1+nMode2(i);
        row_index1=row_index1+1;     
        P(row_index1:row_index2,col_index1:col_index2) = eye(nMode2(i));
        row_index1 = row_index2;

    elseif (i==N_segs) % Last cell: port1 block index 
        blck_index=(i-1)*3+1;
        col_index1=sum(list(1:(blck_index-1)))+1;
        col_index2=sum(list(1:(blck_index)));
        row_index2=row_index1+nMode1(i);
        row_index1=row_index1+1;     
        P(row_index1:row_index2,col_index1:col_index2) = eye(nMode1(i));
        row_index1 = row_index2;

    else
        % Internal cell: port1 block index 
        blck_index=(i-1)*3+1; 
        col_index1=sum(list(1:(blck_index-1)))+1;
        col_index2=sum(list(1:(blck_index)));    
        row_index2=row_index1+nMode1(i);
        row_index1=row_index1+1;
        P(row_index1:row_index2,col_index1:col_index2) = eye(nMode1(i));   
        row_index1 = row_index2;
        
        % Internal cell: port2 block index 
        blck_index=(i-1)*3+2; 
        col_index1=sum(list(1:(blck_index-1)))+1;
        col_index2=sum(list(1:(blck_index)));
        row_index2=row_index1+nMode2(i);
        row_index1=row_index1+1;
        P(row_index1:row_index2,col_index1:col_index2) = eye(nMode2(i));
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
for i=1:N_segs
    blck_index=(i-1)*3+3; %beam block index
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
for i=2:N_segs-1
    F = blkdiag(F,...
        [zeros(nMode2(i),nMode2(i)), eye(nMode2(i));
        eye(nMode2(i)), zeros(nMode2(i),nMode2(i))]);
end
end
