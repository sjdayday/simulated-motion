% SequentialWiring class:  connects inputs to outputs in sequence
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
            output = zeros(1,length(obj.connectionList)); 
            firedIndices = find(input == 1);
%                         fired = step@HebbMarrNetwork(obj, inputX, inputY); 
%             obj.currentInputX = obj.wiring.connect(fired);
            for ii = firedIndices
                output(1,obj.connectionList(1,ii)) = 1;  % rows are synapses, cols are principal cells
            end
        end         
    end
end