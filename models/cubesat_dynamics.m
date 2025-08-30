% cubesat_dynamics.m
% Construye SS por eje desde parámetros físicos (independiente de TF)
function SS = cubesat_dynamics(L, R_coil, N, A, B, I_inertia)
    % Estados: [i; omega; theta]
    Km = N*A*B;
    A_mat = [ -R_coil/L, 0, 0;
               Km/I_inertia, 0, 0;
               0, 1, 0 ];
    B = [1/L; 0; 0];
    C = [0 0 1];
    D = 0;
    SS = ss(A_mat, B, C, D);
end
