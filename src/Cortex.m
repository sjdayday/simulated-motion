%% Cortical class:  high-level model of some neocortical function
% Maintains two CorticalNeuralNetworks
% Retrieves motor plans
classdef Cortex < handle 

    properties
        simulationNeuralNetwork
        planNeuralNetwork
        motorCortex
    end
    methods
        function obj = Cortex(motor)
           obj.motorCortex = motor; 
           obj.simulationNeuralNetwork = SimulationCorticalNeuralNetwork(10); 
           obj.planNeuralNetwork = PlanCorticalNeuralNetwork(10); 
        end
        function execution = randomMotorExecution(obj)
           execution = obj.motorCortex.randomMotorExecution();  
        end
        function execution = randomDrawByPartialInput(obj, representation) 
           done = false; 
           len = length(representation); 
           while ~done
               execution = obj.motorCortex.randomMotorExecution();
               if execution(1:len,:) == representation
                   done = true; 
               end
           end
        end
        function loadNetworks(obj, numberExecutions)
           for ii = 1:numberExecutions
               execution = randomMotorExecution(obj); 
               obj.simulationNeuralNetwork.execute(execution); 
               obj.planNeuralNetwork.execute(execution);                
           end
           obj.simulationNeuralNetwork.rebuildNetwork(); 
           obj.planNeuralNetwork.rebuildNetwork(); 
        end
%         function len = inputLength(obj)
%            len = arrayLength(obj,obj.input);  
%         end
%         function len = outputLength(obj)
%            len = arrayLength(obj,obj.output);  
%         end
%         function len = arrayLength(~,targetArray)
%             s = size(targetArray); 
%             len = s(2); 
% %             disp(len);
% %             disp(s); 
%         end
%         function add(obj,in,out)
%            obj.input = [obj.input,in]; 
%            obj.output = [obj.output,out];
%            obj.currentExecution = [in;out]; 
%            obj.executions = [obj.executions,obj.currentExecution]; 
%         end
%         function resetSeed(~)
%            load '../rngDefaultSettings';
%            rng(rngDefault);                
%         end
%         function net = rebuildNetwork(obj)
%            resetSeed(obj); 
%            % adapted directly from nprtool simple script output
%            %   simIn - input data.
%            %   simTg - target data.
% 
%            x = obj.input;
%            t = obj.output;
%            % Choose a Training Function
%            trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.
%            % Create a Pattern Recognition Network
%            hiddenLayerSize = obj.numberHiddenLayer;
%            net = patternnet(hiddenLayerSize);
%            % Setup Division of Data for Training, Validation, Testing
%            net.divideParam.trainRatio = 80/100;
%            net.divideParam.valRatio = 10/100;
%            net.divideParam.testRatio = 10/100;
%            net.trainParam.showWindow=0;  % suppress nntraintool window
% 
%            % Train the Network
%            [net,~] = train(net,x,t);
%            % from the advanced script:
%            % Generate MATLAB function 
%            genFunction(net,obj.neuralNetworkFunctionName,'MatrixOnly','yes',...
%                'ShowLinks','no');
% 
%         end
    end
end
