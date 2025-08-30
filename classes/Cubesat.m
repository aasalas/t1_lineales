classdef Cubesat
    % Cubesat: contiene inercia por eje y arreglo de magnetorquers
    properties
        I           % [Ix Iy Iz]
        torquers    % array de Magnetorquer
    end
    methods
        function obj = Cubesat(Ivec)
            if nargin==0
                obj.I = [0.01 0.01 0.01];
            else
                obj.I = Ivec;
            end
            obj.torquers = Magnetorquer.empty;
        end
        
        function obj = addMagnetorquer(obj, torq)
            obj.torquers(end+1) = torq;
        end
        
        function G = getTransferFunctions(obj)
            % Retorna cell array {Gx, Gy, Gz} TF V->theta por eje
            n = length(obj.torquers);
            G = cell(n,1);
            for k=1:n
                G{k} = obj.torquers(k).getVtoTauTF(obj.I(k));
            end
        end
        
        function SS = getStateSpaceModels(obj)
            % Retorna cell array {SSx, SSy, SSz}
            n = length(obj.torquers);
            SS = cell(n,1);
            for k=1:n
                SS{k} = obj.torquers(k).getStateSpaceElectroMech(obj.I(k));
            end
        end
    end
end
