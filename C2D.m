%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  analogico to digital     %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc
%% Valores de tu controlador
% Introduce aquí los valores de tu controlador para discretizarlo
P = 0.12;
I = 2.91;
ts = 0.01;

% Control
s = tf('s');

C = P + I/s;
Cd = c2d(C,ts)
