% sat_params.m
% Parámetros físicos del CubeSat y magnetorquers
function params = sat_params()
    % Inercia por eje (kg*m^2) - ejemplo (ajusta según tu CubeSat)
    params.Ix = 0.01;
    params.Iy = 0.01;
    params.Iz = 0.012;
    
    % Magnetorquer (coils) parameters
    params.N = 200;           % vueltas
    params.A = 0.01;          % m^2 (area de la bobina)
    params.L = 0.01;          % H
    params.R_coil = 1.0;      % Ohm
    params.B = 2e-5;          % Tesla (valor típico en LEO - ajustar)
    
    % Simulación temporal
    params.dt = 0.01;         % s (paso para integración numérica/plots)
    params.Tsim = 200;        % s (tiempo total de simulación)
end
