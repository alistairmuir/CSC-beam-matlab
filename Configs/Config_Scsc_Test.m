%% Configuration file for carrying out CSC-Beam on test segments
%  =============================================================
%
% Test configuration file.
%
% :param f_CST2SI: conversion factor of CST frequency units to SI (Hz).
% :type  f_CST2SI: double
% :param f_label: frequency label for plotting.
% :type  f_label: string
% :param s_CST2SI: conversion factor of CST time units to SI (seconds).
% :type  s_CST2SI: double
% :param m_CST2SI: conversion factor of CST length units to SI (metres).
% :type  m_CST2SI: double
% :param model_dir: directory containing all CST results for the given section of beam path.
% :type  model_dir: string
% :param wake_dir: directory containing the CST results from time-domain wake simulation.
% :type  wake_dir: string
% :param hifreq_dir: directory containing the CST results from freq-domain simulation.
% :type  hifreq_dir: string
% :param save_matrix: true = final matrix is saved in specified directory ; false = not saved.
% :type  save_matrix: boolean
% :param savedir: directory where final generalized matrix is saved.
% :type  savedir: string
% :param genmat_filename: name of the file containing the final generalized matrix.
% :type  genmat_filename: string
% :param Pmodes: array containing all the modes to include in the final matrix 
%                as numbered in CST (1D array).
% :type  Pmodes: integer
% :param Length: z-axis length of the segment in CST units.
% :type  Length: double
% :param import_FFT: true = FFTs of port signals and current as calculated in CST are imported ; 
%                    false = CST timeseries results are imported and FFTs are calculated in Matlab.
% :type  import_FFT: boolean
% :param freqs_FM: array of frequencies at which field monitors recorded the hi-freq simulation 
%                  E-field in CST units (1D array).
% :type  freqs_FM: double
% :param freqs_GM: array of frequencies at which to construct the generalized matrices. It is
%                  sensible to keep these the same as the FM frequencies, making interpolation 
%                  needed only for arrays with many more samples (1D array).
% :type  freqs_GM: double


%% Problem folder
name_problem = "Test" ;


%% Number of modes
N_modes = 2 ;


%% Orthogonal matrices
% Directory containing the orthogonal matrices
orthogonal_matrices_dir = "Matrices/"+name_problem+"/Orthogonal_Matrices/" ;

%%% Generalized matrices
% Directory containing generalized matrices
seg_dir = "./Matrices/"+name_problem+"/Generalized_Matrices/" ;


%%% File names of GMs for all segments in beam path (upstream to downstream).
%                upstream, ... , ... , downstream
segment_names = ["test"+N_modes, ...
                 "test"+N_modes] ;


%% Save filename
save_dir = "Results/"+name_problem ;
save_filename = segment_names(1) ;

plot_on = false ;
f_pltlabel = "GHz" ;   % Frequency units for plotting.

%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%