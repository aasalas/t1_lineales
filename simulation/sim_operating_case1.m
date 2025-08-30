% sim_operating_case1.m
% Simulación: variación de R_coil (ejemplo de escenario)
function sim_operating_case1(Gcell, SScell, Ccell, params)
    if nargin<4, params = sat_params(); end
    % Escenario: resistencia doblada (R -> 2R), ver efecto en respuesta
    R2 = 2*params.R_coil;
    Gx_new = cubesat_tf(params.L, R2, params.N, params.A, params.B, params.Ix);
    t = 0:params.dt:100;
    figure('Name','Effect of doubled coil resistance on X axis');
    hold on;
    [y_old, tt] = step(Gcell{1}, t);
    [y_new, ~] = step(Gx_new, t);
    plot(tt, y_old, 'b', 'LineWidth',1.5);
    plot(tt, y_new, 'r--', 'LineWidth',1.5);
    legend('Original R','R doubled');
    xlabel('Time [s]'); ylabel('\theta [rad]');
    title('Sensitivity to coil resistance (Axis X)');
    grid on; hold off;
    saveas(gcf,'results/figures/resistance_sensitivity_x.png');
end
