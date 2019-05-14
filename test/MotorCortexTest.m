classdef MotorCortexTest < AbstractTest
    methods (Test)
        function testExpectedPlacesAreMarkedInMoveTurnPN(testCase)
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
            motorCortex.turnDistance = 2;
            motorCortex.clockwiseTurn();
            result = motorCortex.markedPlaceReport.toCharArray()'; 
            testCase.assertEqual(result, ...
               ['Move.Enabled: Default=1  ' newline,  ...
                'Move.Turn.Clockwise: Default=1  ' newline, ... 
                'Move.Turn.Distance: Default=2  ' newline, ...                 
                'Move.Turn.Speed: Default=1  ' newline, ...
                'Move.Turn: Default=1  ' newline]);
        end
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
            motorCortex.turnDistance = 10;
            motorCortex.counterClockwiseTurn();
%             pause(5); 
            testCase.assertClass(motorCortex.currentPlan, 'Turn');
            %  seems to be evaluating after 5 instead of 10.  
            testCase.assertEqual(motorCortex.currentPlan.distanceTurned, 10);
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            testCase.assertThat(animal.currentDirection, ...            
                 IsEqualTo(pi/3, 'Within', RelativeTolerance(.00001))); 

            motorCortex.turnDistance = 15;
            motorCortex.clockwiseTurn();
%             pause(5); 
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
            motorCortex.turnDistance = 10;
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 18); 
            motorCortex.counterClockwiseTurn();
%             pause(5); 
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 59); 
%  55 to 59 moving ccw
            motorCortex.turnDistance = 15;
            motorCortex.clockwiseTurn();
%             pause(5); 
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 45); 
%  59 to 45 moving cw
        end
        function testTurnAndRunUpdateHeadPositionAndArenaPosition(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
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
            motorCortex.turnDistance = 15;
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 18); 
            motorCortex.counterClockwiseTurn();
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 4);
            motorCortex.runSpeed = 1; 
            motorCortex.runDistance = 5; 
            motorCortex.run(); 
            testCase.assertThat(animal.x, ...            
                 IsEqualTo(1, 'Within', RelativeTolerance(.00001))); 
            testCase.assertThat(animal.y, ...            
                 IsEqualTo(1.5, 'Within', RelativeTolerance(.00001))); 
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 4); 
        end
% %         function testDrawRandomExecution(testCase)
% %             motorCortex = TestingMotorExecutions; 
% %             cortex = Cortex(motorCortex); 
% %             execution = cortex.randomMotorExecution(); 
% %             testCase.assertEqual(execution, [1;0;0;0;1;0;1;0]);             
% %         end
% 
    end
end
