function interpolated_data = func_Interpolate_CSTdata(data, original_samples, query_samples)
% Function to interpolate CST data onto the target set.
%
% :param data: The data to be interpolated (1-by-N).
% :type  data: double
% :param original_samples: The samples corresponding to the input data (1-by-N).
% :type  original_samples: double
% :param query_samples: The samples onto which the data are to be interpolated (1D array).
% :type  query_samples: double
%
% :returns: interpolated_data (1D array of same length as query_samples)

%%%%% Using GriddedInterpolant
%%% % Create the interpolant using Matlab's griddedInterpolant function.
%%%interpolant = griddedInterpolant(original_samples, data) ;
%%%
%%% % Retrieve values for data at the query samples.
%%%interpolated_data = interpolant(query_samples) ;

%%% Using interp1
% Interpolate the data (separate interpolation done for real and imag parts).
interpolated_data = interp1(original_samples, real(data), query_samples, 'linear') + ...
    1j.*interp1(original_samples, imag(data), query_samples, 'linear') ;

end