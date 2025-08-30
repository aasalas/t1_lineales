function sim_step_response(Gcell, SScell, Ccell, params)
    if nargin<4, params = sat_params(); end
    t = 0:params.dt:100;

    % --- asegurar carpeta de salida
    if ~exist('results/figures','dir')
        mkdir('results/figures');
    end

    figure('Name','Open-loop step responses (V -> theta)');
    hold on;
    colors = {'r','g','b'};
    for k = 1:length(Gcell)
        [y_tf, tt] = step(Gcell{k}, t);
        plot(tt, y_tf, colors{k}, 'LineWidth',1.5);

        [y_ss, ~, ~] = lsim(SScell{k}, ones(size(t)), t);
        plot(t, y_ss, [colors{k} '--'], 'LineWidth',1);
    end
    xlabel('Time [s]'); ylabel('\theta [rad]');
    title('Open-loop responses: TF (solid) vs SS (dashed)');
    legend('X TF','X SS','Y TF','Y SS','Z TF','Z SS');
    grid on; hold off;

    saveas(gcf,'results/figures/open_loop_compare.png');
