%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                          CONTROLADOR PI                           %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Este archivo realiza un control PI sobre un motor DC.

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
  %% Configura tu sistema
 K = 3.6; % Ajsute de ganacia de 1 a 3.6V
 GanciaE = 3.6/1.2; % Ajuste de la lectura del sensor
 Ref = 0.8 * K; % Recordar la relacion entre PWM y Volts
 ts = 0.01; % Siempre el mismo que el de discretización
 %% Analisis del sistema
 % Fase previa para asegurar que todo esta detenido
 L293D(P1,P2,PWM,Speed,1,a); %Se manda la primeraseñal para que se detenga el motor
 pause(1); % Se realiza una pausa de 1 segundo
 
% Inicializar valores
 E = 0;
 E_ant = 0;
 S = 0;
 S_ant = 0;
 Volt = 0;

%% Control
fin = 400;
figure 
hold on
 pause(15)
for i =1:1:fin
% Actualizar variables
    E_ant = E;
    E = Ref-Volt;
    S_ant = S;
    % Lectura con la gancia del sensor
    Volts(1,i) = GanciaE*readVoltage(a,Sensor);
    Volt = Volts(1,i);
    % PI
    S = E*0.12 - E_ant*0.0908 + S_ant;

    % Ajuste de Volts a PWM. Recordar que el valor de 1 en PWM equivale a 3.6V
    Speed = S/K;
    %Saturador evita que se sature el sistema
    if Speed >= 1
        Speed = 1;
    end
    if Speed <= 0
        Speed = 0;
    end
    L293D(P1,P2,PWM,Speed,1,a);
    pause (ts);
    plot(i,Volt,'xb')
    
end
title('Respuesta en tiempo real')
xlabel('Muestras')
ylabel('Tension')
fin = (fin-1)*ts;
time = 0:ts:fin;
figure
hold on
plot(time,Volts,'b')
plot (time,Ref,'.--r')
 L293D(P1,P2,PWM,0,1,a);
 title('Respuesta del sistema con el controlador')
 xlabel('Tiempo(s)')
 grid on
 ylabel('Voltaje(V)')
 
 
 