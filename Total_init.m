clear all
close all

Vac = 4000; %based on 10MW design
%% Mechanical
rho = 1.225; %ISA rho
R = 89.2;
A = R^2*pi; %swept area of rotor

r = 26.2+2.8; %centre of mass of blade
m = 41715.7; %mass of the blade
Jr = 3*m*r^2; %ASSUMING POINT MASS!

C1 = 0.0117;
C2 = 5500;
C3 = 10;
C4 = 0;
C5 = 160;
C6 = 23.38;
Cx = 0;

lambda_opt = 9.35; %at beta=0

%% PM 
% given parameters
p = 160;
Ld = 0.005;
Lq = 0.005;
Rs  = 0.1454; %based on pu

J = 12.8e6;% 650e3; %new value based on ring of PM magnets and solid cylinder of steel
om_r = 10/60*2*pi;
oms = p*om_r;
om0 = om_r; %cannot be zero because P/omega=T

% Lambda m
Pr = 10e6;
Er = 0.9*Vac; %assumption
lambda_m = Er/(om_r*p); %from Er = lambda_m*p*om_r
cosphi = 0.9; %assumption
Ir = 2*Pr/(3*Er*cosphi); %from P = 3/2*Er*Ir*cosphi

% Initial values
I0 = [0 0];
Ud0 = 0;
Uq0 = 0;
fi0 = 0;

%% B2B converter
Vdc = Vac*sqrt(3); %because Vac can only reach Vdc/sqrt(3)
Vgsc = Vac;
ts = 0.0001;

% Controller parameters
KP_q = 50;
KI_q = KP_q*Rs/Lq;
KP_d = 50;
KI_d = KP_d*Rs/Ld;

KP_g = 5;
KP_gv = 5;
KP_gq = 1;

% Grid parameters
om_g = 100*pi;
fg = 50;
Vg = 35e3;

% Impedances
Rg = 1e-6;
Lg = 1e-3; %should be 1e-3 according to 0.05 pu

R_cs = 1e9; %large resistor in parallel w controlled current sources
R_dc = 1e-3; %dc link resistance
C_dc = 1e-2; %dc link capacitance

%% Simulink matrices
pmat = [0 -p;... 
        p 0];
    
Rmat = [Rs 0;...
        0 Rs];
    
Lmat = [Ld 0;... 
        0 Lq];

Linvmat = Lmat^(-1);

psif = [lambda_m; 0];
psi0 = Lmat*I0'+psif;