function [freqs, data_FD] = func_FFT_CSTdata(data_TD, time_samples)
% Function to return 1D spectrum from timeseries vector input.
%
% :param data_TD: timeseries vector or matrix where each column is a timeseries.
% :type  data_TD: double
% :param time_samples: the time samples corresponding to the timeseries data in data_TD.
% :type  time_samples: double
%
% :returns: freqs (1-by-N), data_FD (1-by-N)


%%% Determine next power of 2 above number of samples for efficient FFT.
N_s = length(time_samples) ;
N_pow2 = 2^nextpow2(N_s) ;

%%% Apply Hann window.
hann_window = hann(2*N_s) ;
data_TD = data_TD.*(hann_window(N_s+1:end)) ;
        % Latter half of Hann window = raised cosine with zero at final data point.

%%% Calculate sample frequencies
% Sample period
sample_freq = N_pow2/(time_samples(end)-time_samples(1)) ;

% Frequencies for one-sided spectrum.
freqs = sample_freq/N_pow2*(0:N_pow2-1) ;

%%% Carry out FFT.
data_FD = fft(data_TD, N_pow2, 1) ;

end