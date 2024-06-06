function [] = func_SaveGM(save_dir, save_filename, S, f, Length)
% Function to save generalized matrix, S, corresponding frequencies, f, and segment Length,
% in a .mat file within the given directory.
%
% :param directory: String containing directory to store the save file.
% :type directory: string
% :param filename: Filename of the save file.
% :type filename: string
% :param S: Generalized matrix (GM) to be saved (M-by-N-by-N).
% :type S: double
% :param f: Frequencies corresponding to each leaf of the GM (M-by-1).
% :type f: double
% :param Length: Physical length of the beamline segment represented by the GM.
% :type Length: double
%
% :returns: A .mat file containing S, f and Length.

% Create save directory if it currently does not exist.
if exist(save_dir,'dir')==0
    mkdir(save_dir)
end

% Create full path for save file.
save_path = save_dir + "/" + save_filename ;

% Save the file in the now-definitely-extant directory.
save(save_path, 'S', 'f', 'Length')

end
