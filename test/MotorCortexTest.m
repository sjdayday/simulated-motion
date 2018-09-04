classdef MotorCortexTest < AbstractTest
    methods (Test)
        function testTurnUpdatesAnimalPositionAndHeadDirectionSystem(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            animal = Animal(); 
            animal.place(env, 1, 1);
%             motorCortex = TestingMotorExecutions; 
%             cortex = Cortex(motorCortex); 
%             testCase.assertClass(cortex.simulationNeuralNetwork, ...
%                 'SimulationCorticalNeuralNetwork'); 
%             testCase.assertClass(cortex.planNeuralNetwork, ...
%                 'PlanCorticalNeuralNetwork');            
%             testCase.assertEqual(length(cortex.motorCortex.testingExecutions), ...
%                 1600, 'number of test executions'); 
        end
%         function testDrawRandomExecution(testCase)
%             motorCortex = TestingMotorExecutions; 
%             cortex = Cortex(motorCortex); 
%             execution = cortex.randomMotorExecution(); 
%             testCase.assertEqual(execution, [1;0;0;0;1;0;1;0]);             
%         end

    end
end
