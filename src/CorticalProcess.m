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
        neuralNetworkFunction
        currentRepresentation
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
            obj.currentRepresentation = '';                         
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
