%% Configuration file for carrying out CSC-Beam on test segments.
%  ==============================================================


%% Problem folder
name_problem = "Test" ;


%% Number of modes
N_modes = 2 ;


%% Orthogonal matrices
% Directory containing the orthogonal matrices
orthogonal_matrices_dir = "./Matrices/"+name_problem+"/Orthogonal_Matrices/"+...
    "2segments_"+string(N_modes)+"modes" ;

%%% Generalized matrices
% Directory containing generalized matrices
seg_dir = "./Matrices/"+name_problem+"/Generalized_Matrices/" ;


%%% File names of GMs for all segments in beam path (upstream to downstream).
%                upstream, ... , ... , downstream
segment_names = ["test"+N_modes, ...
                 "test"+N_modes] ;


%% Save filename
save_filename = "Results/S_csc/Wake_"+segment_names(1) ;

plot_on = false ;
f_pltlabel = "GHz" ;   % Frequency units for plotting.

%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%