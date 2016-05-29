%% SimulationCorticalNeuralNetwork class:  neural network for plans
classdef SimulationCorticalNeuralNetwork < CorticalNeuralNetwork 

    properties
    end
    methods
        function obj = SimulationCorticalNeuralNetwork(hiddenLayer)
            obj = obj@CorticalNeuralNetwork('sim',hiddenLayer);
        end
        function [in,out] = parseExecution(~,execution)
            inEnd = length(execution)-2;
            in = execution(1:inEnd,:);
            out = execution(inEnd+1:end,:);             
        end
    end
end
