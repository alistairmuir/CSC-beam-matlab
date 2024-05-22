%{
% Configuration file for Script to Generate a Generalized Matrix
% ==============================================================
% 
% This script is called by GeneralizedMatrix_Script.m, which constructs a generalized matrix
% containing the specified number of modes from CST files given in this document.
% 
% :param f_CST2SI: conversion factor of CST frequency units to SI (Hz).
% :type f_CST2SI: double
% :param f_label: frequency label for plotting.
% :type f_label: string
% :param s_CST2SI: conversion factor of CST time units to SI (seconds).
% :type s_CST2SI: double
% :param m_CST2SI: conversion factor of CST length units to SI (metres).
% :type m_CST2SI: double
% :param model_dir: directory containing all CST results for the given section of beam path.
% :type model_dir: string
% :param wake_dir: directory containing the CST results from time-domain wake simulation.
% :type wake_dir: string
% :param hifreq_dir: directory containing the CST results from freq-domain simulation.
% :type hifreq_dir: string
% :param save_matrix: true = final matrix is saved in specified directory ; false = not saved.
% :type save_matrix: boolean
% :param genmat_savedir: directory where final generalized matrix is saved.
% :type genmat_savedir: string
% :param genmat_filename: name of the file containing the final generalized matrix.
% :type genmat_filename: string
% :param Pmodes: array containing all the modes to include in the final matrix 
% as numbered in CST.
% :type Pmodes: 1D array, integer
% :param Length: z-axis length of the segment in CST units.
% :type Length: double
% :param import_FFT: true = FFTs of port signals and current as calculated in CST are
% imported ; false = CST timeseries results are imported and FFTs are calculated in Matlab.
% :type import_FFT: boolean
% :param freqs_FM: Array of frequencies at which field monitors recorded the hi-freq simulation 
% E-field in CST units.
% :type freqs_FM: 1D array, double
% :param freqs_GM: Array of frequencies at which to construct the generalized matrices. It is
% sensible to keep these the same as the FM frequencies, making interpolation needed only for
% arrays with many more samples.
% :type freqs_GM: 1D array, double
%
%}



%% Conversion factors.
f_CST2SI = 1e+9 ;    % Frequency (1e+9: GHz --> Hz).
f_label  = "GHz" ;   % Frequency units for plotting.

s_CST2SI = 1e-9 ;    % Seconds (1e-9:  ns --> s).
m_CST2SI = 1e-3 ;    % Metres  (1e-3:  mm --> m).



%% Directories for loading and saving.
%%% Directories containing CST results.
model_dir  = "CST Files/Pillbox" ;
wake_dir   = model_dir+"/Wake_hifi/Export" ;  % Wake CST directory
hifreq_dir = model_dir+"/Freq_hifi/Export" ;  % High Freq CST directory


%%% Directory and filename to save generalized matrices.
save_matrix     = true ;
genmat_savedir  = "Matrices/Pillbox/Generalized_Matrices" ;
genmat_filename = "pillbox_TM01_conjCurrent" ;


%% Port modes
%%% Choose modes for signal retrieval.
Pmodes = [3] ;   % List of the modes (signals of these modes will be retrieved, others ignored).


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
plot_results  = true ; % Plot results?
plt_fontsize  = 10 ;   % Font size of axis and tick labels.
plt_port      = 1 ;    % Choose port mode for which the cut-off frequency will be plotted.
y_axis_limits = [0,0] ; % Limits on the y-axis (0,0 = T. Flisgen's limits)


%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

