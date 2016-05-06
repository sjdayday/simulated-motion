%% ExperimentController class:  controller for ExperimentView
% invokes classes as requested through the ExperimentView GUI 
classdef CorticalNeuralNetwork < handle 

    properties
        neuralNetworkFunctionName
        numberHiddenLayer
        input
        output
        currentExecution
        executions
    end
    methods
        function obj = CorticalNeuralNetwork(prefix, hiddenLayer)
            obj.neuralNetworkFunctionName = [prefix,'NeuralNetworkFunction'];
            obj.input = [];
            obj.output = [];
            obj.currentExecution = []; 
            obj.executions = []; 
            if hiddenLayer < 2
               obj.numberHiddenLayer = 4;
            else
                obj.numberHiddenLayer = hiddenLayer;
            end
%             buildHeadDirectionSystem(obj, obj.nHeadDirectionCells);
        end
        function len = inputLength(obj)
           len = arrayLength(obj,obj.input);  
        end
        function len = outputLength(obj)
           len = arrayLength(obj,obj.output);  
        end
        function len = arrayLength(~,targetArray)
            s = size(targetArray); 
            len = s(2); 
%             disp(len);
%             disp(s); 
        end
        function add(obj,in,out)
           obj.input = [obj.input,in]; 
           obj.output = [obj.output,out];
           obj.currentExecution = [in;out]; 
           obj.executions = [obj.executions,obj.currentExecution]; 
        end
     
    end
end
