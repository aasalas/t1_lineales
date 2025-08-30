% pid_controller.m
% Crea un controlador PID con argumentos (Kp, Ki, Kd)
function C = pid_controller(Kp, Ki, Kd)
    if nargin<3, Kd = 0; end
    if nargin<2, Ki = 0; end
    C = pid(Kp, Ki, Kd);
end
