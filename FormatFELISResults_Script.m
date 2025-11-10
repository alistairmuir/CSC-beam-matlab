%% Script to construct S-matrices ready for CSC-Beam from FELIS results.
clc
clear


%% Add dependent paths
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
    [S, f] = func_Import_FELISdata(felisresults_folder+"/"+segment_names(segi), ...
        P1_labels(segi), nTE1(segi), nTM1(segi), ...
        P2_labels(segi), nTE2(segi), nTM2(segi)) ;
    
    %%% Save matrices
    func_SaveGM(S_output_folder, save_filenames(segi), S, f, Length(segi)) ;
    disp("Stored GM for: " + save_filenames (segi))
end


%% Construct and save orthogonal matrices
if create_OrthoMatrices
    [P, F] = func_OrthoMatrices_FELIS(N_segs, nTE1, nTM1, nTE2, nTM2) ;
    mkdir(PF_output_folder)
    save(PF_output_folder+"/"+PF_savefilename, 'P', 'F')
end


%% Message upon completion
disp("Stored orthogonal matrices for concatenating "+N_segs+" segments.")

