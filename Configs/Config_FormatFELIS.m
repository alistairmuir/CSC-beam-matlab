%% Configuration file for "FormatFELISResults_Script"
% ===================================================
%
% This is a configuration file called by FormatFELISResults_Script.m, which 
% outputs generalized matrices (GM) and orthogonal matrices for a given set
% of FELIS results for an arbitrary number of segments and port modes. 
% The outputted .MAT files are ready to be used by Scsc_Script.m.
%
% :param segment_names: String array containing folder names for all segments in this problem.
% :type  segment_names: string
% :param felisresults_folder: Directory for the folder containing all FELIS results for this problem. 
% :type  felisresults_folder: string
% :param save_filenames: Array of output filenames for the GM for every segment.
% :type  save_filenames: string
% :param S_output_folder: Directory in which to save the output GM files
% :type  S_output_folder: string
% :param PF_output_folder: Directory in which to save the 
% :type  PF_output_folder: string
% :param N_segs: Number of segments in this problem.
% :type  N_segs: integer
% :param Length: Array containing the length of each segment.
% :type  Length: double
% :param P1_labels: List of port 1 labels, dependent on boundary indices - see FELIS config files.
% :type  P1_labels: string
% :param P2_labels: List of port 2 labels, dependent on boundary indices - see FELIS config files.
% :type  P2_labels: string
% :param nTE1: Number of TE modes at port 1
% :type  nTE1: integer
% :param nTM1: Number of TM modes at port 1
% :type  nTM1: integer
% :param nTE2: Number of TE modes at port 2
% :type  nTE2: integer
% :param nTM2: Number of TM modes at port 2
% :type  nTM2: integer


%%% FOLDERS
% Problem name for consistent directory name construction.
problem_name = "Stepped Rectangular Waveguide" ;

% FELIS output folder names for each segment.
segment_names = "steprectveryfine_1order_20TE_20TM_seg" + ["1" , "2"] ;

% Directory containing the segment results folders above.
felisresults_folder = "FELIS Files/"+problem_name+"/1st order veryfine" ;


%%% SEGMENT ARRAYS
% Number of segments
N_segs = length(segment_names) ;

% List containing the lengths of all segments (in metres)
Length = [0, 0] * 1e-3 ;


%%% PORT MODES
% Labels for each ports (see labels of FELIS files or config files for each segment)
P1_labels = ["P1", "P1"] ;
P2_labels = ["P2", "P2"] ;

% Number of port modes at each port.
Nm = 20 ;
nTE1 = [Nm,Nm] ; % Port 1 of all cells.
nTM1 = [Nm,Nm] ;
nTE2 = [Nm,Nm] ;  % Port 2 couples to port 1 of previous cell.
nTM2 = [Nm,Nm] ;



%%%% Saving Matrices
% Folder into which all S-matrices will be stored.
S_output_folder = "Matrices/"+problem_name+"/Generalized_Matrices" ;
save_filenames = "steprect_veryfine_1order_40modes_seg" + ["1", "2"] ;  % Filenames of the resultant S matrices.


% Folder into which the orthogonal matrices, P and F, will be saved.
PF_output_folder = "Matrices/"+problem_name+"/Orthogonal_Matrices" ;
PF_savefilename = "FELIS_steprect_40modes" ;  % Filename containing orthogonal matrices


%PF_output_folder = "Matrices/"+problem_name+"/Orthogonal_Matrices/FELIS_"+...
%    N_segs+"segs_"+num2str(N_tE+N_TM)+"modes" ;

