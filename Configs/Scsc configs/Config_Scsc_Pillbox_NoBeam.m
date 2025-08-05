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
problem_dir = "Pillbox" ;


%% Directories for orthogonal and generalized matrices.
% Directory containing generalized matrices
seg_dir = "Matrices/"+problem_dir+"/Generalized_Matrices/" ;

segment_names = ["pillbox_3TM_NoBeam", "pillbox_3TM_NoBeam"] ;

orthogonal_matrices_dir = "Matrices/Pillbox/Orthogonal_Matrices" ;

save_dir = "Results/"+problem_dir ;
save_filename = "NoBeam_" + segment_names(1) ;


%% Plot?
plot_on  = true ;   % Plot the final generalized matrix?
f_label  = "GHz" ;   % Frequency units for plotting.
f_CST2SI = 1e9 ;
y_axis_limits = [0,0] ; % Limits on the y-axis (0,0 = T. Flisgen's limits)

%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

