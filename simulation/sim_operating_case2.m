% sim_operating_case2.m
% Simulación: referencia y perturbación (impulso de torque equivalente)
function sim_operating_case2(Gcell, SScell, Ccell, params)
    if nargin<4, params = sat_params(); end
    t = 0:params.dt:200;
    % Vamos a simular eje X con controlador y añadir una perturbación en torque
    % Implementamos todo en espacio de estados extendido (entrada: V, disturbance as add to d(omega)/dt)
    SS = SScell{1};
    
    % Convertir SS a forma con entrada V y una entrada adicional d(torque) (augment)
    % Estado original x = [i; omega; theta], d/dt = A x + Bv * v
    [A,B,C,D] = ssdata(SS);
    % Agregamos una perturbación 'w' que entra en domega/dt: domega/dt += w/I
    % Aquí, we will simulate by superposing: y_total = response_to_v + response_to_w
    % response to v with controller in closed-loop:
    Cx = Ccell{1};
    Tcl = feedback(Cx*Gcell{1}, 1);
    
    % Simula referencia escalón de theta = 0.1 rad command
    r = 0.1*ones(size(t)); % desired theta
    [y_cl, ~] = lsim(Tcl, r, t);
    
    % Simula an impulso de torque externo como señal en domega:
    w = zeros(size(t)); w(201) = 1e-4; % breve pulso de torque-equivalente
    % Para la respuesta aproximada al torque externo en la salida theta:
    % Transfer from torque tau -> theta is 1/(I s^2) (mechanical)
    s = tf('s');
    G_tau2theta = 1/(params.Ix * s^2);
    % Simula efecto del pulso w (as torque input) con lsim:
    % Transform pulse into equivalent voltage input approx: v_eq = ??? (we approximate using direct tau)
    y_dist = lsim(G_tau2theta, w, t);
    
    y_total = y_cl + y_dist;
    
    figure('Name','Closed-loop with disturbance (X-axis)');
    plot(t, y_cl, 'b', 'LineWidth',1.2); hold on;
    plot(t, y_total, 'r--', 'LineWidth',1.2);
    legend('Closed-loop w/o disturbance','With disturbance pulse');
    xlabel('Time [s]'); ylabel('\theta [rad]');
    title('Closed-loop response with external torque disturbance (X axis)');
    grid on; hold off;
    saveas(gcf,'results/figures/closed_loop_disturbance_x.png');
end
