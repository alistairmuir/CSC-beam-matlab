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
problem_name = "CPMU17" ;
subproblem   = "cpmu17_9seg_4GHz" ;
datafolder   = "cpmu17_9seg_4GHz" ;


% FELIS output folder names for each segment.
segment_names = "seg"+string(1:9) ;

% Directory containing the segment results folders above.
felisresults_folder = "C:\Users\alistair\git\Impedance Results\FELIS Files\"+problem_name+"\"+datafolder ;


%%% SEGMENT ARRAYS
% Number of segments
N_segs = length(segment_names) ;

% List containing the lengths of all segments (in metres)
Length = zeros(1,N_segs) ;


%%% PORT MODES
% Labels for each port
P1_labels = "P"+string(1:9) ; % P1 label for each segment
P2_labels = "P"+string(2:10) ; % P2 label for each segment

% Number of port modes at each port.
Nm = 20 ;
nTE1 = repmat(Nm,1,N_segs) ; % Port 1, TE modes
nTM1 = repmat(Nm,1,N_segs) ; % Port 1, TM modes
nTE2 = repmat(Nm,1,N_segs) ; % Port 2, TE modes
nTM2 = repmat(Nm,1,N_segs) ; % Port 2, TM modes


%%%% Saving Matrices
% Folder into which all S-matrices will be stored.
S_output_folder = "Matrices/"+problem_name+"/Generalized_Matrices/"+subproblem ;
save_filenames = datafolder + "_" + segment_names ;

% Boolean: create file containing orthogonal matrices?
create_OrthoMatrices = true ;

% Folder into which the orthogonal matrices, P and F, will be saved.
PF_output_folder = "Matrices/"+problem_name+"/Orthogonal_Matrices" ;
PF_savefilename  = subproblem + "_" + num2str(Nm+Nm)+"modes" ;


