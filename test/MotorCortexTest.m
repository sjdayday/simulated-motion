classdef MotorCortexTest < AbstractTest
    methods (Test)
% works...longer whisker detects walls better         
        function testLotsOfRandomBehaviors(testCase)  
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            animal = Animal();
            animal.build(); 
            animal.whiskerLength = 0.1;
            animal.place(env, 1, 1, 0);
            motorCortex = animal.motorCortex;
            motorCortex.maxBehaviorSteps = 5; 
            motorCortex.randomNavigation(200);
            disp(motorCortex.behaviorHistory); 
        end
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
            % TODO calibration?
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 58); %was 20
            motorCortex.counterClockwiseTurn();
%             pause(5); 
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 16); % was 43
%  55 to 59 moving ccw
            motorCortex.turnDistance = 15;
            motorCortex.clockwiseTurn();
%             pause(5); 
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 2); % was 29 
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
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 58); 
            motorCortex.counterClockwiseTurn();
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 21);
            motorCortex.runSpeed = 1; 
            motorCortex.runDistance = 5; 
            motorCortex.run(); 
            testCase.assertThat(animal.x, ...            
                 IsEqualTo(1, 'Within', RelativeTolerance(.00001))); 
            testCase.assertThat(animal.y, ...            
                 IsEqualTo(1.5, 'Within', RelativeTolerance(.00001))); 
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 21); 
        end
        function testWhiskerTouchGeneratesOppositeSideTurn(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            animal = Animal();
            animal.build(); 
            animal.place(env, 1, 0.005, 0);
            motorCortex = animal.motorCortex;
            motorCortex.randomNavigation(5);
            testCase.assertClass(motorCortex.currentPlan, 'Turn');
            testCase.assertEqual(motorCortex.clockwiseNess, motorCortex.counterClockwise);
            animal.place(env, 1, 1.995, 0);
            motorCortex = animal.motorCortex;
            motorCortex.randomNavigation(5);
            testCase.assertClass(motorCortex.currentPlan, 'Turn');
            testCase.assertEqual(motorCortex.clockwiseNess, motorCortex.clockwise);
        end
        function testBehaviorsRandomlyAlternateWithStepsDecrementing(testCase)
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
            motorCortex.maxBehaviorSteps = 3; 
            motorCortex.randomNavigation(20);
            disp(motorCortex.behaviorHistory); 
%      2     2     0
%      2     2     0
%      2     1     0
%      1     1     1
%      1     2     1
%      1     3     1
%      2     2     0
%      1     3     1
%      2     2     0
%      1     2    -1            
            testCase.assertEqual(motorCortex.behaviorHistory(1,:), [2 2 0], ...
                'run for 2');
            testCase.assertEqual(motorCortex.behaviorHistory(2,:), [2 2 0], ...
                'run for 2');
            testCase.assertEqual(motorCortex.behaviorHistory(3,:), [2 1 0], ...
                'run for 1');
            testCase.assertEqual(motorCortex.behaviorHistory(4,:), [1 1 1], ...
                'counter clockwise turn for 1');
            testCase.assertEqual(motorCortex.behaviorHistory(5,:), [1 2 1], ...
                'counter clockwise turn for 2');
            testCase.assertEqual(motorCortex.behaviorHistory(6,:), [1 3 1], ...
                'counter clockwise turn for 3');
            testCase.assertEqual(motorCortex.behaviorHistory(7,:), [2 2 0], ...
                'run for 2');
            testCase.assertEqual(motorCortex.behaviorHistory(8,:), [1 3 1], ...
                'counter clockwise turn for 3');
            testCase.assertEqual(motorCortex.behaviorHistory(9,:), [2 2 0], ...
                'run for 2');
            testCase.assertEqual(motorCortex.behaviorHistory(10,:), [1 2 -1], ...
                'clockwise turn for 2');
            testCase.assertEqual(motorCortex.remainingDistance, 0);            
        end
        function testTurnsAwayWhenWhiskersTouching(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            animal = Animal();
            animal.build(); 
            motorCortex = animal.motorCortex;
            animal.place(env, 1, 1, 0);
            testCase.assertFalse(motorCortex.turnAwayFromWhiskersTouching(5));            
            animal.place(env, 1, 0.005, 0);
            testCase.assertTrue(motorCortex.turnAwayFromWhiskersTouching(5));
            testCase.assertEqual(motorCortex.clockwiseNess, motorCortex.counterClockwise);
            testCase.assertEqual(motorCortex.turnDistance, 5);            
            testCase.assertClass(motorCortex.currentPlan, 'Turn');            
            animal.place(env, 1, 1.995, 0);
            testCase.assertTrue(motorCortex.turnAwayFromWhiskersTouching(4));
            testCase.assertEqual(motorCortex.clockwiseNess, motorCortex.clockwise);
            testCase.assertEqual(motorCortex.turnDistance, 4);            
            testCase.assertClass(motorCortex.currentPlan, 'Turn');            
        end
        function testRandomStepsDecrementsToZero(testCase)
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
            motorCortex.maxBehaviorSteps = 5; 
            motorCortex.remainingDistance = 25;
            testCase.assertEqual(motorCortex.randomSteps(), 4);
            testCase.assertEqual(motorCortex.remainingDistance, 21);
            testCase.assertEqual(motorCortex.randomSteps(), 4);
            testCase.assertEqual(motorCortex.remainingDistance, 17);
            testCase.assertEqual(motorCortex.randomSteps(), 4);
            testCase.assertEqual(motorCortex.remainingDistance, 13);
            testCase.assertEqual(motorCortex.randomSteps(), 5);
            testCase.assertEqual(motorCortex.remainingDistance, 8);
            testCase.assertEqual(motorCortex.randomSteps(), 2);
            testCase.assertEqual(motorCortex.remainingDistance, 6);
            testCase.assertEqual(motorCortex.randomSteps(), 4);
            testCase.assertEqual(motorCortex.remainingDistance, 2);
            testCase.assertEqual(motorCortex.randomSteps(), 1);
            testCase.assertEqual(motorCortex.remainingDistance, 1);
            testCase.assertEqual(motorCortex.randomSteps(), 1);
            testCase.assertEqual(motorCortex.remainingDistance, 0);
            testCase.assertEqual(motorCortex.randomSteps(), 0);
            testCase.assertEqual(motorCortex.remainingDistance, 0);
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
