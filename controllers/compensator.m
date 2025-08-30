% compensator.m
% Un compensador simple tipo lead-lag (ejemplo)
function C = compensator()
    % Ejemplo: lead compensator = K * (tau_z*s + 1)/(tau_p*s + 1)
    K = 1; tau_z = 1; tau_p = 0.1;
    s = tf('s');
    C = K * (tau_z*s + 1)/(tau_p*s + 1);
end
