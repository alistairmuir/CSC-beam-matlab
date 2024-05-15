%% Script to create a test generalized matrix
clc
clear


%% User input
f  = 0.5 ;
Nf = length(f) ;

N_modes = 2 ;
S_size = 2*N_modes+1 ;

save_name = "Matrices/Test/Generalized_Matrices/test"+N_modes ;


%% Create test matrix
S = zeros(Nf,S_size,S_size)+1e-3 ;

S(1,:,:) = squeeze(S(1,:,:)) + ...
    [0.1    0.0   0.0   0.0   0.0 ;
     0.0    0.1   0.0   0.0   0.0 ;
     0.0    0.0   0.0   0.0   0.0 ;
     0.0    0.0   0.0   0.0   0.0 ;
     0.0    0.0   0.0   0.0   0.7] ;

seg_length = 0.1 ;


%% Plot and save S matrix
%%% Plot
% figure(1); clf;
% hold on
% for ii = 1:S_size^2
%     scatter(f,S(:,ii),ii*10)
% end
% set(gca,'YScale','log')

%%% Save
save(save_name, 'S', 'f', 'seg_length')