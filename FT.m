% Simulación del sistema mediante la función de transferencia

%% Parámetros del motor
kt = 1;  % (N·m)/A
kb = 1;  % (V·s)/rad

L = 1;   % H
R = 1;   % Ohm

Jz = 1;  % (N·s^2)/m
Dz = 1;  % (N·s)/m

%% Parámetros del giroscopio
Jw = 1;  % (N·s)/m

Jx = 1;  % (N·s^2)/m
Dx = 1;  % (N·s)/m
Kx = 1;  % (N/m)

%% Simulación
s = tf('s');

% Función de transferencia del motor
M = kt / (Jz*L*s^3 + (R*Jz + L*Dz)*s^2 + (R*Dz + kt*kb)*s);
disp('Función de transferencia del motor M(s):')
tf(M)

% Función de transferencia del giroscopio
G = (Jw*s) / (Jx*s^2 + Dx*s + Kx);
disp('Función de transferencia del giroscopio G(s):')
tf(G)

% Sistema en cascada (motor * giroscopio)
FT_total = M * G;
disp('Función de transferencia total del sistema:')
tf(FT_total)

% Respuesta al escalón
figure;
%step(FT_total)
impulse(FT_total)
grid on
title('Respuesta al impulso mediante función de transferencia')
xlabel('Tiempo [s]')
ylabel('\theta_x(t)')
