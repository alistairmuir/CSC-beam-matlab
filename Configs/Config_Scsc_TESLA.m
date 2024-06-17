%% Depricated config file!
%  =======================

%% Conversion factors.
f_CST2SI =  1e9 ;   % Frequency: CST results in GHz.
f_pltlabel = "GHz" ;   % Frequency units for plotting.
s_CST2SI = 1e-9 ;   %   Seconds: CST results in ns.
m_CST2SI = 1e-3 ;   %    Metres: CST results in mm.


%% Number of modes
N_modes = 18 ;


%% Directories
% Problem folder
problem_dir = "TESLA" ;

% Save directory
save_dir = "Results/"+problem_dir ;

% Directory containing cells
seg_dir = "./Matrices/"+problem_dir+"/Generalized_Matrices/" ;

% Orthogonal matrices
orthogonal_matrices_dir = "./Matrices/"+problem_dir+"/Orthogonal_Matrices/orthogonal_matrices" ;

% File names of segments in beam path (upstream to downstream).
segment_names = ["coupler_us",...  % 1
                 "cell1",...       % 2
                 "cell2",...       % 3
                 "cell2",...       % 4
                 "cell2",...       % 5
                 "cell2",...       % 6
                 "cell2",...       % 7
                 "cell2",...       % 8
                 "cell2",...       % 9
                 "cell3",...       % 10
                 "coupler_ds"] ;   % 11
             
N_segs = length(segment_names) ;

% Length of segments in SI units.
% us_len    = 170.000000 ;
% ds_len    = 170.000000 ;
% cell1_len = 114.570247 ;
% cell2_len = 115.304800 ;
% cell3_len = 113.432948 ;
% 
% L_segs = [   us_len,... 1,  upstream coupler
%           cell1_len,... 2,  cell1
%           cell2_len,... 3,  cell2
%           cell2_len,... 4,  cell2
%           cell2_len,... 5,  cell2
%           cell2_len,... 6,  cell2
%           cell2_len,... 7,  cell2
%           cell2_len,... 8,  cell2
%           cell2_len,... 9,  cell2
%           cell3_len,... 10, cell3
%              ds_len...  11, downstream coupler
%           ]./1e3 ;  % convert to metres



%% Save filename
save_filename = save_dir + "/Z_" + N_segs + segment_names(1) ;


%% Plot?
plot_on      = false ; % Plot the final generalized matrix?
plt_fontsize = 10 ;    % Font size of axis and tick labels.




%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%


