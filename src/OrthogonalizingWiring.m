% OrthogonalizingWiring class:  connects inputs to outputs randomly
% supports connecting from smaller to larger vectors or vice versa
classdef OrthogonalizingWiring < Wiring 

    properties
    end
    methods
        function obj = OrthogonalizingWiring(dimensions)
           obj = obj@Wiring(dimensions); 
        end
        function buildConnectionList(obj)
            obj.connectionList = randi([1 obj.dimensions(1,2)],1,obj.dimensions(1,1));
        end
        function output = connect(obj, input)
            output = zeros(1,obj.dimensions(1,2)); 
            firedIndices = find(input == 1);
            for ii = firedIndices
                output(1,obj.connectionList(1,ii)) = 1;  % rows are synapses, cols are principal cells
            end
        end         
    end
end