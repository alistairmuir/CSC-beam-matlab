function data_converted = func_ConvertUnits(data_input, conversion_factor)
% Function to convert data into different units, with the input conversion factor.
%
% :param data_input: N-dim array of arbitrary data
% :type  data_input: double
% :param conversion_factor: Single value or vector to multiply the data.
% :type  conversion_factor: double
%
% :returns: data_converted (data array in same format as data_input)

data_converted = data_input .* conversion_factor ;

end