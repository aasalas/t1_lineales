%{
Magnetorquer project

Electronics engineering
Aarón Salas Alvarado
aasalas@estudiantec.cr
%}

% Magnetic momentum
I_x = 1; % [Amperes]
N = 15; % [Adimentional]
A = .08 * .08; % [m^2]

m = I_x * N * A; %[T]

% Earth magnetic field
B_0 = 60e-6; % [T] 
h = 400e3; %Altura [m]
R_e = 6371e3; % Radio de la tierra [m]

B_leo = B_0 * (R_e / (R_e + h))^3; %[T]

% Cubesat dynamics
mass = 0.5; % [kg]
l = 0.1; % [m]
J_xx = mass * l^2 /6; %[kg * m^2]

theta = deg2rad(150);   % desviación inicial [rad]
omega = 0;             % velocidad angular inicial
alpha = 0;             % aceleración angular inicial

seconds = 1000;          % tiempo total [s]
fps = 60;              % frames por segundo
dt = 1/fps;            % paso temporal
N = seconds * fps;     % número de pasos

% Prealocación
theta_vec = zeros(1, N);
omega_vec = zeros(1, N);
time = linspace(0, seconds, N);

for i = 1:N
    % Torque (depende del ángulo actual)
    torque = - m * B_0 * sin(theta);   % [N·m]
    
    % Dinámica rotacional
    alpha = torque / J_xx;           % aceleración angular
    omega = omega + alpha * dt;      % actualizar velocidad
    theta = theta + omega * dt;      % actualizar ángulo
    
    % Guardar resultados
    theta_vec(i) = theta;
    omega_vec(i) = omega;
end

% Graficar
figure
plot(time, rad2deg(theta_vec))
hold on;
%plot(time, omega_vec)
xlabel('Tiempo [s]')
ylabel('\theta [grados]')
title('Evolución angular del magnetorquer')
