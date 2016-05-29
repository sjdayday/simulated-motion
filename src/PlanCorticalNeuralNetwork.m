%% PlanCorticalNeuralNetwork class:  neural network for plans
classdef PlanCorticalNeuralNetwork < CorticalNeuralNetwork 

    properties
        representationLength
    end
    methods
        function obj = PlanCorticalNeuralNetwork(hiddenLayer)
            obj = obj@CorticalNeuralNetwork('plan',hiddenLayer);
            obj.representationLength = 2; 
        end
        function [in,out] = parseExecution(obj,execution)
            representations = execution(1:obj.representationLength,:);
            outcome = execution(end-1:end,:);
            in = [representations;outcome];            
            out = execution(obj.representationLength+1:end-2,:);             
%             a = execution(1:2,:);
%             b = execution(7:8,:);            
%             in = [a;b];
%             out = execution(3:6,:); 
        end
    end
end
