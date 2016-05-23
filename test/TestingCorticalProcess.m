%% TestingCorticalProcess class:  test class for CorticalProcess
classdef TestingCorticalProcess < CorticalProcess 

    properties
        forcedExecution
        force
    end
    methods
        function obj = TestingCorticalProcess(cortex, simulation,physical, ...
                reward, numberSimulations)
            obj = obj@CorticalProcess(cortex, simulation,physical, ... 
                reward, numberSimulations);
            obj.neuralNetworkFunction = 'testFunction'; 
            obj.force = false; 
            obj.forcedExecution = zeros(8,1); 
        end
        function execution = draw(obj)
            if obj.force
                execution = obj.forcedExecution; 
            else
                execution = obj.cortex.randomMotorExecution();                  
            end

        end         
    end
end
