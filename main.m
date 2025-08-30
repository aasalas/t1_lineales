% main.m
% Orquesta la generación de modelos, sintonía rápida y corre simulaciones
clc; clear; close all;
addpath(genpath(fileparts(mfilename('fullpath'))));
% --- 1) Cargar parámetros del satélite y magnetorquers
params = sat_params();
% --- 2) Construir 3 magnetorquers y el Cubesat (3 ejes)
% Asegúrate de que tu clase Magnetorquer acepta V_max y V_min
mq_x = Magnetorquer(params.L, params.R_coil, params.N, params.A, params.B, params.V_max, params.V_min); 
mq_y = Magnetorquer(params.L, params.R_coil, params.N, params.A, params.B, params.V_max, params.V_min);
mq_z = Magnetorquer(params.L, params.R_coil, params.N, params.A, params.B, params.V_max, params.V_min);
sat = Cubesat([params.Ix, params.Iy, params.Iz]);
sat = sat.addMagnetorquer(mq_x);
sat = sat.addMagnetorquer(mq_y);
sat = sat.addMagnetorquer(mq_z);
% --- 3) Obtener modelos (TF y SS) por eje
G = sat.getTransferFunctions();      % cell array de objetos tf (V -> theta)
SS = sat.getStateSpaceModels();      % cell array de objetos ss (electromechanical)
% --- 4) Diseñar controladores (ahora de forma automática)
C_pid = cell(3,1);
info_pid = cell(3,1);
for k=1:3
    % ⭐ Usar el método tunePID para sintonizar el controlador ⭐
    [C_pid{k}, info_pid{k}] = sat.magnetorquers(k).tunePID(sat.I(k));
end
% --- 5) Simulaciones de validación
% La saturación debe ser implementada DENTRO de estas funciones
sim_step_response(G, SS, C_pid, params);
sim_operating_case1(G, SS, C_pid, params);
sim_operating_case2(G, SS, C_pid, params);
% --- 6) Guardar resultados básicos
if ~exist('results','dir'); mkdir('results'); end
save('results/simulation_workspace.mat');
fprintf('Simulaciones completadas. Archivos guardados en /results\n');