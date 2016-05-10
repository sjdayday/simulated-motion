%% TestingCorticalProcess class:  test class for CorticalProcess
classdef PlanCorticalProcess < CorticalProcess 

    properties
        weightMap
        representationMap
        currentRepresentation
        motorPlan
    end
    methods
        function obj = PlanCorticalProcess(cortex,physical, reward)
            obj = obj@CorticalProcess(cortex, 0 ,physical, reward, 0);
            obj.neuralNetworkFunction = ... 
                obj.cortex.planNeuralNetwork.neuralNetworkFunctionName; 
            buildMaps(obj); 
            obj.currentRepresentation = ''; 
        end
        function buildMaps(obj)
            buildWeightMap(obj);
            buildRepresentationMap(obj);
        end
        function buildRepresentationMap(obj)
            obj.representationMap = containers.Map();
            obj.representationMap('FoundRewardAway') = [1;0;1;0]; 
            obj.representationMap('FoundRewardHome') = [0;1;1;0];             
        end
        function buildWeightMap(obj)
            obj.weightMap = containers.Map();
            obj.weightMap('FoundRewardAway') = [0.25,0.25,0.25,0.25]; 
            obj.weightMap('FoundRewardHome') = [0.25,0.25,0.25,0.25];             
        end
        function weights = planWeights(obj, representation)
            weights = obj.weightMap(representation); 
        end
        function execution = draw(obj)
            input = obj.representationMap(obj.currentRepresentation); 
            eval(['predictedPlans = ',obj.neuralNetworkFunction,'(input);']);
            weightedPlans = predictedPlans'; 
            obj.weightMap(obj.currentRepresentation) = weightedPlans; 
            obj.motorPlan = randsample([1 2 3 4], 1, true, weightedPlans);
            plans = zeros(4,1); 
            plans(obj.motorPlan) = 1; 
            partialInput = [input(1:2,:);plans];
            execution = obj.cortex.randomDrawByPartialInput(partialInput);  
        end         
        function execute(obj, execution)
            obj.cortex.planExecuteAndRebuild(execution); 
        end
         
    end
end
