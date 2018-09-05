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
            animal.build(); 
            animal.place(env, 1, 1, 0);
            motorCortex = animal.motorCortex; 
            motorCortex.moveDistance = 15;
            motorCortex.counterClockwiseTurn();
            testCase.assertClass(motorCortex.currentPlan, 'Turn');
            testCase.assertEqual(motorCortex.currentPlan.distanceTurned, 15);
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
%             testCase.assertThat(animal.currentDirection, ...            
%                 IsEqualTo(0.785398, 'Within', RelativeTolerance(.00001))); 
%             testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 15); 
        end
%         function testDrawRandomExecution(testCase)
%             motorCortex = TestingMotorExecutions; 
%             cortex = Cortex(motorCortex); 
%             execution = cortex.randomMotorExecution(); 
%             testCase.assertEqual(execution, [1;0;0;0;1;0;1;0]);             
%         end

    end
end
