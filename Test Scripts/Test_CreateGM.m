%% Script to create a test generalized matrix
clc
clear


%% User input
f  = 1:1:10 ;
Nf = length(f) ;

N_modes = 2 ;
S_size = 2*N_modes+1 ;

save_name = "Matrices/Test/Generalized_Matrices/test"+N_modes ;


%% Create test matrix
S = zeros(Nf,S_size,S_size)+1e-3 ;

% Diagonal test
for ii=1:S_size
    S(:,ii,ii) = [1:Nf]'./Nf ;
end

% Full asymmetrical test.
% for sii=1:Nf
%     S(sii,:,:) = squeeze(S(sii,:,:)) + ...
%        [0.7      0.5      0.3      0.2      0.1    ;
%         0.07     0.05     0.03     0.02     0.01   ;
%         0.007    0.005    0.003    0.002    0.001  ;
%         0.0007   0.0005   0.0003   0.0002   0.0001 ;
%         0.00007  0.00005  0.00003  0.00002  0.00001] * (2*sii/Nf) ;
% end

Length = 0.1 ;


%% Plot and save S matrix
%%% Plot
figure(1); clf;
hold on
for ii = 1:S_size^2
    scatter(f,S(:,ii), ii*5)
end
set(gca,'YScale','log')
grid on
grid minor

%%% Save
save(save_name, 'S', 'f', 'Length')

