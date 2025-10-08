% Simulación en espacio de estados

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


%% Matrices del sistema (según derivación en la tarea)
A = [ 0      1      0      0        0;
     -Kx/Jx -Dx/Jx  0   (Jw/Jx)     0;
      0      0      0      1        0;
      0      0      0      0        1;
      0      0      0 -(R*Dz+kb*kt)/(Jz*L) -(R*Jz + Dz*L)/(Jz * L)];

B = [0; 0; 0; 0; kt/(Jz*L)];
C = [1 0 0 0 0];   % salida: θx
D = 0;

%% Definir sistema en espacio de estados

sys_ss = ss(A, B, C, D);
tf(sys_ss)

%% Respuesta al escalón y al impulso

%[y, t, x] = step(sys_ss);  
[y, t, x] = impulse(sys_ss);  

%% Plot
figure;
plot(t, y, 'k', 'LineWidth', 2);
grid on;
xlabel('Tiempo [s]');
ylabel('\theta_x(t)');
title('Respuesta al impulso mediante espacio de estados');
