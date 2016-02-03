% OrthogonalizingWiring class:  connects inputs to outputs randomly
% supports connecting from smaller to larger arrays or vice versa
% dimensions:  [inputLength connectionListLength]
% output will be an array the length of the connectionList  
% When the input is smaller than the connectionList (typical for
% orthogonalizing), only inputLength/connectionListLength
% of the connectionList will be used for any given call to the connect
% method.  Each input is used as a seed to rebuild the connectionList for
% its connect call.  Over time, this should lead to roughly uniform usage
% of the connectionList space. 
classdef OrthogonalizingWiring < Wiring 

    properties
        seed
        inputIndices
        connnectionListLength
        inputLength
        rebuildConnections
    end
    methods
        function obj = OrthogonalizingWiring(dimensions)
           obj = obj@Wiring(dimensions); 
           obj.seed = 0;
           obj.rebuildConnections = false; 
        end
        function buildConnectionList(obj)
           obj.connnectionListLength = obj.dimensions(1,2); 
           obj.inputLength = obj.dimensions(1,1);
           % above should be in constructor, but super constructor calls this
            obj.seed = 0;
            for ii = obj.inputIndices
                tempSeed = obj.seed + 2^ii; 
                if tempSeed < 2^32
                    obj.seed = tempSeed;
                end
            end
            obj.connectionList = randi(RandStream('mt19937ar','Seed',obj.seed) ...
                ,obj.connnectionListLength,1,obj.inputLength);
        end
        function output = connect(obj, input)
            obj.inputIndices = find(input == 1);
            if obj.rebuildConnections 
                obj.buildConnectionList();
            end
            output = zeros(1,obj.connnectionListLength); 
            for ii = obj.inputIndices
                output(1,obj.connectionList(1,ii)) = 1;  
            end
        end         
    end
end