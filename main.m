% main.m
% Orquesta la generación de modelos, sintonía rápida y corre simulaciones
clc; clear; close all;
addpath(genpath(fileparts(mfilename('fullpath'))));
% --- 1) Cargar parámetros del satélite y magnetorquers
params = sat_params();

% --- 2) Construir 3 magnetorquers y el Cubesat (3 ejes)
mq_x = Magnetorquer(params.L, params.R_coil, params.N, params.A, params.B); 
mq_y = Magnetorquer(params.L, params.R_coil, params.N, params.A, params.B);
mq_z = Magnetorquer(params.L, params.R_coil, params.N, params.A, params.B);

sat = Cubesat([params.Ix, params.Iy, params.Iz]);
sat = sat.addMagnetorquer(mq_x);
sat = sat.addMagnetorquer(mq_y);
sat = sat.addMagnetorquer(mq_z);

% --- 3) Obtener modelos (TF y SS) por eje
G = sat.getTransferFunctions();      % cell array of tf objects (V -> theta)
SS = sat.getStateSpaceModels();      % cell array of ss objects (electromechanical)

% --- 4) Diseñar controladores (simple PID por eje)
Kp = 5; Ki = 1; Kd = 0.1;
C_pid = cell(3,1);
for k=1:3
    C_pid{k} = pid(Kp, Ki, Kd);
end

% --- 5) Simulaciones de validación
sim_step_response(G, SS, C_pid, params);
sim_operating_case1(G, SS, C_pid, params);
sim_operating_case2(G, SS, C_pid, params);

% --- 6) Guardar resultados básicos
if ~exist('results','dir'); mkdir('results'); end
save('results/simulation_workspace.mat');
fprintf('Simulaciones completadas. Archivos guardados en /results\n');
