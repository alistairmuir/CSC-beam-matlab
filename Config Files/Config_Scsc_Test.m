%%Configuration file for carrying out CSC-Beam on test segments.
% ==============================================================


%% Conversion factors.
f_CST2SI   =  1e9 ;    % Frequency: CST results in GHz.
f_pltlabel = "GHz" ;   % Frequency units for plotting.
s_CST2SI   = 1e-9 ;    % Seconds: CST results in ns.
m_CST2SI   = 1e-3 ;    % Metres: CST results in mm.


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
sequence_matrices = ["test"+N_modes, ...
                    "test"+N_modes] ;


%% Save filename
save_filename = "Results/S_csc/Wake_"+sequence_matrices(1) ;

plot_on = false ;


%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%

