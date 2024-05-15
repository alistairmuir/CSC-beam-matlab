%{
    Analytical formalae for the beam impedance of a pillbox cavity.
    
See "Loss factor for short bunches in azimuthally symmetric tapered structures", 
Blednykh and Krinsky, 2010.
%}

%% Constants (m)
gamma14 = 3.6256 ;    % Gamma function value for f(1/4).
c = 2.998e8 ;  % m/s
Z0 = 376.73 ;  % Ohms

units_factor = 1e-3 ;
mks_pico_factor = c*Z0/(4*pi)/1e12 ;


%% Step regime (g>d^2/sigma)
%%% Parameters
g = 2000*units_factor ;     % length of cavity
b = 6.25*units_factor ;     % innermost radius
L = 1*units_factor ;        % tapering section length
sigma = 0.5*units_factor ;  % bunch length

cutoff_factor = 5 ;

%%% Vectors
d = b+10.^(-5:0.1:1) ;
delta_db = d-b ;    % d-b

%%% Formulas
eq_21 = mks_pico_factor * (2/sqrt(pi)) * (1/sigma) * log(d./b) ;
eq_22 = mks_pico_factor * (1/(2*sqrt(pi))*(1./b)) * (delta_db./sigma).^2 ;
sqrt_gs = mks_pico_factor*sqrt(g*sigma) ;

%%% Truncating results to appropriate domain.
db_21 = delta_db(delta_db>sigma/cutoff_factor) ;
db_22 = delta_db(delta_db<sigma*cutoff_factor) ;

eq_21 = eq_21(delta_db>sigma/cutoff_factor) ;
eq_22 = eq_22(delta_db<sigma*cutoff_factor) ;

%%% Plot
figure(1);clf;
hold on
xline(sqrt_gs, 'gr')
plot(db_21, eq_21, 'r')
plot(db_22, eq_22, 'b')
set(gca,'Xscale','log')
set(gca,'Yscale','log')
grid on
grid minor
title("Step Regime")
xlabel("d-b (m)")
ylabel("\kappa")


%% Cavity regime (b<g<b^2/sigma)
%%% Parameters
g = 10*units_factor ;       % length of cavity
b = 6.25*units_factor ;    % innermost radius
L = 1*units_factor ;       % tapering section length
sigma = 0.5*units_factor ; % bunch length

cutoff_factor = 2 ;

%%% Vectors
d = b+10.^(-5:0.1:-0.5) ;
delta_db = d-b ;    % d-b

%%% Formulas
eq_23 = mks_pico_factor * gamma14/(pi^(3/2)) * (1./b) * sqrt(g./sigma) ;
eq_24 = mks_pico_factor * (1/(2*pi)) * (1./b) * (delta_db./sigma).^2 ;

%%% Truncating results to appropriate domain.
db_23 = delta_db(delta_db>sqrt(g*sigma/cutoff_factor)) ;
eq_23 = repmat(eq_23,1,length(db_23)) ;

db_24 = delta_db(delta_db<sqrt(g*sigma*cutoff_factor)) ;
eq_24 = eq_24(delta_db<sqrt(g*sigma*cutoff_factor)) ;

%%% Plot
figure(2);clf;
hold on
plot(db_23, eq_23, 'r')
plot(db_24, eq_24, 'b')
set(gca,'Xscale','log')
set(gca,'Yscale','log')
grid on
grid minor
title("Cavity Regime")
xlabel("d-b (m)")
ylabel("\kappa")


%% Slot regime (g<sigma)
%%% Parameters
g     = 0.1*units_factor ;     % length of cavity
b     = 6.25*units_factor ;    % innermost radius
L     = 1*units_factor ;       % tapering section length
sigma   = 0.5*units_factor ;   % bunch length

cutoff_factor = 10 ;

%%% Vectors
d = b+10.^(-5:0.1:-2) ;
delta_db = d-b ;    % d-b

%%% Formulas
eq_25 = mks_pico_factor * 1/(2*b) * (g./sigma) ;
eq_26 = mks_pico_factor * pi^(-3/2)*(1./b) * (delta_db./sigma).^2 * (g./sigma).^2 ;

%%% Truncating results to appropriate domain.
db_25 = delta_db(delta_db>(g)) ;
eq_25 = repmat(eq_25,1,length(db_25)) ;

db_26 = delta_db(delta_db<(g*cutoff_factor)) ;
eq_26 = eq_26(delta_db<(g*cutoff_factor)) ;

%%% Plot
figure(3);clf;
hold on
plot(db_25, eq_25, 'b')
plot(db_26, eq_26, 'r')
set(gca,'Xscale','log')
set(gca,'Yscale','log')
grid on
grid minor
title("Slot Regime")
xlabel("d-b (m)")
ylabel("\kappa")

