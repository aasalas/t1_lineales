classdef Magnetorquer
    % Magnetorquer: modelo físico del actuador (RL + ganancia magnética)
    properties
        L       % inductancia [H]
        R       % resistencia [Ohm]
        N       % vueltas
        A       % area [m^2]
        B       % campo geomag [T] usado para linealizar Km = N*A*B
    end
    methods
        function obj = Magnetorquer(L, R, N, A, B)
            if nargin>0
                obj.L = L;
                obj.R = R;
                obj.N = N;
                obj.A = A;
                obj.B = B;
            end
        end
        
        function Km = Km(obj)
            % Ganancia entre corriente y torque proyectado en el eje (lineal)
            Km = obj.N * obj.A * obj.B; % [A·m^2 * T -> N·m per A?] (ver nota)
        end
        
        function Gv2i = getVLTI(obj)
            % Función de transferencia V(s) -> I(s) del circuito RL
            s = tf('s');
            Gv2i = 1/(obj.L*s + obj.R);
        end
        
        function Gv2tau = getVtoTauTF(obj, I_inertia)
            % TF completa V -> theta: Km / (I s^2 (L s + R))
            s = tf('s');
            Gv2tau = obj.Km() / (I_inertia * s^2 * (obj.L*s + obj.R));
        end
        
        function SS = getStateSpaceElectroMech(obj, I_inertia)
            % Devuelve espacio de estados del sistema electromecánico por eje
            % estados: x = [i; omega; theta]
            % di/dt = -R/L * i + 1/L * v
            % domega/dt = (Km / I) * i
            % dtheta/dt = omega
            R = obj.R; L = obj.L; Km = obj.Km(); I = I_inertia;
            A = [ -R/L   0       0;
                   Km/I  0       0;
                   0     1       0 ];
            B = [ 1/L; 0; 0 ];
            C = [ 0 0 1 ];    % salida: theta
            D = 0;
            SS = ss(A,B,C,D);
        end
    end
end
