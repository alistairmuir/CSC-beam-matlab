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

% Apply Hann window.
hann_window = hann(N_s*2) ;
data_TD = data_TD.*(hann_window(N_s+1:end)) ;
        % Latter half of Hann window = raised cosine with zero at final data point.

%%% Calculate sample frequencies
% Frequency interval.
fs = 1/((time_samples(end)-time_samples(1))/N_s) ;

% Frequencies for one-sided spectrum.
freqs = fs/N_pow2*(0:N_pow2/2) ;

%%% Carry out FFT.
data_rawFFT = fft(data_TD, N_pow2) ;

%%% Post-FFT treatments to form one-sided spectra.
% Take only positive frequencies for one-sided spectra.
data_FD = data_rawFFT(1:N_pow2/2+1,:)/N_pow2 ;

% Multiply by two to account for negative frequencies (not including DC or Nyquist).
data_FD(2:end-1,:) = 2*data_FD(2:end-1,:) ;

end