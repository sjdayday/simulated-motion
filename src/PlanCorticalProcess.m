%% TestingCorticalProcess class:  test class for CorticalProcess
classdef PlanCorticalProcess < CorticalProcess 

    properties
        weightMap
        representationMap
        currentRepresentation
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
            plan = randsample([1 2 3 4], 1, true, weightedPlans);
            execution = obj.cortex.randomMotorExecution();  
            % executing the plan means draw for the plan + representation,
            % until we match, then 
            % see whether we get a reward or not 
        end         

%         function simulate(obj)
%             obj.simulationsRun = 0; 
%             obj.simulations = []; 
%             obj.predictions = []; 
%             for ii = 1:obj.numberSimulations
%                obj.simulation = obj.cortex.randomMotorExecution();  
%                obj.simulationsRun = obj.simulationsRun + 1;                
%                obj.simulations = [obj.simulations, obj.simulation];
%                [in,~] = obj.cortex.simulationNeuralNetwork.parseExecution(obj.simulation);
%                eval(['prediction = ',obj.neuralNetworkFunction,'(in);']); 
%                obj.predictions = [obj.predictions, prediction];
%                if predictedReward(obj, prediction) 
%                    break; 
%                end
%             end
%         end
        function rewarding = predictedReward(obj, prediction)
            rewarding = 0; 
            if prediction(1,1) > obj.tolerance
                rewarding = 1; 
            end
        end
         
    end
end
