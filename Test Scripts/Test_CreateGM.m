%% Script to create a test generalized matrix
clc
clear


%% User input
f = 1 ;  % Hz
N_modes = 1 ;

plot_on = false ;

save_name = "oddtest_"+N_modes+"modes" ;
save_dir  = "Matrices/Test/Generalized_Matrices" ;


%% Create test matrix
%%% Assess sizes.
Nf = length(f) ;
S_size = 2*N_modes+1 ;

% Initialize
S = zeros(Nf,S_size,S_size) ;


%% User input: Create matrix
for fi=1:Nf
    for ii=1:S_size
        S(fi,:,:) = 0 ;
    end
end

% Full asymmetrical test.
% for sii=1:Nf
%     S(sii,:,:) = squeeze(S(sii,:,:)) + ...
%        [0.7      0.5      0.3      0.2      0.1    ;
%         0.07     0.05     0.03     0.02     0.01   ;
%         0.007    0.005    0.003    0.002    0.001  ;
%         0.0007   0.0005   0.0003   0.0002   0.0001 ;
%         0.00007  0.00005  0.00003  0.00002  0.00001] ;
% end

for sii=1:Nf
    S(sii,:,:) = squeeze(S(sii,:,:)) + ...
       [3   7  11 ;
        0.4 4  0.5 ;
        13  17 5 ] * sii ;
end

Length = 0.1 ;


%% Plot and save S matrix
%%% Plot
if plot_on==true
    figure(1); clf;
    hold on
    for ii = 1:S_size^2
        scatter(f,S(:,ii), ii*5)
    end
    set(gca,'YScale','log')
    grid on
    grid minor
end

disp("S (full matrix):")
disp(S)


%% Save
save_fullname = save_dir+"/"+save_name ;
save(save_fullname, 'S', 'f', 'Length')

