% AutoassociativeNetwork class:  extends HebbMarrNetwork
% for auto-association by adding recurrent connections from outputs 
% from period t as the inputs to period t+1, as proposed in: 
% McNaughton, B. L., & Nadel, L. (1990). "Hebb-Marr networks and the neurobiological
% representation of action in space" Neuroscience and connectionist theory, 1{63.
classdef AutoassociativeNetwork < HebbMarrNetwork 

    properties
        wiring
        currentInputX
        currentOutput
    end
    methods
        function obj = AutoassociativeNetwork(dimension)
            obj = obj@HebbMarrNetwork(dimension);
            obj.wiring = SequentialWiring(dimension); 
            obj.currentInputX = zeros(1,dimension); 
        end
        function fired = step(obj, inputX, inputY)
            if sum(inputX) == 0
                inputX = obj.currentInputX; 
            end
            fired = step@HebbMarrNetwork(obj, inputX, inputY); 
            obj.currentInputX = obj.wiring.connect(fired);
            obj.currentOutput = fired; 
        end        
        function retrieved = read(obj, inputX)
            retrieved = zeros(1,obj.nNeurons); 
            verifyInputs(obj,inputX,[]); 
            totalActivation = sum(inputX);
            product = inputX*obj.network;
            while ((totalActivation > 0) && (sum(retrieved) == 0))
                if totalActivation > 0
                    retrieved = fix(product/totalActivation); % round toward 0
                    disp(['totalActivation: ',num2str(totalActivation),' retrieved: ', ...
                        mat2str(find(retrieved >= 1))]);
                end
                totalActivation = totalActivation - 1; 
            end
            obj.currentOutput = retrieved; 
            
        end
        function inputX = getCurrentInputX(obj)
            inputX = obj.currentInputX; 
        end
        function shortOutput = outputIndices(obj)
            shortOutput = find(obj.currentOutput == 1); 
        end
    end
end