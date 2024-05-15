%{
-- Depricated -- 
Config file for carrying out CSC-Beam on TESLA-style pipeline.
==============================================================
%}

%% Conversion factors.
f_CST2SI =  1e9 ;   % Frequency: CST results in GHz.
s_CST2SI = 1e-9 ;   %   Seconds: CST results in ns.
m_CST2SI = 1e-3 ;   %    Metres: CST results in mm.


%% Matrices directories
% Problem folder
name_problem = "TESLA" ;

% Directory containing cells
seg_dir = "./Matrices/"+name_problem+"/Generalized_Matrices/" ;

% Orthogonal matrices
orthogonal_matrices_dir = "./Matrices/"+name_problem+"/Orthogonal_Matrices/orthogonal_matrices" ;

% File names of segments in beam path (upstream to downstream).
seg_names = ["coupler_us",...  % 1
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

% Length of segments in SI units.
us_len    = 170.000000 ;
ds_len    = 170.000000 ;
cell1_len = 114.570247 ;
cell2_len = 115.304800 ;
cell3_len = 113.432948 ;

L_segs = [   us_len,... 1,  upstream coupler
          cell1_len,... 2,  cell1
          cell2_len,... 3,  cell2
          cell2_len,... 4,  cell2
          cell2_len,... 5,  cell2
          cell2_len,... 6,  cell2
          cell2_len,... 7,  cell2
          cell2_len,... 8,  cell2
          cell2_len,... 9,  cell2
          cell3_len,... 10, cell3
             ds_len...  11, downstream coupler
          ]./1e3 ;  % convert to metres


%% Number of modes
N_modes = 18 ;



%%%%%%%%%%%%%%%%%%%%   END   %%%%%%%%%%%%%%%%%%%%


