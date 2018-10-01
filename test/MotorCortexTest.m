classdef MotorCortexTest < AbstractTest
    methods (Test)
        function testTurnUpdatesAnimalPositionAndSumsMultipleTurns(testCase)
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
            motorCortex.moveDistance = 10;
            motorCortex.counterClockwiseTurn();
            testCase.assertClass(motorCortex.currentPlan, 'Turn');
            testCase.assertEqual(motorCortex.currentPlan.distanceTurned, 10);
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            testCase.assertThat(animal.currentDirection, ...            
                 IsEqualTo(pi/3, 'Within', RelativeTolerance(.00001))); 

            motorCortex.moveDistance = 15;
            motorCortex.clockwiseTurn();
            testCase.assertClass(motorCortex.currentPlan, 'Turn');
            testCase.assertEqual(motorCortex.currentPlan.distanceTurned, 15);
            testCase.assertThat(animal.currentDirection, ...            
                 IsEqualTo(-pi/6, 'Within', RelativeTolerance(.00001))); 
        end
        function testTurnUpdatesHeadPositionAndSumsMultipleTurns(testCase)
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
            motorCortex.moveDistance = 10;
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 18); 
            motorCortex.counterClockwiseTurn();
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 59); 
%  55 to 59 moving ccw
            motorCortex.moveDistance = 15;
            motorCortex.clockwiseTurn();
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 45); 
%  59 to 45 moving cw
        end
%         function testDrawRandomExecution(testCase)
%             motorCortex = TestingMotorExecutions; 
%             cortex = Cortex(motorCortex); 
%             execution = cortex.randomMotorExecution(); 
%             testCase.assertEqual(execution, [1;0;0;0;1;0;1;0]);             
%         end

    end
end
