%% TestingCorticalProcess class:  test class for CorticalProcess
classdef SimulationCorticalProcess < CorticalProcess 

    properties
        simulations
        predictions
        predictionThreshold
        simulation
        representationMap
        currentRepresentation
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
            buildRepresentationMap(obj);
            obj.currentRepresentation = '';             
        end
        function buildRepresentationMap(obj)
            obj.representationMap = containers.Map();
            obj.representationMap('FoundRewardAway') = [1;0]; 
            obj.representationMap('FoundRewardHome') = [0;1];             
        end
        
        function simulate(obj)
            obj.simulationsRun = 0; 
            obj.simulations = []; 
            obj.predictions = []; 
            input = obj.representationMap(obj.currentRepresentation);  
            for ii = 1:obj.numberSimulations
               obj.simulation = obj.cortex.randomDrawByPartialInput(input);
%                disp(obj.simulation); 
%                obj.simulation = obj.cortex.randomMotorExecution();  
               obj.simulationsRun = obj.simulationsRun + 1;                
               obj.simulations = [obj.simulations, obj.simulation];
               [in,~] = obj.cortex.simulationNeuralNetwork.parseExecution(obj.simulation);
               eval(['prediction = ',obj.neuralNetworkFunction,'(in);']); 
               obj.predictions = [obj.predictions, prediction];
               if predictedReward(obj, prediction) 
                   break; 
               end
            end
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
