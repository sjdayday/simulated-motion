%% Cortical class:  high-level model of some neocortical function
% Maintains two CorticalNeuralNetworks
% Retrieves motor plans
classdef Cortex < handle 

    properties
        simulationNeuralNetwork
        simulationNetworkRebuildCount
        planNeuralNetwork
        planNetworkRebuildCount
        motorCortex
    end
    methods
        function obj = Cortex(motor)
           obj.motorCortex = motor; 
           obj.simulationNeuralNetwork = SimulationCorticalNeuralNetwork(10); 
           obj.planNeuralNetwork = PlanCorticalNeuralNetwork(10); 
           obj.simulationNetworkRebuildCount = 0; 
           obj.planNetworkRebuildCount = 0;            
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
        function simulationExecuteAndRebuild(obj, execution)
            obj.simulationNeuralNetwork.execute(execution); 
            simulationRebuild(obj);
        end
        function simulationRebuild(obj)
            obj.simulationNeuralNetwork.rebuildNetwork(); 
            obj.simulationNetworkRebuildCount = obj.simulationNetworkRebuildCount + 1;             
        end
        function planExecuteAndRebuild(obj, execution)
            obj.planNeuralNetwork.execute(execution); 
            planRebuild(obj);
        end
        function planRebuild(obj)
            obj.planNeuralNetwork.rebuildNetwork(); 
            obj.planNetworkRebuildCount = obj.planNetworkRebuildCount + 1;             
        end
        function loadNetworks(obj, numberExecutions)
           for ii = 1:numberExecutions
               execution = randomMotorExecution(obj); 
               obj.simulationNeuralNetwork.execute(execution); 
               obj.planNeuralNetwork.execute(execution);                
           end
           simulationRebuild(obj);
           planRebuild(obj);
        end
    end
end
