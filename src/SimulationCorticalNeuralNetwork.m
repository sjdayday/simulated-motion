%% SimulationCorticalNeuralNetwork class:  neural network for plans
classdef SimulationCorticalNeuralNetwork < CorticalNeuralNetwork 

    properties
    end
    methods
        function obj = SimulationCorticalNeuralNetwork(hiddenLayer)
            obj = obj@CorticalNeuralNetwork('sim',hiddenLayer);
        end
        function [in,out] = parseExecution(~,execution)
            in = execution(1:6,:);
            out = execution(7:8,:); 
        end
    end
end
