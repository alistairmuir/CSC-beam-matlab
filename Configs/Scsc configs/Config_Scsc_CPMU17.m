%% Configuration file for running Scsc_Script.m on pillbox pipeline
%  ================================================================
%
% This script is called by Scsc_Script.m to retrieve a series of generalized matrices (GMs) and 
% perform CSC-beam to output the generalized matrix, S, for the entire beam path represented by
% the GMs. S is saved along with the frequencies corresponding to S and the total length, Length, of
% the entire structure.
%
% The listed parameters are the only parameters needed by the Scsc_Script.m, but other parameters
% can be defined to help define those parameters (e.g. creating strings comprised of other strings).
%
% :param seg_dir: directory containing the GMs for this problem.
% :type  seg_dir: string
% :param segment_names: array of filenames for all the GMs in the problem.
% :param segment_names: array of filenames for all the GMs in the problem.
% :param N_modes: 2D-array giving number of port modes for all segments in the form:
%                 [port1(seg1,seg2,...) ;
%                  port2(seg1,seg2,...) ]
% :type  N_modes: integer
% :param orthogonal_matrices_path: filepath for .mat file containing P and F.
% :type  orthogonal_matrices_path: string
% :param save_dir: directory in which the final matrix is saved.
% :type  save_dir: string
% :param save_filename: directory into which the result matrix is stored.
% :type  save_filename: string
% :param plot_on: Choose whether to plot the beam impedance from the result matrix.
% :type  plot_on: boolean
% :param f_label: String containing units label for plotting (typically "GHz").
% :type  f_label: string
% :param f_CST2SI: Conversion factor for frequencies in CST units into SI units (typical 10e9).
% :type  f_CST2SI: double
% :param y_axis_limits: Array containing minimum and maximum for y-axis on plots (2-by-1).
% :type  y_axis_limits: double


%% Directories for loading and saving generalized matrices.
% These strings are used only within config file for clarity and ease.

% Name of problem mesh being modelled.
problem_name = "CPMU17" ;

% Name prefix for the simulation run of interest.
nameprefix = "cpmu17_9segs_4GHz" ;


%% Directories for orthogonal and generalized matrices.
%%% Directory containing segment generalized matrices (GMs).
seg_dir = "Matrices/"+problem_name+"/Generalized_Matrices/"...
    + nameprefix ;

%%% Array of segment GM filenames.
% File names of for generalized matrices for all segments in beam path in sequential order...
% ... from z=0 to z=maximum (i.e. upstream to downstream).
segment_names = nameprefix + "_seg" + [1:9] ;

%%% Number of modes for each port: [port1(seg1,seg2,...) ;
%%%                                [port2(seg1,seg2,...)];
NTE = 20 ;
NTM = 20 ;
nport1  = repmat(NTE+NTM,1,length(segment_names)) ;
nport2  = repmat(NTE+NTM,1,length(segment_names)) ;
N_modes = [ nport1 ;
            nport2 ] ;

%%% Directory containing the orthogonal matrices.
orthogonal_matrices_path = "Matrices/"+problem_name+"/Orthogonal_Matrices/"+...
    nameprefix+"_"+string(NTE+NTM)+"modes" ;


%% Save directory and filename
save_dir = "Matrices/"+problem_name+"/Generalized_Matrices" ;
save_filename = "CSCbeam_"+nameprefix+"_"+string(NTE+NTM)+"modes" ;


%% Plot?
plot_switch   = "real" ;   % Plot mag/phase ("mag"), real/imag ("real"), or "none".
f_label       = "GHz" ;  % Frequency units for plotting.
f_CST2SI      = 1e9 ;    % Frequency conversion factor.
y_axis_limits = [0,0] ;  % Limits on the y-axis

%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

