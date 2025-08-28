
function R = rot(x, y, z)
% rot(x, y, z) calcula la matriz de rotación total.
%
%   Args:
%       x (double): Ángulo de rotación alrededor del eje x en radianes.
%       y (double): Ángulo de rotación alrededor del eje y en radianes.
%       z (double): Ángulo de rotación alrededor del eje z en radianes.
%
%   Returns:
%       R (double): La matriz de rotación total de 3x3.

    % Matriz de rotación alrededor del eje x
    Rx = [1, 0, 0;
          0, cos(x), -sin(x);
          0, sin(x), cos(x)];

    % Matriz de rotación alrededor del eje y
    Ry = [cos(y), 0, sin(y);
          0, 1, 0;
          -sin(y), 0, cos(y)];

    % Matriz de rotación alrededor del eje z
    Rz = [cos(z), -sin(z), 0;
          sin(z), cos(z), 0;
          0, 0, 1];

    % Multiplicación de las matrices de rotación en el orden ZYX
    % Este orden es común en la cinemática de robots y la navegación
    % aeronáutica, donde las rotaciones se aplican secuencialmente.
    R = Rz * Ry * Rx;
end

