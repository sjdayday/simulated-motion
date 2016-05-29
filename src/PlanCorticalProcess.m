%% PlanCorticalProcess class:  chooses execution based on weights of motor plans 
% contrast to SimulationCorticalProcess
classdef PlanCorticalProcess < CorticalProcess 

    properties
        weightMap
        representationMap
        motorPlan
    end
    methods
        function obj = PlanCorticalProcess(cortex,physical, reward)
            obj = obj@CorticalProcess(cortex, 0 ,physical, reward, 0);
            obj.neuralNetworkFunction = ... 
                obj.cortex.planNeuralNetwork.neuralNetworkFunctionName; 
            buildMaps(obj); 
        end
        function buildMaps(obj)
            buildDefaultWeightMap(obj);
            buildDefaultRepresentationMap(obj);
        end
        function buildDefaultRepresentationMap(obj)
            obj.representationMap = containers.Map();
            obj.representationMap('FoundRewardAway') = [1;0;1;0]; 
            obj.representationMap('FoundRewardHome') = [0;1;1;0];             
        end
        function addRepresentationEntry(obj, representationKey, representationVector)
            entries = length(representationVector); 
            defaultEntry = 1/entries; 
            obj.representationMap(representationKey) = representationVector; 
            obj.weightMap(representationKey) = repmat(defaultEntry,1,entries); 
        end

        function buildDefaultWeightMap(obj)
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
%             disp([obj.neuralNetworkFunction(:,1:3),' plan weightedPlans: ', ...
%                 num2str(weightedPlans)]);
            plans = zeros(4,1); 
            plans(obj.motorPlan) = 1; 
            partialInput = [input(1:2,:);plans];
            execution = obj.cortex.randomDrawByPartialInput(partialInput);  
        end         
        function execute(obj, execution)
%             obj.cortex.planExecuteAndRebuild(execution); 
            obj.cortex.executeAndRebuildAll(execution); 
        end
         
    end
end
