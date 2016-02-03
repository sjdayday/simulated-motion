% PlaceSystem class:  extends AutoassociativeNetwork
% models the functions of the hippocampus:  Dentate Gyrus and CA3
classdef PlaceSystem < AutoassociativeNetwork 

    properties
%         wiring
%         currentInputX
        nCA3
        nMEC
        nLEC
        nDGInput
    end
    methods
        function obj = PlaceSystem(nMecOutput, nLecOutput)
            nCA3 = nMecOutput+nLecOutput; 
            obj = obj@AutoassociativeNetwork(nCA3);
            obj.nCA3 = nCA3;            
            obj.nDGInput = nCA3; 
            obj.nMEC = nMecOutput; 
            obj.nLEC = nLecOutput;  


%             obj.wiring = SequentialWiring(dimension); 
%             obj.currentInputX = zeros(1,dimension); 
%             outputMecLength = 50; 
%             outputLecLength = 50; 
%             placeSystem = PlaceSystem(outputMecLength, outputLecLength); 
%             testCase.assertEqual(placeSystem.nMEC, 50); 
%             testCase.assertEqual(placeSystem.nLEC, 50); 
%             testCase.assertEqual(placeSystem.nDGInput, 100); 
%             testCase.assertEqual(placeSystem.nCA3, 100);             

        end
        function fired = step(obj, inputX, inputY)
            if sum(inputX) == 0
                inputX = obj.currentInputX; 
            end
            fired = step@HebbMarrNetwork(obj, inputX, inputY); 
            obj.currentInputX = obj.wiring.connect(fired);
        end        
        function retrieved = read(obj, inputX)
            retrieved = zeros(1,obj.nNeurons); 
            verifyInputs(obj,inputX,[]); 
            totalActivation = sum(inputX);
            product = inputX*obj.network;
            while ((totalActivation > 0) && (sum(retrieved) == 0))
                if totalActivation > 0
                    retrieved = fix(product/totalActivation); 
                end
                totalActivation = totalActivation - 1; 
            end
        end
        function inputX = getCurrentInputX(obj)
            inputX = obj.currentInputX; 
        end
    end
end