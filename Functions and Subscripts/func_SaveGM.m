function [] = func_SaveGM(save_dir, save_filename, S, f, Length)
% Function to save generalized matrix, S, corresponding frequencies, f, and segment Length,
% in a .mat file within the given directory.
%
% :param directory: String containing directory to store the save file.
% :type directory: string
% :param filename: Filename of the save file.
% :type filename: string
% :param S: Generalized matrix (GM) to be saved.
% :type S: M-by-N-by-N matrix double
% :param f: Frequencies corresponding to each leaf of the GM.
% :type f: M-by-1 array double.
% :param Length: Length of the segment represented by the GM.
% :type Length: double
%

% Create save directory if it currently does not exist.
if exist(save_dir,'dir')==0
    mkdir(save_dir)
end

% Create full path for save file.
save_path = save_dir + "/" + save_filename ;

% Save the file in the now-definitely-extant directory.
save(save_path, 'S', 'f', 'Length')

end
