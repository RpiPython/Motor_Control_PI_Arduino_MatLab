%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%               Control del Motor. Parte 1                 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Mediante este escript se desea obtener el modelo de la planta y sensor que
%vamos a emplear. Al tratarse de 2 motores DC que se desconocen sus
%caracteristicas, no es posible emplear el modelo matemático que describe
%el funcionamiento del mismo. Recordar que el primer motor estará
%alimentado por un PWM, que es el motor que deseamos controlar. Mientras
%que el segundo motor se empleara a modo sensor. Su cometido es traducir de
%rpm a Voltaje

% Para ello se somete el sistema a un escalón el cual nos devolverá una
% grágica en la cual se podrá analizar el comportamiento del mismo. 

clear all 
close all
clc

%% Configuracion del Arduino

a = arduino ('COM3','Mega2560','Libraries','Servo'); 
    % Pins que se emplearan en esta adquisicion
    Sensor = 'A0';
    P1 = 'D22';
    P2 = 'D24';
    PWM = 'D8';
    
    Speed = 0.0; % El motor se va someter de 0 a 1 (del estado de parada a máxima potencia)
%% VALORES AJUSTAR
ts = 0.01; % Tiempo de muestreo
fin = 400;  % Tiempo de simulacion

 %% Analisis del sistema
 % Fase previa para asegurar que todo esta detenido
 L293D(P1,P2,PWM,Speed,1,a); %Se manda la primera señal para que se detenga el motor
 pause(1); % Se realiza una pausa de 1 segundo
 
 % Adquisición de datos
 Speed = 1;
 L293D(P1,P2,PWM,Speed,1,a); 
 for i =1:1:fin
     vector(1,i)=3.6/1.2*readVoltage(a,Sensor);
     pause(ts);
 end
 Speed = 0;
 L293D(P1,P2,PWM,Speed,1,a);
 
 %% Representacion grafica
 fin = (fin-1)*ts;
 figure
 plot(0:ts:fin,vector)
 title('Analisis del sistema')
 xlabel ('Tiempo(s)')
 ylabel('Tensión(Volts)')
 grid on
 hold on
 referencia = 3.6*ones(1,size(vector,2));
 plot(0:ts:fin,referencia,'r')