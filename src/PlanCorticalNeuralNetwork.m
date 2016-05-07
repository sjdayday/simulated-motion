%% PlanCorticalNeuralNetwork class:  neural network for plans
classdef PlanCorticalNeuralNetwork < CorticalNeuralNetwork 

    properties
    end
    methods
        function obj = PlanCorticalNeuralNetwork(hiddenLayer)
            obj = obj@CorticalNeuralNetwork('plan',hiddenLayer);
        end
        function [in,out] = parseExecution(~,execution)
            a = execution(1:2,:);
            b = execution(7:8,:);            
            in = [a;b];
            out = execution(3:6,:); 
        end
    end
end
