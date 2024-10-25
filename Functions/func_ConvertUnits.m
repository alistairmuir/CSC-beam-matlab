function data_converted = func_ConvertUnits(data_input, conversion_factor)
% Function to convert data into different units, with the input conversion factor.
%
% returns: Converted data in same format as input.

data_converted = data_input .* conversion_factor ;

end