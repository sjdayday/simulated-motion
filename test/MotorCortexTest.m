classdef MotorCortexTest < AbstractTest
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
            animal.pullVelocityFromAnimal = false; 
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
            animal.pullVelocityFromAnimal = false; 
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
            animal = Animal();
            animal.build(); 
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
            animal = Animal();
            animal.build(); 
            motorCortex = animal.motorCortex;
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
        function testCalculatesPhysicalTurnStepsToOrientToPrimaryCue(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            env.addCue([2 1]);  % cue (at 0 from position)
            
            animal = Animal();
            animal.build(); 
            animal.place(env, 1, 1, pi/2);
                       
            motorCortex = animal.motorCortex;
            testCase.assertEqual(animal.currentDirection, pi/2);            
            testCase.assertEqual(motorCortex.cuePhysicalHeadDirectionOffset(), 45);                        
        end
        function testPlaceInvokesOrientButPlaceNotRecognized(testCase)
             env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.directionIntervals = 30;            
            env.build();
            env.addCue([2 1]);  % cue (at 0 from position)
            env.addCue([0 0]);            
            animal = Animal();
            animal.nHeadDirectionCells = 30;
            animal.nCueIntervals = 30;
            animal.gridSize=[6,5]; 
%             animal.includeHeadDirectionFeatureInput = false;
            animal.pullVelocityFromAnimal = false;
            animal.pullFeaturesFromAnimal = false;  % had missed this
            animal.defaultFeatureDetectors = false; 
            animal.updateFeatureDetectors = true; 
            animal.settleToPlace = false;
            animal.placeMatchThreshold = 0; % was 2  
            animal.showHippocampalFormationECIndices = true; 
            animal.sparseOrthogonalizingNetwork = true; 
            animal.separateMecLec = true; 
            animal.twoCuesOnly = true;
            animal.hdsPullsFeatureWeightsFromLec = true;
            animal.keepRunnerForReporting = true;             
            animal.minimumVelocity = pi/15;
            animal.build();
            animal.setChildTimekeeper(animal);             
            animal.hippocampalFormation.headDirectionSystem.minimumVelocity = pi/15;
            animal.hippocampalFormation.headDirectionSystem.animalVelocityCalibration = 2.7; 
            testCase.assertFalse(animal.orientOnPlace);            
            animal.orientOnPlace = true; 
%             animal.orientAnimal(pi);
%             animal.hippocampalFormation.orienting = true;             
            
            animal.build(); 
            motorCortex = animal.motorCortex;            
            animal.place(env, 1, 1, pi); 
            testCase.assertEqual(motorCortex.behaviorHistory(1,:), [3 0 0], ...
                'orienting');                        
            testCase.assertEqual(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.assertEqual(animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
                25); 
            testCase.assertEqual(animal.hippocampalFormation.grids(2).getMaxActivationIndex(), ... 
                29); 
            testCase.assertEqual(animal.hippocampalFormation.grids(3).getMaxActivationIndex(), ... 
                16); 
            testCase.assertEqual(animal.hippocampalFormation.grids(4).getMaxActivationIndex(), ... 
                28);             
            testCase.assertFalse(motorCortex.placeRecognized); 
            testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
                find([2 2] == 1), 'place not found (dunno how else to create 1 0 size matrix)'); 
            animal.step();
            testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163]); 
            
%             testCase.assertEqual(animal.currentDirection, pi/2);            
%             testCase.assertEqual(motorCortex.cuePhysicalHeadDirectionOffset(), 45);                        
        end
        function testOrientTurnsAnimalAndRetrievesPreviousPlaceId(testCase)
             env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.directionIntervals = 30;            
            env.build();
            env.addCue([2 1]);  % cue (at 0 from position)
            env.addCue([0 0]);            
            animal = Animal();
            animal.nHeadDirectionCells = 30;
            animal.nCueIntervals = 30;
            animal.gridSize=[6,5]; 
%             animal.includeHeadDirectionFeatureInput = false;
            animal.pullVelocityFromAnimal = false;
            animal.pullFeaturesFromAnimal = false;  % had missed this
            animal.defaultFeatureDetectors = false; 
            animal.updateFeatureDetectors = true; 
            animal.settleToPlace = false;
            animal.placeMatchThreshold = 0; % was 2  
            animal.showHippocampalFormationECIndices = true; 
            animal.sparseOrthogonalizingNetwork = true; 
            animal.separateMecLec = true; 
            animal.twoCuesOnly = true;
            animal.hdsPullsFeatureWeightsFromLec = true;
            animal.keepRunnerForReporting = true;             
            animal.minimumVelocity = pi/15;
            testCase.assertFalse(animal.orientOnPlace);            
            animal.orientOnPlace = true; 
            animal.build();
            animal.setChildTimekeeper(animal);             
            %TODO:  make these behave like normal parameters 
            animal.hippocampalFormation.headDirectionSystem.minimumVelocity = pi/15;
            animal.hippocampalFormation.headDirectionSystem.animalVelocityCalibration = 2.7; 
%             animal.orientAnimal(pi);
%             animal.hippocampalFormation.orienting = true;             
            
            motorCortex = animal.motorCortex;            
            animal.place(env, 1, 1, pi); 
            testCase.assertEqual(motorCortex.behaviorHistory(1,:), [3 0 0], ...
                'orienting');                        
            testCase.assertEqual(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.assertEqual(animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
                25); 
            testCase.assertEqual(animal.hippocampalFormation.grids(2).getMaxActivationIndex(), ... 
                29); 
            testCase.assertEqual(animal.hippocampalFormation.grids(3).getMaxActivationIndex(), ... 
                16); 
            testCase.assertEqual(animal.hippocampalFormation.grids(4).getMaxActivationIndex(), ... 
                28);             
            testCase.assertFalse(motorCortex.placeRecognized); 
            testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
                find([2 2] == 1), 'place not found (dunno how else to create 1 0 size matrix)'); 
            animal.step();
            testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163]);
            animal.hippocampalFormation.headDirectionSystem.initializeActivation(true);
            animal.hippocampalFormation.grids(1).initializeActivation();
            animal.hippocampalFormation.grids(2).initializeActivation();
            animal.hippocampalFormation.grids(3).initializeActivation();
            animal.hippocampalFormation.grids(4).initializeActivation();            
%             motorCortex.orient(); 
            motorCortex.startOrienting(true);

            testCase.assertEqual(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                23, 'new stable head direction');
            testCase.assertEqual(animal.hippocampalFormation.grids(1).getMaxActivationIndex(), 16); 
            testCase.assertEqual(animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 17); 
            testCase.assertEqual(animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 8); 
            testCase.assertEqual(animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 13);             
            testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163], 'read returns old place, based on LEC input matching previous place]'); 
            testCase.assertEqual(motorCortex.cuePhysicalHeadDirectionOffset(), 15);                        
            motorCortex.finishOrienting();
            
            testCase.assertEqual(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
               2, 'when features were noted, physically at 15 (pi), hds at 17'); 
            testCase.assertEqual(animal.hippocampalFormation.grids(1).getMaxActivationIndex(), 25); 
            testCase.assertEqual(animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 29); 
            testCase.assertEqual(animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 16); 
            testCase.assertEqual(animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 28);             
            testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163], 'place no longer reading, should return same as previous'); 
            testCase.assertEqual(motorCortex.behaviorHistory(2,:), [3 0 0], ...
                'orienting again');                                    
            testCase.assertEqual(motorCortex.behaviorHistory(3,:), [1 15 1], ...
                'counter clockwise turn for 15');
            
        end
        
        function testMovesAwayWhenWhiskersTouchWhileOrienting(testCase)
             env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.directionIntervals = 30;            
            env.build();
            env.addCue([2 1]);  % cue (at 0 from position)
            env.addCue([0 0]);            
            animal = Animal();
            animal.nHeadDirectionCells = 30;
            animal.nCueIntervals = 30;
            animal.gridSize=[6,5]; 
%             animal.includeHeadDirectionFeatureInput = false;
            animal.pullVelocityFromAnimal = false;
            animal.pullFeaturesFromAnimal = false;  % had missed this
            animal.defaultFeatureDetectors = false; 
            animal.updateFeatureDetectors = true; 
            animal.settleToPlace = false;
            animal.placeMatchThreshold = 0; % was 2  
            animal.showHippocampalFormationECIndices = true; 
            animal.sparseOrthogonalizingNetwork = true; 
            animal.separateMecLec = true; 
            animal.twoCuesOnly = true;
            animal.hdsPullsFeatureWeightsFromLec = true;
            animal.keepRunnerForReporting = true;             
            animal.minimumVelocity = pi/15;
            testCase.assertFalse(animal.orientOnPlace);            
            animal.orientOnPlace = true; 
            animal.build();
            animal.setChildTimekeeper(animal);             
            %TODO:  make these behave like normal parameters 
            animal.hippocampalFormation.headDirectionSystem.minimumVelocity = pi/15;
            animal.hippocampalFormation.headDirectionSystem.animalVelocityCalibration = 2.7; 
%             animal.orientAnimal(pi);
%             animal.hippocampalFormation.orienting = true;             
            
            motorCortex = animal.motorCortex;            
            animal.place(env, 1.995, 1, 3*pi/2); 
            testCase.assertEqual(motorCortex.behaviorHistory(1,:), [3 0 0], ...
                'orienting');                        
            testCase.assertEqual(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.assertEqual(animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
                25); 
            testCase.assertEqual(animal.hippocampalFormation.grids(2).getMaxActivationIndex(), ... 
                29); 
            testCase.assertEqual(animal.hippocampalFormation.grids(3).getMaxActivationIndex(), ... 
                16); 
            testCase.assertEqual(animal.hippocampalFormation.grids(4).getMaxActivationIndex(), ... 
                28);             
            testCase.assertFalse(motorCortex.placeRecognized); 
            testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
                find([2 2] == 1), 'place not found (dunno how else to create 1 0 size matrix)'); 
            animal.step();
            testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
                [27 88]);
            animal.hippocampalFormation.headDirectionSystem.initializeActivation(true);
            animal.hippocampalFormation.grids(1).initializeActivation();
            animal.hippocampalFormation.grids(2).initializeActivation();
            animal.hippocampalFormation.grids(3).initializeActivation();
            animal.hippocampalFormation.grids(4).initializeActivation();            
%             motorCortex.orient(); 
            motorCortex.startOrienting(true);

            testCase.assertEqual(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                23, 'new stable head direction');
            testCase.assertEqual(animal.hippocampalFormation.grids(1).getMaxActivationIndex(), 16); 
            testCase.assertEqual(animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 17); 
            testCase.assertEqual(animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 8); 
            testCase.assertEqual(animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 13);             
            testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
                [27 88], 'read returns old place, based on LEC input matching previous place]'); 
            testCase.assertEqual(motorCortex.cuePhysicalHeadDirectionOffset(), 7);                        
            motorCortex.finishOrienting();
            
            testCase.assertEqual(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
               21, 'turned away...'); 
            testCase.assertEqual(animal.hippocampalFormation.grids(1).getMaxActivationIndex(), ...
               27, '...then moved away'); 
            testCase.assertEqual(animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 13); 
            testCase.assertEqual(animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 12); 
            testCase.assertEqual(animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 13);             
            testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
                find([2 2] == 1), 'still orienting, so place not created'); 
%             testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
%                 [88 163], 'place no longer reading, should return same as previous'); 
%             testCase.assertEqual(motorCortex.behaviorHistory(2,:), [3 0 0], ...
%                 'orienting again');                                    
%             testCase.assertEqual(motorCortex.behaviorHistory(3,:), [1 15 1], ...
%                 'counter clockwise turn for 15');
         end
    end
end
