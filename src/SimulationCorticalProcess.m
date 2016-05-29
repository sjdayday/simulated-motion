%% TestingCorticalProcess class:  test class for CorticalProcess
classdef SimulationCorticalProcess < CorticalProcess 

    properties
        simulations
        predictions
        predictionThreshold
        simulation
        representationMap
        planCorticalProcess
        usePlanCorticalProcess
    end
    methods
        function obj = SimulationCorticalProcess(cortex, simulation,physical, ...
                reward, numberSimulations)
            obj = obj@CorticalProcess(cortex, simulation,physical, ... 
                reward, numberSimulations);
            obj.simulations = []; 
            obj.predictions = []; 
            obj.predictionThreshold = 0.9; 
            obj.neuralNetworkFunction = obj.cortex.simulationNeuralNetwork.neuralNetworkFunctionName; 
            buildDefaultRepresentationMap(obj);
            obj.usePlanCorticalProcess = 0; 
        end
        function buildDefaultRepresentationMap(obj)
            obj.representationMap = containers.Map();
            obj.representationMap('FoundRewardAway') = [1;0]; 
            obj.representationMap('FoundRewardHome') = [0;1];             
        end
        function addRepresentationEntry(obj, representationKey, representationVector)
            obj.representationMap(representationKey) = representationVector; 
        end
        function simulate(obj)
            obj.simulationsRun = 0; 
            obj.simulations = []; 
            obj.predictions = []; 
            input = obj.representationMap(obj.currentRepresentation);  
            for ii = 1:obj.numberSimulations
                if obj.usePlanCorticalProcess
                    obj.simulation = obj.planCorticalProcess.draw();  % pCP assumes representation set to same as this
%                     disp([obj.neuralNetworkFunction(:,1:3), ...
%                         ' simulation just drew from planCorticalProcess: ', ...
%                         num2str(obj.simulation')]);
                else
                    obj.simulation = obj.cortex.randomDrawByPartialInput(input);
                end
                obj.simulationsRun = obj.simulationsRun + 1;                
                obj.simulations = [obj.simulations, obj.simulation];
                [in,~] = obj.cortex.simulationNeuralNetwork.parseExecution(obj.simulation);
                prediction = predict(obj, in); 
                if predictedReward(obj, prediction) 
                    break; 
                end
            end
        end
        function prediction = predict(obj, in)
                eval(['prediction = ',obj.neuralNetworkFunction,'(in);']); 
%                 disp(['sim prediction: ',num2str(prediction')]);
                obj.predictions = [obj.predictions, prediction];            
        end
        function execute(obj, execution)
%             obj.cortex.simulationExecuteAndRebuild(execution); 
            obj.cortex.executeAndRebuildAll(execution); 
        end
        function rewarding = predictedReward(obj, prediction)
            rewarding = 0; 
            if prediction(1,1) > obj.predictionThreshold
                rewarding = 1; 
            end
        end
        function execution = draw(obj)
            execution = obj.simulation; 
        end         
    end
end
