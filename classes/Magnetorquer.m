classdef Magnetorquer
    % Magnetorquer: modelo físico del actuador (RL + ganancia magnética)
    properties
        L       % inductancia [H]
        R       % resistencia [Ohm]
        N       % vueltas
        A       % area [m^2]
        B       % campo geomag [T] usado para linealizar Km = N*A*B
        V_max   % Voltaje máximo de saturación
        V_min   % Voltaje mínimo de saturación
    end
    
    methods
        function obj = Magnetorquer(L, R, N, A, B, V_max, V_min)
            if nargin>0
                obj.L = L;
                obj.R = R;
                obj.N = N;
                obj.A = A;
                obj.B = B;
                obj.V_max = V_max;
                obj.V_min = V_min;
            end
        end
        
        function Km = Km(obj)
            % Ganancia entre corriente y torque proyectado en el eje (lineal)
            Km = obj.N * obj.A * obj.B;
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
        
        % -----------------------------------------------------------------
        % Nuevos métodos para sintonización y saturación
        % -----------------------------------------------------------------
        
        function [C, info] = tunePID(obj, I_inertia)
            % Sintoniza un controlador PID para el sistema
            % I_inertia: momento de inercia
            
            % Obtiene el modelo del sistema (TF)
            G = obj.getVtoTauTF(I_inertia);
            
            % Usa pidtune para sintonizar el controlador
            [C, info] = pidtune(G, 'PID');
            
            % Muestra los resultados de la sintonización
            disp('Controlador PID sintonizado:');
            disp(C);
            disp('Información de sintonización:');
            disp(info);
            
            % Opcional: Grafica la respuesta del sistema en lazo cerrado
            figure;
            step(feedback(C*G,1));
            title('Respuesta al escalón del sistema en lazo cerrado');
            xlabel('Tiempo');
            ylabel('Posición (rad)');
        end
        
        function Vs = saturate(obj, V_in)
            % Aplica la saturación al voltaje de entrada
            % V_in: voltaje de control calculado por el controlador
            Vs = max(obj.V_min, min(V_in, obj.V_max));
        end
        
    end
end