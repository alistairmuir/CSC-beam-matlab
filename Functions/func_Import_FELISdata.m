function [S, f] = func_Import_FELISdata(felis_results_dir, P1_name, nTE1, nTM1, P2_name, nTE2, nTM2)
% A function to read data in the given FELIS results folder and output the 
% generalized S-matrix with corresponding frequencies in SI units.
%
% :param felis_results_dir: String of directory containing FELIS results for one simulation.
% :type felis_results_dir: string
% :param P1_name: Name of port 1 (label given by FELIS, dependent on VOL file boundary index)
% :type  P1_name: string
% :param nTE1: Number of TE modes at port 1
% :type  nTE1: integer
% :param nTM1: Number of TM modes at port 1
% :type  nTM1: integer
% :param P2_name: Name of port 2 (label given by FELIS, dependent on VOL file boundary index)
% :type  P2_name: string
% :param nTE2: Number of TE modes at port 2
% :type  nTE2: integer
% :param nTM2: Number of TM modes at port 2
% :type  nTM2: integer
%
% :returns: S (Nf-by-Nmodes-by-Nmodes) and f (Nf-by-1) where Nf is number of frequency samples.


% Total number of rows/columns in output S matrix
Ndims = 1+nTE1+nTM1+nTE2+nTM2 ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Beam impedance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp = importdata(strcat(felis_results_dir+'/G-Matrix/B1/B1.txt'),' ', 1) ;
data = temp.data ;

% Frequencies
f = func_ConvertUnits(data(:,1),1e9) ;   % Convert to Hz and store in f.

% Initialization of S-matrix
S = zeros(length(data(:,1)),Ndims,Ndims) ;

% Beam impedance (last element of S-matrix)
S(:,Ndims,Ndims) = data(:,2) + 1j*data(:,3) ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Beam-port mode coupling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TE beam-coupling coefficients for port 1
for ii = 1:nTE1
    temp = importdata(strcat(felis_results_dir,'/G-Matrix/B1/',P1_name,'_TE',num2str(ii),'.txt'),' ', 1);
    data = temp.data;
    S(:,ii+0,Ndims) = data(:,2) + 1j*data(:,3);
end

% TM beam-coupling coefficients for port 1
for ii = 1:nTM1
    temp = importdata(strcat(felis_results_dir,'/G-Matrix/B1/',P1_name,'_TM',num2str(ii),'.txt'),' ', 1);
    data = temp.data;
    S(:,ii+nTE1,Ndims) = data(:,2) + 1j*data(:,3);
end

% TE beam-coupling coefficients for port 2
for ii = 1:nTE2
    temp = importdata(strcat(felis_results_dir,'/G-Matrix/B1/',P2_name,'_TE',num2str(ii),'.txt'),' ', 1);
    data = temp.data;
    S(:,ii+nTE1+nTM1,Ndims) = data(:,2) + 1j*data(:,3);
end

% TM beam-coupling coefficients for port 2
for ii = 1:nTM2
    temp = importdata(strcat(felis_results_dir,'/G-Matrix/B1/',P2_name,'_TM',num2str(ii),'.txt'),' ', 1);
    data = temp.data;
    S(:,ii+nTE1+nTM1+nTE2,Ndims) = data(:,2) + 1j*data(:,3);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remaining matrix (waveguide modes = 1:nDim-1 columns)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create list of filenames for S-parameter matrix.
names={};
for ii = 1:nTE1
    names=[names strcat(P1_name,'/TE',num2str(ii))];
end
for ii = 1:nTM1
    names=[names strcat(P1_name,'/TM',num2str(ii))];
end
for ii = 1:nTE2
    names=[names strcat(P2_name,'/TE',num2str(ii))];
end
for ii = 1:nTM2
    names=[names strcat(P2_name,'/TM',num2str(ii))];
end


%%% Loop to import every element of matrix using names list.
for name_ii = 1:length(names)

    % Print updates
    disp("Currently importing " + names{name_ii})

    % Port 1, TE modes 
    for ii = 1:nTE1
        temp = importdata(strcat(felis_results_dir,'/G-Matrix/',names{name_ii},'/',P1_name,'_TE',num2str(ii),'.txt'),' ', 1);
        data = temp.data;
        S(:,ii+0,name_ii) = data(:,2) + 1j*data(:,3);
    end

    % Port 1, TM modes
    for ii = 1:nTM1
        temp = importdata(strcat(felis_results_dir,'/G-Matrix/',names{name_ii},'/',P1_name,'_TM',num2str(ii),'.txt'),' ', 1);
        data = temp.data;
        S(:,ii+nTE1,name_ii) = data(:,2) + 1j*data(:,3);
    end

    % Port 2, TE modes
    for ii = 1:nTE2
        temp = importdata(strcat(felis_results_dir,'/G-Matrix/',names{name_ii},'/',P2_name,'_TE',num2str(ii),'.txt'),' ', 1);
        data = temp.data;
        S(:,ii+nTE1+nTM1,name_ii) = data(:,2) + 1j*data(:,3);
    end

    % Port 2, TM modes
    for ii = 1:nTM2
        temp = importdata(strcat(felis_results_dir,'/G-Matrix/',names{name_ii},'/',P2_name,'_TM',num2str(ii),'.txt'),' ', 1);
        data = temp.data;
        S(:,ii+nTE1+nTM1+nTE2,name_ii) = data(:,2) + 1j*data(:,3);
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Port mode-beam coupling
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    temp = importdata(strcat(felis_results_dir,'/G-Matrix/',names{name_ii},'/B1.txt'),' ', 1);
    data = temp.data ;
    S(:,Ndims,name_ii) = data(:,2) + 1j*data(:,3);
    
end

disp("Finished importing results for: "+felis_results_dir)
end

