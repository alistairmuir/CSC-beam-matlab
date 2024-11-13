function [freqs, data_FD] = func_FFT_CSTdata(data_TD, time_samples)
% Function to return 1D spectrum from timeseries vector input.
%
% :param data_TD: timeseries vector or matrix where each column is a timeseries.
% :type  data_TD: double
% :param time_samples: the time samples corresponding to the timeseries data in data_TD.
% :type  time_samples: double
%
% :returns: freqs (1-by-N), data_FD (1-by-N)


%%% Ensure timeseries has even number of samples (cuts off final odd sample).
% Determine whether number of time samples, N_ts, is odd or even.
N_s = length(time_samples) ;
Nmod2 = mod(N_s, 2) ;
N_pow2 = 2.^nextpow2(N_s) ;

% Reduce N_ts by 1 if N_ts is odd (N_ts is unchanged if even).
N_s = N_s - Nmod2 ;

% Cut off final odd sample from all timeseries if present.
time_samples = time_samples(1:N_s) ;
data_TD      = data_TD(1:N_s,:) ;


%%% Calculate sample frequencies
% Frequency interval.
fs = 1/((time_samples(end)-time_samples(1))/N_s) ;

% Frequencies for one-sided spectrum.
freqs = fs/N_s*(0:N_s/2-1) ;


%%% Carry out FFT
data_rawFFT = fft(data_TD, N_pow2) ;

%%% Post FFT treatments to form one-sided spectra.
% Take only positive frequencies for one-sided spectra.
data_FD = data_rawFFT(1:N_s/2,:)/N_s ;

% Multiply by two to account for negative frequencies (not including DC or Nyquist).
data_FD(2:end-1) = 2*data_FD(2:end-1) ;

end