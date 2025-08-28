% Asume que has ejecutado la simulación 3D y tienes los vectores q_hist, omega_hist y time

% Crea una figura para la animación
figure;
ax = gca;
view(3);
grid on;
axis([-0.2 0.2 -0.2 0.2 -0.2 0.2]);
xlabel('Eje X');
ylabel('Eje Y');
zlabel('Eje Z');
title('Animación de la orientación del CubeSat en 3D');

% Define los vértices del CubeSat (cubo)
vertices = [
    -0.05, -0.05, -0.05;
    0.05, -0.05, -0.05;
    0.05, 0.05, -0.05;
    -0.05, 0.05, -0.05;
    -0.05, -0.05, 0.05;
    0.05, -0.05, 0.05;
    0.05, 0.05, 0.05;
    -0.05, 0.05, 0.05;
];

% Define las caras del cubo para el parche
faces = [
    1, 2, 6, 5;
    2, 3, 7, 6;
    3, 4, 8, 7;
    4, 1, 5, 8;
    1, 2, 3, 4;
    5, 6, 7, 8;
];

% Crea el objeto de parche del cubo
cube_patch = patch('Vertices', vertices, 'Faces', faces, ...
    'FaceColor', 'blue', 'EdgeColor', 'black', 'FaceAlpha', 0.8);

% Ciclo de animación
for i = 1:N
    % Obtén el cuaternión actual
    q_current = q_hist(:, i)';
    
    % Crea la matriz de rotación a partir del cuaternión
    R = quat2rotm(q_current);
    
    % Rota los vértices del cubo
    rotated_vertices = (R * vertices')';
    
    % Actualiza las posiciones de los vértices en el gráfico
    set(cube_patch, 'Vertices', rotated_vertices);
    
    % Dibuja la animación
    drawnow;
end