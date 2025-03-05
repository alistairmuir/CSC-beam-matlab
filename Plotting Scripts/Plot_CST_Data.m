%% Script to plot imported, untreated CST data
clc
clear

addpath("Functions")

%% USER INPUT
fname = ["o1(3),pb.txt", "o2(3),pb.txt"] ;
file_string = "CST Files/Pillbox/Wake_15GHz_30cpw_3modes_10sigma_1M/Export/Port signals/"+fname ;

%% Import

Nfiles = length(file_string) ;

[x,y] = func_Import_CSTdata(file_string(1), 1) ;
data_y = zeros([size(y), Nfiles]) ;

for i=2:Nfiles
    [x,y] = func_Import_CSTdata(file_string(i), 1) ;
    data_y(:,:,i) = y ;
end

%% FFT
for i=1:Nfiles
    [freqs, y_fft(:,i)] = func_FFT_CSTdata(data_y(:,:,i),x) ;
end

%% Plot
figure(1); clf;
hold on
for i=1:Nfiles
    plot(freqs,abs(y_fft(:,i)))
end
set(gca, "YScale", "log")
grid on
grid minor