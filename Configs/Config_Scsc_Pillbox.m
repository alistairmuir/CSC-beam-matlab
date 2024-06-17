%% Configuration file for running Scsc_Script.m on pillbox pipeline
%  ================================================================
%
% This script is called by Scsc_Script.m to retrieve a series of generalized matrices (GMs) and 
% perform CSC-beam to output the generalized matrix, S, for the entire beam path represented by
% the GMs. S is saved along with the frequencies corresponding to S and the total length, Length, of
% the entire structure.
%
% :param f_label: frequency label for plotting.
% :type  f_label: string
% :param problem_dir: directory containing all relevant matrices (the "problem" directory).
% :type  problem_dir: string
% :param save_dir: directory in which the final matrix is saved.
% :type  save_dir: string
% :param N_modes: Number of modes included in all generalized matrices (GMs).
% :type  N_modes: int
% :param orthogonal_matrices_dir: directory containing the required orthogonal matrix.
% :type  orthogonal_matrices_dir: string
% :param seg_dir: directory containing the GMs for this problem.
% :type  seg_dir: string
% :param segment_names: array of filenames for all the GMs in the problem.
% :type  segment_names: 1D array, string
% :param save_filename: directory into which the result matrix is stored.
% :type  save_filename: string
% :param plot_on: Choose whether to plot the beam impedance from the result matrix.
% :type  plot_on: boolean


%% Directories for loading and saving generalized matrices.
problem_dir = "Pillbox" ;


%% Directories for orthogonal and generalized matrices.
% Directory containing generalized matrices
seg_dir = "Matrices/"+problem_dir+"/Generalized_Matrices/" ;

% File names of for generalized matrices for all segments in beam path in sequential order...
% ... from z=0 to z=maximum (i.e. upstream to downstream).
N_segs = 2 ;    % Number of segments to be concatenated.
segment_names = ["pillbox_TM01_new"] ;
segment_names = repmat(segment_names(1),1,N_segs) ;

% Directory containing the orthogonal matrices.
orthogonal_matrices_dir = "./Matrices/Orthogonal_Matrices/" ;


%% Save directory and filename
save_dir = "Results/"+problem_dir ;
save_filename = "Z_" + N_segs + segment_names(1) ;


%% Plot?
plot_on  = true ;   % Plot the final generalized matrix?
f_label  = "GHz" ;   % Frequency units for plotting.
f_CST2SI = 1e9 ;
y_axis_limits = [0,0] ; % Limits on the y-axis (0,0 = T. Flisgen's limits)

%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

