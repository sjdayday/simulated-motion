% SequentialWiring class:  connects inputs to outputs in sequence
classdef SequentialWiring < Wiring 

    properties
    end
    methods
        function obj = SequentialWiring(dimensions)
           obj = obj@Wiring(dimensions); 
        end
        function buildConnectionList(obj)
            obj.connectionList = 1:1:obj.dimensions; 
        end
        function output = connect(obj, input)
            output = zeros(1,obj.dimensions); 
            for ii = obj.connectionList
                output(1,ii) = input(1,ii); 
            end
        end         
    end
end