classdef MotorCortexTest < AbstractTest
    properties
        environment
        animal
        placeMatchThreshold
    end

    methods (Test)
% works...longer whisker detects walls better         
%         function testLotsOfRandomBehaviors(testCase)  
%             env = Environment();
%             env.addWall([0 0],[0 2]); 
%             env.addWall([0 2],[2 2]); 
%             env.addWall([0 0],[2 0]); 
%             env.addWall([2 0],[2 2]);
%             env.build();
%             animal = Animal();
%             animal.build(); 
%             animal.whiskerLength = 0.1;
%             animal.place(env, 1, 1, 0);
%             motorCortex = animal.motorCortex;
%             motorCortex.maxBehaviorSteps = 5; 
%             motorCortex.randomNavigation(200);
%             disp(motorCortex.behaviorHistory); 
%         end

% placeReport may require
% ...behaviorStatus.readyAcknowledgeBuildsPlaceReport  = true
        function testExpectedPlacesAreMarkedInMoveTurnPN(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            testCase.animal = Animal(); 
            testCase.animal.build(); 
            testCase.animal.place(env, 1, 1, 0);
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.keepRunnerForReporting = true; 
            motorCortex.readyAcknowledgeBuildsPlaceReport = true; 
            motorCortex.turnDistance = 2;
            motorCortex.clockwiseTurn();
            result = motorCortex.markedPlaceReport.toCharArray()'; 
            testCase.assertEqual(result, ...
               ['Move.Enabled: Default=1  ' newline,  ...
                'Move.Turn.Clockwise: Default=1  ' newline, ... 
                'Move.Turn.Distance: Default=2  ' newline, ...                 
                'Move.Turn.Speed: Default=1  ' newline, ...
                'Move.TurnMotion: Default=1  ' newline]);
        end
% %         function testExpectedPlacesAreMarkedInNavigatePN(testCase)
% %             env = Environment();
% %             env.addWall([0 0],[0 2]); 
% %             env.addWall([0 2],[2 2]); 
% %             env.addWall([0 0],[2 0]); 
% %             env.addWall([2 0],[2 2]);
% %             env.build();
% %             testCase.animal = Animal(); 
% %             testCase.animal.build(); 
% %             testCase.animal.place(env, 1, 1, 0);
% %             motorCortex = testCase.animal.motorCortex; 
% %             motorCortex.keepRunnerForReporting = true;             
% %             motorCortex.prepareNavigate(); 
% %             motorCortex.navigation.firingLimit = 2; 
% %             motorCortex.navigate(10); 
% %             result = motorCortex.markedPlaceReport.toCharArray()'; 
% %             testCase.assertEqual(result, ...
% %                ['Navigate.Enabled: Default=1  ' newline,  ...
% %                 'Navigate.Energy: Default=10  ' newline]);
% %         end
        function testExpectedPlacesAreMarkedAfterNavigateZeroSteps(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            testCase.animal = Animal(); 
            testCase.animal.build(); 
            testCase.animal.place(env, 1, 1, 0);
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.firingLimit = 3;  
            motorCortex.keepRunnerForReporting = true; 
            motorCortex.readyAcknowledgeBuildsPlaceReport = true;             
            motorCortex.stopOnReadyForTesting = true; 
            motorCortex.prepareNavigate(); 
            motorCortex.navigate(0); 
%             result = motorCortex.markedPlaceReport.toCharArray()'; 
            result = motorCortex.navigation.runner.getPlaceReport().toCharArray()'; 
            testCase.assertEqual(result, ...
               ['Navigate.Energy: Default=9  ' newline,  ...
                'Navigate.Move.Run: Default=1  ' newline,  ...
                'Navigate.Ready: Default=1  ' newline,  ...
                'Navigate.Resources: Default=1  ' newline,  ...                
                'Navigate.Tired: Default=1  ' newline]);
        end
        function testTurnUpdatesAnimalPositionAndSumsMultipleTurns(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            testCase.animal = Animal(); 
            testCase.animal.build(); 
            testCase.animal.place(env, 1, 1, 0);
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.turnDistance = 10;
            motorCortex.counterClockwiseTurn();
%             pause(5); 
            testCase.assertClass(motorCortex.currentPlan, 'Move');
            testCase.assertTrue(motorCortex.currentPlan.turn);
            %  seems to be evaluating after 5 instead of 10.  
            testCase.assertEqual(motorCortex.currentPlan.distanceMoved, 10);
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            testCase.assertThat(testCase.animal.currentDirection, ...            
                 IsEqualTo(pi/3, 'Within', RelativeTolerance(.00001))); 

            motorCortex.turnDistance = 15;
            motorCortex.clockwiseTurn();
%             pause(5); 
            testCase.assertClass(motorCortex.currentPlan, 'Move');
            testCase.assertTrue(motorCortex.currentPlan.turn);
            testCase.assertEqual(motorCortex.currentPlan.distanceMoved, 15);
            testCase.assertThat(testCase.animal.currentDirection, ...            
                 IsEqualTo(-pi/6, 'Within', RelativeTolerance(.00001))); 
        end
        function testTurnUpdatesHeadPositionAndSumsMultipleTurns(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            testCase.animal = Animal();
            testCase.animal.pullVelocityFromAnimal = false; 
            testCase.animal.build(); 
            testCase.animal.place(env, 1, 1, 0);
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.turnDistance = 10;
            % TODO calibration?
            testCase.assertEqual(testCase.animal.headDirectionSystem.getMaxActivationIndex(), 58); %was 20
            motorCortex.counterClockwiseTurn();
%             pause(5); 
            testCase.assertEqual(testCase.animal.headDirectionSystem.getMaxActivationIndex(), 16); % was 43
%  55 to 59 moving ccw
            motorCortex.turnDistance = 15;
            motorCortex.clockwiseTurn();
%             pause(5); 
            testCase.assertEqual(testCase.animal.headDirectionSystem.getMaxActivationIndex(), 2); % was 29 
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
            testCase.animal = Animal();
            testCase.animal.pullVelocityFromAnimal = false; 
            testCase.animal.build(); 
            testCase.animal.place(env, 1, 1, 0);
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.turnDistance = 15;
            testCase.assertEqual(testCase.animal.headDirectionSystem.getMaxActivationIndex(), 58); 
            motorCortex.counterClockwiseTurn();
            testCase.assertEqual(testCase.animal.headDirectionSystem.getMaxActivationIndex(), 21);
            motorCortex.runSpeed = 1; 
            motorCortex.runDistance = 5; 
            motorCortex.run(); 
            testCase.assertThat(testCase.animal.x, ...            
                 IsEqualTo(1, 'Within', RelativeTolerance(.00001))); 
            testCase.assertThat(testCase.animal.y, ...            
                 IsEqualTo(1.5, 'Within', RelativeTolerance(.00001))); 
            testCase.assertEqual(testCase.animal.headDirectionSystem.getMaxActivationIndex(), 21); 
        end
        function testWhiskerTouchGeneratesOppositeSideTurn(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            testCase.animal = Animal();
            testCase.animal.build(); 
            testCase.animal.place(env, 1, 0.005, 0);
            motorCortex = testCase.animal.motorCortex;
            motorCortex.randomNavigation(5);
            testCase.assertClass(motorCortex.currentPlan, 'Move');
            testCase.assertEqual(motorCortex.clockwiseness, motorCortex.counterClockwise);
            testCase.animal = Animal();
            testCase.animal.build(); 
            testCase.animal.place(env, 1, 1.995, 0);
            motorCortex = testCase.animal.motorCortex;
            motorCortex.randomNavigation(5);
            testCase.assertClass(motorCortex.currentPlan, 'Move');
            testCase.assertEqual(motorCortex.clockwiseness, motorCortex.clockwise);
        end
        function testBehaviorsRandomlyAlternateWithStepsDecrementing(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            testCase.animal = Animal();
            testCase.animal.build(); 
            testCase.animal.place(env, 1, 1, 0);
            motorCortex = testCase.animal.motorCortex;
            motorCortex.maxBehaviorSteps = 3; 
            motorCortex.randomNavigation(20);
            disp(motorCortex.behaviorHistory); 
%      2     2     0 
%      1     3     1 
%      2     1     0 
%      2     2     0 
%      2     2     0 
%      2     3     0  
%      1     2     1 
%      1     2     1 
%      1     1     1 
%      1     1     1
%      1     1     1

            testCase.assertEqual(motorCortex.behaviorHistory(1,:), [2 2 0], ...
                'run for 2');
            testCase.assertEqual(motorCortex.behaviorHistory(2,:), [1 3 1], ...
                'counter clockwise turn for 3');
            testCase.assertEqual(motorCortex.behaviorHistory(3,:), [2 1 0], ...
                'run for 1');
            testCase.assertEqual(motorCortex.behaviorHistory(4,:), [2 2 0], ...
                'run for 2');
            testCase.assertEqual(motorCortex.behaviorHistory(5,:), [2 2 0], ...
                'run for 2');
            testCase.assertEqual(motorCortex.behaviorHistory(6,:), [2 3 0], ...
                'run for 3');
            testCase.assertEqual(motorCortex.behaviorHistory(7,:), [1 2 1], ...
                'counter clockwise turn for 2');
            testCase.assertEqual(motorCortex.behaviorHistory(8,:), [1 2 1], ...
                'counter clockwise turn for 2');
            testCase.assertEqual(motorCortex.behaviorHistory(9,:), [1 1 1], ...
                'counter clockwise turn for 1');
            testCase.assertEqual(motorCortex.behaviorHistory(10,:), [1 1 1], ...
                'counter clockwise turn for 1');
            testCase.assertEqual(motorCortex.behaviorHistory(11,:), [1 1 1], ...
                'counter clockwise turn for 1');
            testCase.assertEqual(motorCortex.remainingDistance, 0);            
        end
        function testTurnsAwayWhenWhiskersTouching(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            testCase.animal = Animal();
            testCase.animal.build(); 
            motorCortex = testCase.animal.motorCortex;
            testCase.animal.place(env, 1, 1, 0);
            testCase.assertFalse(motorCortex.turnAwayFromWhiskersTouching(5));            
            testCase.animal.place(env, 1, 0.005, 0);
            testCase.assertTrue(motorCortex.turnAwayFromWhiskersTouching(5));
            testCase.assertEqual(motorCortex.clockwiseness, motorCortex.counterClockwise);
            testCase.assertEqual(motorCortex.turnDistance, 5);            
            testCase.assertClass(motorCortex.currentPlan, 'Move');            
            testCase.animal = Animal();
            testCase.animal.build(); 
            motorCortex = testCase.animal.motorCortex;
            testCase.animal.place(env, 1, 1.995, 0);
            testCase.assertTrue(motorCortex.turnAwayFromWhiskersTouching(4));
            testCase.assertEqual(motorCortex.clockwiseness, motorCortex.clockwise);
            testCase.assertEqual(motorCortex.turnDistance, 4);            
            testCase.assertClass(motorCortex.currentPlan, 'Move');            
        end
        function testRandomStepsDecrementsToZero(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            testCase.animal = Animal();
            testCase.animal.build(); 
            testCase.animal.place(env, 1, 1, 0);
            motorCortex = testCase.animal.motorCortex;
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
        function testCalculatesPhysicalTurnStepsToOrientToPrimaryCue(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            env.addCue([2 1]);  % cue (at 0 from position)
            
            testCase.animal = Animal();
            testCase.animal.build(); 
            testCase.animal.place(env, 1, 1, pi/2);
                       
            motorCortex = testCase.animal.motorCortex;
            testCase.assertEqual(testCase.animal.currentDirection, pi/2);            
            testCase.assertEqual(motorCortex.cuePhysicalHeadDirectionOffset(), 45);                        
        end
        function testPlaceInvokesOrientButPlaceNotRecognized(testCase)
            testCase.placeMatchThreshold = 0;  
            testCase.buildAnimal(); 
            motorCortex = testCase.animal.motorCortex;            
            testCase.animal.place(testCase.environment, 1, 1, pi); 
            testCase.assertEqual(motorCortex.behaviorHistory(1,:), [3 0 0], ...
                'orienting');                        
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
                25); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), ... 
                29); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), ... 
                16); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), ... 
                28);             
            testCase.assertFalse(motorCortex.placeRecognized); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                find([2 2] == 1), 'place not found (dunno how else to create 1 0 size matrix)'); 
            testCase.animal.step();
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163]); 
            
%             testCase.assertEqual(animal.currentDirection, pi/2);            
%             testCase.assertEqual(motorCortex.cuePhysicalHeadDirectionOffset(), 45);                        
        end
        function testOrientTurnsAnimalAndRetrievesPreviousPlaceId(testCase)
            testCase.placeMatchThreshold = 0;  
            testCase.buildAnimal(); 
            motorCortex = testCase.animal.motorCortex;            
            testCase.animal.place(testCase.environment, 1, 1, pi); 
            testCase.assertEqual(motorCortex.behaviorHistory(1,:), [3 0 0], ...
                'orienting');                        
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
                25); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), ... 
                29); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), ... 
                16); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), ... 
                28);             
            testCase.assertFalse(motorCortex.placeRecognized); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                find([2 2] == 1), 'place not found (dunno how else to create 1 0 size matrix)'); 
            testCase.animal.step();
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163]);
            testCase.animal.hippocampalFormation.headDirectionSystem.initializeActivation(true);
            testCase.animal.hippocampalFormation.grids(1).initializeActivation();
            testCase.animal.hippocampalFormation.grids(2).initializeActivation();
            testCase.animal.hippocampalFormation.grids(3).initializeActivation();
            testCase.animal.hippocampalFormation.grids(4).initializeActivation();            
%             motorCortex.orient(); 
            motorCortex.startOrienting(true);

            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                23, 'new stable head direction');
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), 16); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 17); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 8); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 13);             
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163], 'read returns old place, based on LEC input matching previous place]'); 
            testCase.assertEqual(motorCortex.cuePhysicalHeadDirectionOffset(), 15);                        
            motorCortex.finishOrienting();
            
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
               2, 'when features were noted, physically at 15 (pi), hds at 17'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), 25); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 29); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 16); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 28);             
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163], 'place no longer reading, should return same as previous'); 
            testCase.assertEqual(motorCortex.behaviorHistory(2,:), [3 0 0], ...
                'orienting again');                                    
            testCase.assertEqual(motorCortex.behaviorHistory(3,:), [1 15 1], ...
                'counter clockwise turn for 15');
            
        end
        function testSimulatedMotionRunNoPhysicalMotionReturnsToCurrentPlace(testCase)
            testCase.placeMatchThreshold = 0;  
            testCase.buildAnimal();             
            motorCortex = testCase.animal.motorCortex;            
            testCase.animal.place(testCase.environment, 1, 1, pi); 
%             testCase.assertEqual(motorCortex.behaviorHistory(1,:), [3 0 0], ...
%                 'orienting');                        
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
                25); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), ... 
                29); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), ... 
                16); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), ... 
                28);             
%             testCase.assertFalse(motorCortex.placeRecognized); 
%             testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
%                 find([2 2] == 1), 'place not found (dunno how else to create 1 0 size matrix)'); 
            testCase.animal.step();
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163]);
            lastPlace = testCase.animal.hippocampalFormation.placeOutput; 
            testCase.assertEqual(find(lastPlace == 1), [88 163]);
            
            motorCortex.runDistance = 3; 
            motorCortex.setSimulatedMotion(true); 
            motorCortex.run(); 
            testCase.assertEqual(motorCortex.physicalPlace, lastPlace);
            testCase.assertEqual(testCase.animal.x , 1);            
            testCase.assertEqual(testCase.animal.y , 1);            
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                188,'LEC zeros, so only single digit place');
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
                14); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), ... 
                21); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), ... 
                15); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), ... 
                10);             
            motorCortex.setSimulatedMotion(false); 
            motorCortex.settlePhysical(); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
                25); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), ... 
                29); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), ... 
                16); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), ... 
                28);             
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163]);
        end
        function testRunToSamePlaceAfterSimulatedRunUpdatesPlaceId(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance 
            testCase.placeMatchThreshold = 1;  
            testCase.buildAnimal();             
            motorCortex = testCase.animal.motorCortex;            
            testCase.animal.place(testCase.environment, 1, 1, pi); 
%             testCase.assertEqual(motorCortex.behaviorHistory(1,:), [3 0 0], ...
%                 'orienting');                        
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
                25); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), ... 
                29); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), ... 
                16); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), ... 
                28);             
%             testCase.assertFalse(motorCortex.placeRecognized); 
%             testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
%                 find([2 2] == 1), 'place not found (dunno how else to create 1 0 size matrix)'); 
            testCase.animal.step();
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163]);
            lastPlace = testCase.animal.hippocampalFormation.placeOutput; 
            testCase.assertEqual(find(lastPlace == 1), [88 163]);
            
            motorCortex.runDistance = 3; 
            motorCortex.setSimulatedMotion(true); 
            motorCortex.run(); 
            testCase.assertEqual(motorCortex.physicalPlace, lastPlace);
            testCase.assertEqual(testCase.animal.x , 1);            
            testCase.assertEqual(testCase.animal.y , 1);            
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                188,'LEC zeros, so only single digit place');
            testCase.assertFalse(testCase.animal.hippocampalFormation.placeRecognized);            
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
                14); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), ... 
                21); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), ... 
                15); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), ... 
                10);             
            motorCortex.setSimulatedMotion(false); 
            motorCortex.settlePhysical(); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
                25); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), ... 
                29); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), ... 
                16); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), ... 
                28);             
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163]);
            motorCortex.runDistance = 3; 
            motorCortex.run(); 
%             testCase.assertEqual(motorCortex.physicalPlace, lastPlace);
            testCase.assertThat(testCase.animal.x, ...            
                 IsEqualTo(0.7, 'Within', RelativeTolerance(.00001))); 
%             testCase.assertEqual(testCase.animal.x , 0.7);            
            testCase.assertEqual(testCase.animal.y , 1);   
            testCase.assertTrue(testCase.animal.hippocampalFormation.placeRecognized);            
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [96 188],'MEC output same, updated with LEC');
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
                14); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), ... 
                21); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), ... 
                15); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), ... 
                10);             

        end
        function testSimulatedTurnIsSortOfReversedAtSettleThenPhysicallyRetraced(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance 
            testCase.placeMatchThreshold = 1;  
            testCase.buildAnimal();             
            motorCortex = testCase.animal.motorCortex;            
            testCase.animal.place(testCase.environment, 1, 1, pi); 
%             testCase.assertEqual(motorCortex.behaviorHistory(1,:), [3 0 0], ...
%                 'orienting');                        
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.animal.step();
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163]);
            v = testCase.animal.vertices; 
            testCase.assertEqual(v(1,:), [1 .95]);                         
            testCase.assertEqual(v(2,:), [1 1.05]);                         
            testCase.assertEqual(v(3,:), [0.8 1]);                         
            
            lastPlace = testCase.animal.hippocampalFormation.placeOutput; 
            testCase.assertEqual(find(lastPlace == 1), [88 163]);
            

            motorCortex.setSimulatedMotion(true); 
            motorCortex.turnDistance = 4;             
            motorCortex.clockwiseTurn();             
%             motorCortex.counterClockwiseTurn(); 
            testCase.assertEqual(motorCortex.physicalPlace, lastPlace);
            v = testCase.animal.vertices; 
            testCase.assertEqual(v(1,:), [1 .95]);                         
            testCase.assertEqual(v(2,:), [1 1.05]);                         
            testCase.assertEqual(v(3,:), [0.8 1]);                         
% %             testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
%                 [88 163]);
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                14, 'should be 13 if steps 1 for 1'); 
%             testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
%                 20, 'should be 13 if steps 1 for 1'); 
%             testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
%                 14); 
%             testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), ... 
%                 21); 
%             testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), ... 
%                 15); 
%             testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), ... 
%                 10);             
            motorCortex.setSimulatedMotion(false); 
            motorCortex.settlePhysical(); 
%             testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
%                 19, 'return to former head direction; should be back to 17'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                19, 'return to former head direction; should be back to 17'); 
            motorCortex.setSimulatedMotion(true); 
            motorCortex.turnDistance = 4;             
            motorCortex.counterClockwiseTurn();             
%             motorCortex.clockwiseTurn();  
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                23, 'should be 13 if steps 1 for 1'); 
            motorCortex.setSimulatedMotion(false); 
            motorCortex.settlePhysical(); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                19, 'return to former head direction; should be back to 17');             
%  physical turn
            motorCortex.turnDistance = 4;             
            motorCortex.clockwiseTurn();             
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                14, 'return to former head direction; should be back to 17');             
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163]);

            
        end
        
        function testMovesAwayWhenWhiskersTouchWhileOrienting(testCase)
            testCase.placeMatchThreshold = 0;  
            testCase.buildAnimal();                         
            motorCortex = testCase.animal.motorCortex;            
            testCase.animal.place(testCase.environment, 1.995, 1, 3*pi/2); 
            testCase.assertEqual(motorCortex.behaviorHistory(1,:), [3 0 0], ...
                'orienting');                        
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
                25); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), ... 
                29); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), ... 
                16); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), ... 
                28);             
            testCase.assertFalse(motorCortex.placeRecognized); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                find([2 2] == 1), 'place not found (dunno how else to create 1 0 size matrix)'); 
            testCase.animal.step();
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [27 88]);
            testCase.animal.hippocampalFormation.headDirectionSystem.initializeActivation(true);
            testCase.animal.hippocampalFormation.grids(1).initializeActivation();
            testCase.animal.hippocampalFormation.grids(2).initializeActivation();
            testCase.animal.hippocampalFormation.grids(3).initializeActivation();
            testCase.animal.hippocampalFormation.grids(4).initializeActivation();            
%             motorCortex.orient(); 
            motorCortex.startOrienting(true);

            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                23, 'new stable head direction');
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), 16); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 17); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 8); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 13);             
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [27 88], 'read returns old place, based on LEC input matching previous place]'); 
            testCase.assertEqual(motorCortex.cuePhysicalHeadDirectionOffset(), 7);                        
            motorCortex.finishOrienting();
            
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
               21, 'turned away...'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
               27, '...then moved away'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 13); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 12); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 13);             
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                find([2 2] == 1), 'still orienting, so place not created'); 
%             testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
%                 [88 163], 'place no longer reading, should return same as previous'); 
%             testCase.assertEqual(motorCortex.behaviorHistory(2,:), [3 0 0], ...
%                 'orienting again');                                    
%             testCase.assertEqual(motorCortex.behaviorHistory(3,:), [1 15 1], ...
%                 'counter clockwise turn for 15');
        end
        function buildAnimal(testCase)
            testCase.environment = Environment();
            testCase.environment.addWall([0 0],[0 2]); 
            testCase.environment.addWall([0 2],[2 2]); 
            testCase.environment.addWall([0 0],[2 0]); 
            testCase.environment.addWall([2 0],[2 2]);
            testCase.environment.directionIntervals = 30;            
            testCase.environment.build();
            testCase.environment.addCue([2 1]);  % cue (at 0 from position)
            testCase.environment.addCue([0 0]);            
            testCase.animal = Animal();
            testCase.animal.nHeadDirectionCells = 30;
            testCase.animal.nCueIntervals = 30;
            testCase.animal.gridSize=[6,5]; 
%             animal.includeHeadDirectionFeatureInput = false;
            testCase.animal.pullVelocityFromAnimal = false;
            testCase.animal.pullFeaturesFromAnimal = false;  % had missed this
            testCase.animal.defaultFeatureDetectors = false; 
            testCase.animal.updateFeatureDetectors = true; 
            testCase.animal.settleToPlace = false;
            testCase.animal.placeMatchThreshold = testCase.placeMatchThreshold; % was 2  
            testCase.animal.showHippocampalFormationECIndices = true; 
            testCase.animal.sparseOrthogonalizingNetwork = true; 
            testCase.animal.separateMecLec = true; 
            testCase.animal.twoCuesOnly = true;
            testCase.animal.hdsPullsFeatureWeightsFromLec = true;
            testCase.animal.keepRunnerForReporting = true;             
            testCase.animal.minimumVelocity = pi/15;
            testCase.animal.hdsMinimumVelocity = pi/15;
            testCase.animal.hdsAnimalVelocityCalibration = 2.7;             
            testCase.animal.build();
            testCase.animal.setChildTimekeeper(testCase.animal);             
            testCase.animal.hippocampalFormation.headDirectionSystem.minimumVelocity = pi/15;
            testCase.animal.hippocampalFormation.headDirectionSystem.animalVelocityCalibration = 2.7; 
            testCase.assertFalse(testCase.animal.orientOnPlace);            
            testCase.animal.orientOnPlace = true;             
            testCase.animal.build(); 
            testCase.animal.setChildTimekeeper(testCase.animal);    
 
        end
    end
end
