%% Script to construct S-matrices ready for CSC-Beam from FELIS results.
clc
clear
addpath("Functions")
addpath("Configs")


%% Load config file
Config_FormatFELIS


%% Sanity check
if length(Length) ~= N_segs || length(segment_names) ~= N_segs
    error("'Length' or 'segment_names' arrays do not have correct number of elements.")
end


%% Construct and save S-matrix for each segment.
for segi=1:N_segs
    %%% Construct S-matrices
    [S, f] = func_Import_FELISdata(felisresults_folder+"/"+segment_names(segi), nTE1(segi), nTM1(segi), nTE2(segi), nTM2(segi)) ;
    
    %%% Save matrices
    func_SaveGM(S_output_folder, segment_names(segi), S, f, Length(segi)) ;
    disp("Stored GM for: "+segment_names(segi))
end


%% Construct and save orthogonal matrices
[P, F] = func_OrthoMatrices_FELIS(N_segs, nTE1, nTM1, nTE2, nTM2) ;
save(PF_output_folder, 'P', 'F')
disp("Stored orthogonal matrices for concatenating "+N_segs+" segments.")

