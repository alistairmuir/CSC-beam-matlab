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
% :type  segment_names: 1D array, string
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
problem_dir = "Pillbox" ;


%% Directories for orthogonal and generalized matrices.
%%% Directory containing segment generalized matrices (GMs).
seg_dir = "Matrices/"+problem_dir+"/Generalized_Matrices/" ;

%%% Array of segment GM filenames.
% File names of for generalized matrices for all segments in beam path in sequential order...
% ... from z=0 to z=maximum (i.e. upstream to downstream).

segment_names = ["pillbox_TM01_hifi", "pillbox_TM01_hifi"] ;

%%% Number of modes for each port: [port1(seg1,seg2,...) ;
%%%                                [port2(seg1,seg2,...)];
nport1  = [1, 1] ;
nport2  = [1, 1] ;
N_modes = [ nport1 ;
            nport2 ] ;


%%% Filepath containing the orthogonal matrices.
orthogonal_matrices_dir = "Matrices/"+problem_dir+"/Orthogonal_Matrices/" ;
orthogonal_matrices_path = orthogonal_matrices_dir + "/" + ...
    length(segment_names) + "segments_" + N_modes(1,1) + "modes" ;


%% Save directory and filename
save_dir = "Matrices/"+length(segment_names)+problem_dir+"/Generalized_Matrices" ;
save_dir = "./" ;
save_filename = length(segment_names) + segment_names(1) ;


%% Plot?
plot_switch   = "mag" ;   % Plot mag/phase ("mag"), real/imag ("real"), or "none".
f_label       = "GHz" ;  % Frequency units for plotting.
f_CST2SI      = 1e9 ;    % Frequency conversion factor.
y_axis_limits = [0,0] ;  % Limits on the y-axis (0,0 = T. Flisgen's limits)

%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

