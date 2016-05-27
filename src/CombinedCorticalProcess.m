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
        function process(obj)
            obj.planCorticalProcess.currentRepresentation = ...
                obj.currentRepresentation; 
            obj.simulationCorticalProcess.currentRepresentation =  ... 
                obj.currentRepresentation; 
            obj.planCorticalProcess.process(); 
            obj.simulationCorticalProcess.process(); 
%             simulate(obj);
%             execution = draw(obj); 
%             execute(obj, execution); 
%             updateResults(obj, execution); 
        end
            
    end
end
