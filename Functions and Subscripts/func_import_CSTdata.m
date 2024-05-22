function [vec_ind, vec_dep] = func_importCSTdata(filepath, conversion_factor)
% A function that takes CST filepath as input, checks the number of columns (2 = real values,
% 3 = complex) and outputs the independent variable and dependent variable as separate vectors.
%
% :param filepath: Filepath containing CST tabulated data (real or complex).
% :type filepath: string
% :param conversion_factor: Converts independent CST variable to SI units.
% :type conversion_factor: double
%
% :returns: vec_ind, vec_dep

% Read CST data in.
data = readmatrix(filepath) ;


% Populate independent and dependent variable vectors.
switch length(data(1,:))
    case 2
        % Real data
        vec_ind = data(:,1).*conversion_factor ;
        vec_dep = data(:,2) ;
        
    case 3
        % Complex data
        vec_ind = data(:,1).*conversion_factor ;
        vec_dep = data(:,2) + 1i*data(:,3) ;
end
end