% Sistema de coordenadas 3D con ejes XYZ y sub-ejes IJK rotados
% Nota: Este código requiere la función arrow3 de MATLAB File Exchange
% https://www.mathworks.com/matlabcentral/fileexchange/14056-arrow3
clear all; close all; clc;
% Definir los ejes de referencia XYZ (vectores unitarios)
O = [0, 0, 0];  % Origen
X_axis = [1, 0, 0];  % Eje X
Y_axis = [0, 1, 0];  % Eje Y
Z_axis = [0, 0, 1];  % Eje Z
% Definir ángulos de rotación (en radianes)
alpha = pi/15;   % Rotación alrededor del eje X 
beta  = pi/15;   % Rotación alrededor del eje Y 
gamma = pi/15;   % Rotación alrededor del eje Z 
% Matrices de rotación individuales
Rx = [1, 0, 0;
      0, cos(alpha), -sin(alpha);
      0, sin(alpha), cos(alpha)];
Ry = [cos(beta), 0, sin(beta);
      0, 1, 0;
      -sin(beta), 0, cos(beta)];
Rz = [cos(gamma), -sin(gamma), 0;
      sin(gamma), cos(gamma), 0;
      0, 0, 1];
% Matriz de rotación compuesta (ZYX - rotación intrínseca)
R = Rz * Ry * Rx;
% Aplicar la rotación a los ejes para obtener IJK
I_axis = R * X_axis';  % Eje I (X rotado)
J_axis = R * Y_axis';  % Eje J (Y rotado)
K_axis = R * Z_axis';  % Eje K (Z rotado)
% Crear la figura
figure('Name', 'Sistema de Coordenadas XYZ e IJK Rotado con Cubo', ...
       'Position', [100, 100, 800, 600]);

% Plotear los ejes XYZ (sistema de referencia) con flechas sólidas

arrow3(O, X_axis*1.5, 'r-3', 4, 12, 0.1); 
hold on;
arrow3(O, Y_axis*1.5, 'g-3', 4, 12, 0.1);
arrow3(O, Z_axis*1.5, 'b-3', 4, 12, 0.1);
% Plotear los ejes IJK (sistema rotado) con flechas punteadas
arrow3(O, I_axis' * 1.3, 'r--2', 4, 12, 0.1);
arrow3(O, J_axis' * 1.3, 'g--2', 4, 12, 0.1);
arrow3(O, K_axis' * 1.3, 'b--2', 4, 12, 0.1);
% --------------------------------------------------------------------
% Sección para crear y rotar el cubo
% Definir los vértices del cubo no rotado (centrado en el origen)
V = [ -0.5 -0.5  0.5;   % Vértice 1
      -0.5  0.5  0.5;   % Vértice 2
       0.5  0.5  0.5;   % Vértice 3
       0.5 -0.5  0.5;   % Vértice 4
      -0.5 -0.5 -0.5;   % Vértice 5
      -0.5  0.5 -0.5;   % Vértice 6
       0.5  0.5 -0.5;   % Vértice 7
       0.5 -0.5 -0.5];  % Vértice 8
   
% Aplicar la rotación del cubo
V_rot = (R * V')';
% Definir las caras del cubo usando los índices de los vértices
F = [ 1 2 3 4;   % Cara frontal
      5 6 7 8;   % Cara trasera
      1 5 8 4;   % Cara inferior
      2 6 7 3;   % Cara superior
      1 5 6 2;   % Cara izquierda
      4 8 7 3];  % Cara derecha
% Plotear el cubo rotado
% Creación del cubo
h_cubo = patch('Vertices', V_rot, 'Faces', F, ...
               'FaceColor', [0.8 0.8 0.8], 'FaceAlpha', 1, ...
               'EdgeColor', 'k', ...
               'FaceLighting', 'gouraud', 'EdgeLighting', 'gouraud', ...
               'AmbientStrength', 0.4);

% Añadir una fuente de luz al gráfico (si no tienes una ya)
light('Position', [1 1 1], 'Style', 'local'); % Puedes ajustar la posición de la luz

% Configuración del renderizado
lighting phong;
material dull; 
% --------------------------------------------------------------------
% Añadir etiquetas a los ejes
text(1.8, 0, 0, '$\hat{x}$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'r');
text(0, 1.8, 0, '$\hat{y}$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'g');
text(0, 0, 1.8, '$\hat{z}$', 'Interpreter', 'latex',  'FontSize', 14, 'FontWeight', 'bold', 'Color', 'b');
l = 1.5;
text(I_axis(1)*l, I_axis(2)*l, I_axis(3)*l, '$\hat{A}_x$', 'Interpreter', 'latex', ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'r');
text(J_axis(1)*l, J_axis(2)*l, J_axis(3)*l, '$\hat{A}_x$', 'Interpreter', 'latex',  ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'g');
text(K_axis(1)*l, K_axis(2)*l, K_axis(3)*l,  '$\hat{A}_x$', 'Interpreter', 'latex', ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'b');
% Configurar la gráfica
grid on;
axis equal;
xlim([-1.5, 1.5]);
ylim([-1.5, 1.5]);
zlim([-1.5, 1.5]);
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Sistema de Coordenadas XYZ (sólido) e IJK Rotado (punteado)');
% Añadir leyenda
%legend({'X','Y','Z','I','J','K', 'Cubo Rotado'}, 'Location', 'northeast');
% Configurar vista 3D
view(140, 15);
camlight;
rotate3d on;