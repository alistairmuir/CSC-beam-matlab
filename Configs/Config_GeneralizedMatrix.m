%% Configuration file for GeneralizedMatrix_Script.m
%  =================================================
% 
% This script is called by GeneralizedMatrix_Script.m, which constructs a generalized matrix
% from CST simulation results in directories given by the user, along with other information.
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
% :param save_dir: directory where final generalized matrix is saved.
% :type  save_dir: string
% :param save_filename: name of the file containing the final generalized matrix.
% :type  save_filename: string
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
% :param plot_on: Switch to turn on/off plotting
% :type  plot_on: boolean
% :param plt_port: Select of which port to plot the cut-off frequencies of all modes (1 or 2).
% :type  plt_port: integer
% :param y_axis_limits: Minimum and maximum Y-axis values in dB.
% :ttype y_axis_limits: double



%% Conversion factors.
f_CST2SI = 1e+9 ;    % Frequency (1e+9: GHz --> Hz).
f_label  = "GHz" ;   % Frequency units for plotting.

s_CST2SI = 1e-9 ;    % Seconds (1e-9:  ns --> s).
m_CST2SI = 1e-3 ;    % Metres  (1e-3:  mm --> m).



%% Directories for loading and saving.
%%% Directories containing CST results.
model_dir  = "CST Files/Pillbox" ;
wake_dir   = model_dir+"/Wake_10GHz_15cpw_8modes_10sigma/Export" ;  % Wake CST directory
hifreq_dir = model_dir+"/Freq_10GHz_tetra_8modes/Export" ;  % High Freq CST directory


%%% Directory and filename to save generalized matrices.
save_matrix   = true ;
save_dir      = "Matrices/Pillbox/Generalized_Matrices" ;
save_filename = "pillbox_8modes" ;


%% Port modes
%%% Choose modes for signal retrieval.
Pmodes = [1:8] ;   % List of port modes to be included.


%% Segment longitudinal length (CST units)
Length = 100 ;    % usually mm


%% Import CST FFTs (otherwise let Matlab carry them out)
import_FFT = false ;   % true = CST FFTs imported, false = Matlab carries out FFTs.


%% Frequency arrays
%%% Frequencies measured by Field Monitors in HiFreq simulation.
freqs_FM = (0.125:0.125:10)' ;   % Must be given in CST units.

%%% Frequencies at which to evaluate Generalized S-matrix.
% Usually best to use freqs of Field Monitors - all other components will 
% have more dense frequency sets.
freqs_GM = freqs_FM ;


%% Plotting
plot_on       = true ; % Plot results?
plt_port      = 1 ;    % Choose port mode for which the cut-off frequency will be plotted.
y_axis_limits = [0,0] ; % Limits on the y-axis (0,0 = T. Flisgen's limits)

%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

