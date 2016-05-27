%% CorticalProcess class:  base class for interaction of PlaceSystem with Cortex 
% subclasses:  RecallProcess, SimulationProcess, PlanProcess
classdef CombinedCorticalProcess < handle 

    properties
        simulationCost
        physicalCost
        rewardPayoff
        cortex
        numberSimulations
        simulationsRun
        results
        totalCost
        planCorticalProcess
        simulationCorticalProcess
        currentRepresentation
        simulationPredictionThreshold
        usePlanCorticalProcess
    end
    methods
        function obj = CombinedCorticalProcess(cortex)
            obj.cortex = cortex; 
            obj.simulationCost = 0; 
            obj.physicalCost = 0; 
            obj.rewardPayoff = 0;
            obj.numberSimulations = 0; 
            obj.simulationsRun = 0; 
            obj.results = [];
            obj.totalCost = 0; 
            obj.currentRepresentation = '';  
            obj.simulationPredictionThreshold = 0; 
            obj.usePlanCorticalProcess = 0; 
        end
        function build(obj)
            obj.planCorticalProcess = PlanCorticalProcess(obj.cortex, ... 
                obj.physicalCost,obj.rewardPayoff);     
            obj.simulationCorticalProcess = SimulationCorticalProcess( ... 
                obj.cortex,obj.simulationCost,obj.physicalCost, ... 
                obj.rewardPayoff,obj.numberSimulations); 
            obj.simulationCorticalProcess.predictionThreshold = ...
                obj.simulationPredictionThreshold; 
            if obj.usePlanCorticalProcess
                obj.simulationCorticalProcess.usePlanCorticalProcess = ... 
                    obj.usePlanCorticalProcess;
                obj.simulationCorticalProcess.planCorticalProcess = ...
                    obj.planCorticalProcess; 
            end
        end
        function execution = process(obj)
            simulate(obj);
            execution = draw(obj); 
            execute(obj, execution); 
            updateResults(obj, execution); 
        end
        function simulate(~)
           %override if needed  
        end
        function execute(~, ~)
           % must be overridden by subclasses  
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
%             disp([obj.neuralNetworkFunction(:,1:3),' cost: ',num2str(cost), ...
%                 ' representation: ', obj.currentRepresentation(:,12:end), ...
%                 ' execution: ',num2str(execution')]);
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
            
    end
end
