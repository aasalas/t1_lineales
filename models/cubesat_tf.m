% cubesat_tf.m
% Calcula la TF V->theta directamente (sin usar algebra de SS)
function G = cubesat_tf(L, R_coil, N, A, B, I_inertia)
    s = tf('s');
    Km = N*A*B;
    G = Km / ( I_inertia * s^2 * (L*s + R_coil) );
end
