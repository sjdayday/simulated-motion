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
        DG
        ECOutput
        DGOutput
        placeId
    end
    methods
        function obj = PlaceSystem(nMecOutput, nLecOutput)
            nCA3 = nMecOutput+nLecOutput; 
            obj = obj@AutoassociativeNetwork(nCA3);
            obj.nCA3 = nCA3;            
            obj.nDGInput = nCA3; 
            obj.nMEC = nMecOutput; 
            obj.nLEC = nLecOutput;  
            obj.DG = OrthogonalizingNetwork(obj.nDGInput,obj.nDGInput * 10);
            obj.DG.buildNetwork(); 
            obj.weightType = 'binary'; %weights are binary
            obj.buildNetwork();
        end
        function sparseOrthogonalizingNetwork(obj, sparse)
           obj.DG.sparse = sparse;  
        end
        function fired = step(obj, mecInput, lecInput)
            obj.ECOutput = [mecInput, lecInput]; 
            obj.DGOutput = obj.DG.step(obj.ECOutput);
            fired = step@AutoassociativeNetwork(obj, obj.ECOutput, obj.DGOutput); 
            obj.placeId = fired; 
%             fired = network.step(input);
%             if sum(inputX) == 0
%                 inputX = obj.currentInputX; 
%             end
%             fired = step@HebbMarrNetwork(obj, inputX, inputY); 
%             obj.currentInputX = obj.wiring.connect(fired);
        end        
%         function fired = step(obj, inputX, inputY)
%             if sum(inputX) == 0
%                 inputX = obj.currentInputX; 
%             end
%             fired = step@HebbMarrNetwork(obj, inputX, inputY); 
%             obj.currentInputX = obj.wiring.connect(fired);
%         end        
        function retrieved = read(obj, ECOutput)
            retrieved = read@AutoassociativeNetwork(obj, ECOutput); 
            obj.placeId = retrieved; 
        end
        function recognized = placeRecognized(obj, ECOutput) 
            if (obj.read(ECOutput) == zeros(1,obj.nNeurons))
                recognized = false;
            else
                recognized = true; 
            end
        end
    end
end