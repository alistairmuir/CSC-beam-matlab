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
% :param nTE1: Number of TE modes at port 1
% :type  nTE1: integer
% :param nTM1: Number of TM modes at port 1
% :type  nTM1: integer
% :param nTE2: Number of TE modes at port 2
% :type  nTE2: integer
% :param nTM2: Number of TM modes at port 2
% :type  nTM2: integer

%%% FOLDERS
% Folders containing FELIS output for each segment.
segment_names = "steprect_seg" + (1:2) ;
felisresults_folders = "FELIS Files/Stepped Rectangular Waveguide/2order_20TE_20TM" ;

% Filename for each segment S-matrix.
save_filenames = "2order_"+segment_names ;

% Folder into which all S-matrices will be stored.
S_output_folder = "Matrices/Stepped Rectangular Waveguide/Generalized_Matrices" ;

% Folder into which the orthogonal matrices, P and F, will be saved.
PF_output_folder = "Matrices/Stepped Rectangular Waveguide/Orthogonal_Matrices" ;


%%% SEGMENT ARRAYS
% Number of segments
N_segs = length(segment_names) ;

% List containing the lengths of all segments (in metres)
Length = [400, 400] * 1e-3 ;


%%% PORT MODES
% Number of TE and TM modes at each port
N_TE = 20 ;
N_TM = 20 ;

% Number of incoming port modes at each port.
nTE1(1:N_segs) = N_TE ; % Port 1 of all subsequent cells.
nTM1(1:N_segs) = N_TM ;
nTE2 = nTE1 ;  % Port 2 couples to port 1 of next cell.
nTM2 = nTM1 ;

%nTE1(1) = 0 ; % Cell 1 - port 1
%nTM1(1) = 0 ;
%nTE2(end) = 0 ; % Final cell - port 2
%nTM2(end) = 0 ; 

