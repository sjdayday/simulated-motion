%% CorticalProcess class:  base class for interaction of PlaceSystem with Cortex 
% subclasses:  RecallProcess, SimulationProcess, PlanProcess
classdef CorticalProcess < handle 

    properties
        simulationCost
        physicalCost
        rewardPayoff
        cortex
        numberSimulations
        simulationsRun
        results
        totalCost
    end
    methods
        function obj = CorticalProcess(cortex, simulation,physical,reward,numberSimulations)
            obj.cortex = cortex; 
            obj.simulationCost = simulation; 
            obj.physicalCost = physical; 
            obj.rewardPayoff = reward;
            obj.numberSimulations = numberSimulations; 
            obj.simulationsRun = 0; 
            obj.results = [];
            obj.totalCost = 0; 
        end
        function execution = process(obj)
            execution = draw(obj); 
            updateResults(obj, execution); 
        end
        function execution = draw(~)
            execution = zeros(8,1); 
           % must be overridden by subclasses 
        end
        function updateResults(obj, execution)
            cost = calculateReward(obj, execution) - ...
                (obj.simulationCost*obj.simulationsRun) - obj.physicalCost;
            obj.totalCost = obj.totalCost + cost; 
            obj.results = [obj.results,obj.totalCost]; 
        end
        function reward = calculateReward(obj, execution)
           if execution(7,1) == 1
               reward = obj.rewardPayoff;
           else
               reward = 0; 
           end
        end
        function result = currentResult(obj)
           result = obj.results(end);  
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
