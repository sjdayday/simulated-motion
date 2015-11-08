% Wiring class:  superclass to model the connection from one component to another 
% Known sub-classes:  
% SequentialWiring
classdef Wiring < handle 

    properties
        connectionList
        dimensions
    end
    methods
        function obj = Wiring(dimensions)
           obj.dimensions = dimensions; 
           obj.buildConnectionList();
        end
        function buildConnectionList(obj)
            % sub-classes must override
        end
        function output = connect(obj, input)
            % sub-classes must override
        end         
    end
end