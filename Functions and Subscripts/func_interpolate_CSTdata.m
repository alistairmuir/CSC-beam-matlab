function interpolated_data = func_interpolate_CSTdata(data, original_samples, query_samples)
% Function to interpolate CST data onto the target set.
%
% :param data: The data to be interpolated.
% :param original_samples: The samples corresponding to the input data.
% :param query_samples: The samples onto which the data are to be interpolated.
%
% :returns: interpolated_data

% Create the interpolant using Matlab's griddedInterpolant function.
interpolant = griddedInterpolant(original_samples, data) ;

% Retrieve values for data at the query samples.
interpolated_data = interpolant(query_samples) ;

end