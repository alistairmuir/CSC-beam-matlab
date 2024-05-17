%% Configuration file for carrying out CSC-Beam on coupled Pillbox segments
% =========================================================================
%
% :param f_CST2SI: conversion factor of CST frequency units to SI (Hz).
% :type f_CST2SI: double
% :param f_label: frequency label for plotting.
% :type f_label: string
% :param s_CST2SI: conversion factor of CST time units to SI (seconds).
% :type s_CST2SI: double
% :param m_CST2SI: conversion factor of CST length units to SI (metres).
% :type m_CST2SI: double
% :param problem_dir: directory containing all relevant matrices (the "problem" directory).
% :type problem_dir: string
% :param save_dir: directory in which the final matrix is saved.
% :type save_dir: string
% :param N_segs: Number of segments to concatenate.
% :type N_segs: int
% :param N_modes: Number of modes included in all generalized matrices (GMs).
% :type N_modes: int
% :param orthogonal_matrices_dir: directory containing the required orthogonal matrix.
% :type orthogonal_matrices_dir: string
% :param seg_dir: directory containing the GMs for this problem.
% :type seg_dir: string
% :param name_matrices: array of filenames for all the GMs in the problem.
% :type name_matrices: 1D array, string
% :param sequence_matrices: array of GMs in correct beam-path sequence from upstream to downstream.
% :type sequence_matrices: 1D array, string
% :param save_filename: directory into which the result matrix is stored.
% :type save_filename: string
% :param plot_on: Choose whether to plot the beam impedance from the result matrix.
% :type plot_on: boolean



%% Conversion factors.
f_CST2SI   =  1e9 ;    % Frequency: CST results in GHz.
f_pltlabel = "GHz" ;   % Frequency units for plotting.
s_CST2SI = 1e-9 ;      % Seconds: CST results in ns.
m_CST2SI = 1e-3 ;      % Metres: CST results in mm.


%% Directories for loading and saving generalized matrices.
problem_dir = "Pillbox" ;
save_dir = "Results/"+problem_dir ;


%% Form of generalized matrices.
N_segs  = 2 ;    % Number of segments to be concatenated.
N_modes = 3 ;    % Number of modes in all generalized matrices.


%% Directories for orthogonal and generalized matrices.
% Directory containing the orthogonal matrices
orthogonal_matrices_dir = "./Matrices/"+problem_dir+"/Orthogonal_Matrices/"+...
    N_segs+"segments_"+string(N_modes)+"modes" ;


%%% Generalized matrices
% Directory containing generalized matrices
seg_dir = "./Matrices/"+problem_dir+"/Generalized_Matrices/" ;

% List of file names containing generalized matrices for all segments in the structure.
name_matrices = ["pillbox_3TM_hifi_new"] ;

% File names of for generalized matrices for all segments in beam path in sequential order...
% ... from z=0 to z=maximum (i.e. upstream to downstream).
sequence_matrices = repmat(name_matrices(1),1,N_segs) ;


%% Save filename
save_filename = save_dir + "/Z_" + N_segs + sequence_matrices(1) ;


%% Plot?
plot_on      = false ; % Plot the final generalized matrix?
plt_fontsize = 10 ;    % Font size of axis and tick labels.


%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

