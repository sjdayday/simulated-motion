%% TestingCorticalProcess class:  test class for CorticalProcess
classdef TestingCorticalProcess < CorticalProcess 

    properties
    end
    methods
        function obj = TestingCorticalProcess(cortex, simulation,physical, ...
                reward, numberSimulations)
            obj = obj@CorticalProcess(cortex, simulation,physical, ... 
                reward, numberSimulations);
        end
        function execution = draw(obj)
            execution = obj.cortex.randomMotorExecution();  
        end         
    end
end
