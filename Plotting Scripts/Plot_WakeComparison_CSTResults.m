%% Script to compare CST wake results
clc
clear

%% Import results
%%% Import direct simulation no.1
S_folder = "CST Files/Pillbox" ;
S_filenames = ["Wake_hifi", ...
               "Wake_15GHz_30cpw_3modes_10sigma_1M"] ;

ledg = S_filenames ;

S_filenames = S_filenames + "/Export/Particle Beams/ParticleBeam1/Wake impedance/Z" ;

for ii=1:length(S_filenames)
    S_temp = readmatrix("CST Files/Pillbox/"+S_filenames(ii)+".txt") ;
	S(:,ii) = S_temp(:,2) + 1i*S_temp(:,3) ;
end

S(:,2) = S(:,2).*2 ;

Sdb = convert2db(S) ;
Sphase = rad2deg(angle(S)) ;


f = S_temp(:,1) ;

%% Plotting
figure(401); clf
plot(f,Sdb, ':', 'LineWidth', 2)
legend(ledg)
grid on
grid minor
xlabel("Freq / GHz")
ylabel("Z_z / dB")

figure(402); clf
plot(f,Sphase, ':', 'LineWidth', 2)
legend(ledg)
grid on
grid minor
xlabel("Freq / GHz")
ylabel("Phase / \circ")