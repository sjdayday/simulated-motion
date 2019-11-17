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
            
           % place
            % orient
            % following orient, we should see a place created, not before
%             testCase.assertEqual(animal.currentDirection, pi/2);            
%             testCase.assertEqual(motorCortex.cuePhysicalHeadDirectionOffset(), 45);                        
        end
        function testOrientTurnsAnimalAndRetrievesPreviousPlaceId(testCase)
        end
        function testOrientTriesShortRunsToRecognizePlace(testCase)
            % perhaps LEC processing is done before orient turn is made, to
            % see if we retrieve something?  
        end
        
%         function testBothHdsAndGridsRecallPositionDirectionAfterOrienting(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             import matlab.unittest.constraints.AbsoluteTolerance                                    
%             animal.place(environment, 1, 1, pi); 
%             animal.orientAnimal(pi);
%             animal.hippocampalFormation.orienting = true;             
% %             animal.hippocampalFormation.settle();   
% % do the equivalent of settling, so we avoid activating a spurious place
% % index (205), until our activation has stabilized
%             
%             for ii = 1:3
%                 animal.step();            
%                 disp(['HDS: ', num2str(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex()) ]); 
% %                 plotGrids();
%             end
%             animal.hippocampalFormation.orienting = false;   
%             disp('first orientation'); 
%             animal.step();    
%             disp('step after first orientation'); 
%             testCase.assertEqual(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
%                 17, 'stable; now present features'); 
%             testCase.assertEqual(animal.hippocampalFormation.nGrids, 4); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(1).getMaxActivationIndex(), 25); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 29); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 16); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 28);             
%             
%             testCase.assertEqual(animal.hippocampalFormation.headDirectionSystem.featuresDetected, ...
%                 animal.hippocampalFormation.lecSystem.featuresDetected, 'both set by placeSystem'); 
% % %             testCase.assertEqual(system.lecSystem.getCueMaxActivationIndex(), 40);
% % 
%             testCase.assertEqual(animal.hippocampalFormation.lecSystem.getCueMaxActivationIndex(), 1);
%             testCase.assertEqual(animal.hippocampalFormation.lecSystem.cueActivation(1,1:6), ...
%                 animal.hippocampalFormation.headDirectionSystem.uActivation(1,17:22), ...
%                 'head direction activation copied and shifted to canonical view'); 
%             testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
%                 [88 163]); 
%             animal.hippocampalFormation.orienting = true; 
%             animal.hippocampalFormation.headDirectionSystem.initializeActivation(true);
%             animal.hippocampalFormation.grids(1).initializeActivation();
%             animal.hippocampalFormation.grids(2).initializeActivation();
%             animal.hippocampalFormation.grids(3).initializeActivation();
%             animal.hippocampalFormation.grids(4).initializeActivation();            
%             for ii = 1:4
%                 animal.step();            
%                 disp(['HDS: ', num2str(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex()) ]); 
%                 disp(['Grid 1: ', num2str(animal.hippocampalFormation.grids(1).getMaxActivationIndex()) ]);                 
%                 disp(['Grid 2: ', num2str(animal.hippocampalFormation.grids(2).getMaxActivationIndex()) ]);                 
%                 disp(['Grid 3: ', num2str(animal.hippocampalFormation.grids(3).getMaxActivationIndex()) ]);                 
%                 disp(['Grid 4: ', num2str(animal.hippocampalFormation.grids(4).getMaxActivationIndex()) ]);                                 
% %                 plotGrids();
%             end
%             testCase.assertEqual(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
%                 23, 'new stable head direction');
%             testCase.assertEqual(animal.hippocampalFormation.grids(1).getMaxActivationIndex(), 16); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 17); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 8); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 13);             
% %             testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
% %                 [65 163], 'one index (LEC) matches previous [88 163]'); 
% %             testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
% %                 [88 163 205], 'read returns old place (at least), based on LEC input matching previous place]'); 
%             testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
%                 [88 163], 'read returns old place, based on LEC input matching previous place]'); 
%             
% %             testCase.assertEqual(system.placeOutputIndices(), [92 230]); 
%             relativeSpeed = 1;
%             clockwiseNess = -1 ;  %clockwise 
%             
%             animal.turn(clockwiseNess, relativeSpeed); 
%             testCase.assertThat(animal.currentDirection, ...
%                IsEqualTo(pi*14/15, 'Within', RelativeTolerance(.00000001)));         
%             for ii = 1:14
%                 animal.turn(clockwiseNess, relativeSpeed); 
%                 disp(['HDS: ', num2str(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex()) ]); 
% %                 plotGrids();
%             end
% 
%             testCase.assertThat(animal.currentDirection, ...
%                IsEqualTo(0, 'Within', AbsoluteTolerance(.00001)));         
%             testCase.assertEqual(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
%                 8, 'turned 15 from 23'); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(1).getMaxActivationIndex(), 16, ...
%                 'turn only, so unchanged'); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 17); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 8); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 13);             
% %             testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), [65 163]); % 88  163 ?              
% %             testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
% %                 [88 163 205], 'read returns old place (at least), based on LEC input matching previous place]'); 
%             testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
%                 [88 163], 'read returns old place, based on LEC input matching previous place]'); 
%             animal.hippocampalFormation.settle();             
% %             animal.hippocampalFormation.setReadMode(1); 
% %             disp('read mode on'); 
% %             for ii = 1:7
% %                 animal.step();            
% %                 disp(['HDS: ', num2str(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex()) ]); 
% %                 disp(['Grid 1: ', num2str(animal.hippocampalFormation.grids(1).getMaxActivationIndex()) ]);                 
% %                 disp(['Grid 2: ', num2str(animal.hippocampalFormation.grids(2).getMaxActivationIndex()) ]);                 
% %                 disp(['Grid 3: ', num2str(animal.hippocampalFormation.grids(3).getMaxActivationIndex()) ]);                 
% %                 disp(['Grid 4: ', num2str(animal.hippocampalFormation.grids(4).getMaxActivationIndex()) ]);                                 
% % %                 plotGrids();
% %             end
%             animal.hippocampalFormation.orienting = false;
% %             animal.hippocampalFormation.setReadMode(0); 
%             testCase.assertEqual(animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
%                2, 'when features were noted, physically at 15 (pi), hds at 17'); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(1).getMaxActivationIndex(), 25); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 29); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 16); 
%             testCase.assertEqual(animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 28);             
% %             testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
% %                 [88 163 205], 'place no longer reading, should return same as previous'); 
%             testCase.assertEqual(animal.hippocampalFormation.placeOutputIndices(), ...
%                 [88 163], 'place no longer reading, should return same as previous'); 
% 
%         end          
    end
end
