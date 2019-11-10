classdef AnimalTest < AbstractTest
    properties
        environment
        animal
    end
    methods (Test)
        function testAnimalKnowsItsEnvironment(testCase)
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();
            testCase.animal.place(testCase.environment, 0.5, 0.25, 0);  
            testCase.assertEqual(testCase.animal.closestWallDistance(), 0.25);                         
        end
        function testBuildsDefaultGridChartNetworks(testCase)
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();            
            testCase.assertEqual(testCase.animal.hippocampalFormation.nGrids, 4);                         
        end
        function testAnimalCalculatesVerticesAtOriginDirectionZeroAtBuild(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();
            v = testCase.animal.vertices; 
            testCase.assertEqual(v(1,:), [0 0.05]);                         
            testCase.assertEqual(v(2,:), [0 -0.05]);                         
            testCase.assertEqual(v(3,:), [0.2 0.0]);                         
        end
        function testAnimalCantTurnIfNotPlaced(testCase)
            testCase.animal = Animal(); 
            testCase.animal.build(); 
            try 
                testCase.animal.turn(1, 1); 
                testCase.assertFail('should throw'); 
            catch  ME
                testCase.assertEqual(ME.identifier, 'Animal:NotPlaced'); 
                testCase.assertEqual(ME.message, 'animal must be placed before it can move (turn or run):  place(...)'); 
            end
        end
        function testAnimalCantRunIfNotPlaced(testCase)
            testCase.animal = Animal(); 
            testCase.animal.build(); 
            try 
                testCase.animal.run(1); 
                testCase.assertFail('should throw'); 
            catch  ME
                testCase.assertEqual(ME.identifier, 'Animal:NotPlaced'); 
                testCase.assertEqual(ME.message, 'animal must be placed before it can move (turn or run):  place(...)'); 
            end
        end
        % turns accumulate 
        function testAnimalVerticesReflectCumulativeTurns(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();            
            testCase.animal.place(testCase.environment, 1, 1, 0);              
            v = testCase.animal.vertices; 
            testCase.assertEqual(v(1,:), [1 1.05]);                          
            testCase.assertEqual(v(2,:), [1 0.95]);                         
            testCase.assertEqual(v(3,:), [1.2 1.0]);  
            testCase.animal.turn(1, 15); % turn CCW to pi/2 
            v = testCase.animal.vertices; 
            testCase.assertThat(v(1,1), ...
               IsEqualTo(0.95, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(1,2), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(2,1), ...
               IsEqualTo(1.05, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(2,2), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(3,1), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(3,2), ...
               IsEqualTo(1.2, 'Within', RelativeTolerance(.0001)));         
            testCase.animal.turn(1, 15); % turn CCW to pi
            v = testCase.animal.vertices; 

            
            testCase.assertThat(v(1,1), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(1,2), ...
               IsEqualTo(0.95, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(2,1), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(2,2), ...
               IsEqualTo(1.05, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(3,1), ...
               IsEqualTo(0.8, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(3,2), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
            testCase.animal.turn(-1, 15); % turn back CW to pi/2
            v = testCase.animal.vertices; 
            testCase.assertThat(v(1,1), ...
               IsEqualTo(0.95, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(1,2), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(2,1), ...
               IsEqualTo(1.05, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(2,2), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(3,1), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(3,2), ...
               IsEqualTo(1.2, 'Within', RelativeTolerance(.0001)));         
        end
        function testAnimalCalculatesItsVertices(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();            
            testCase.animal.place(testCase.environment, 1, 1, 0);              
            v = testCase.animal.vertices; 
            testCase.assertEqual(v(1,:), [1 1.05]);                          
            testCase.assertEqual(v(2,:), [1 0.95]);                         
            testCase.assertEqual(v(3,:), [1.2 1.0]);                         
          testCase.animal.place(testCase.environment, 1, 1, pi/2);              
            v = testCase.animal.vertices; 
            testCase.assertThat(v(1,1), ...
               IsEqualTo(0.95, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(1,2), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(2,1), ...
               IsEqualTo(1.05, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(2,2), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(3,1), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(3,2), ...
               IsEqualTo(1.2, 'Within', RelativeTolerance(.0001)));         
               testCase.animal.place(testCase.environment, 1, 1, 0);   % reset vertices           
              testCase.animal.place(testCase.environment, 1, 1, pi);              
            v = testCase.animal.vertices; 
            testCase.assertThat(v(1,1), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(1,2), ...
               IsEqualTo(0.95, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(2,1), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(2,2), ...
               IsEqualTo(1.05, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(3,1), ...
               IsEqualTo(0.8, 'Within', RelativeTolerance(.0001)));         
            testCase.assertThat(v(3,2), ...
               IsEqualTo(1.0, 'Within', RelativeTolerance(.0001)));         
        end  
        function testAnimalDetectsWhiskerTouchingWall(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();            
            testCase.animal.whiskerLength = 0.01;
            testCase.animal.motorCortex.run(); 
            testCase.animal.place(testCase.environment, 1, 1, pi/4);              
            testCase.assertFalse(testCase.animal.rightWhiskerTouching);
            testCase.assertFalse(testCase.animal.leftWhiskerTouching);
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();                        
            testCase.animal.place(testCase.environment, 1, 0.005, 0);              
            testCase.assertTrue(testCase.animal.rightWhiskerTouching);
            testCase.assertFalse(testCase.animal.leftWhiskerTouching);
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();                        
            testCase.animal.place(testCase.environment, 1, 1.995, 0);              
            testCase.assertFalse(testCase.animal.rightWhiskerTouching);
            testCase.assertTrue(testCase.animal.leftWhiskerTouching);
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();                        
            testCase.animal.place(testCase.environment, 0.1414, 0.1414, 5*pi/4);              
            testCase.assertFalse(testCase.animal.rightWhiskerTouching, ... 
            'should be true, but some small error so right not exactly equal left');
            testCase.assertTrue(testCase.animal.leftWhiskerTouching);
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();                        
            testCase.animal.place(testCase.environment, 1, 0, 0);              
            testCase.assertTrue(testCase.animal.rightWhiskerTouching, ... 
            'both on x axis' );
            testCase.assertTrue(testCase.animal.leftWhiskerTouching);
            
        end
        function testBothHdsAndGridsRecallPositionDirectionAfterOrienting(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance                                    
            
%             system.nFeatures = 3;
            buildAnimalInEnvironment(testCase);
            testCase.animal.nHeadDirectionCells = 30;
            testCase.animal.nCueIntervals = 30;
            testCase.animal.gridSize=[6,5]; 
%             testCase.animal.includeHeadDirectionFeatureInput = false;
            testCase.animal.pullVelocityFromAnimal = false;
            testCase.animal.pullFeaturesFromAnimal = false;  % had missed this
            testCase.animal.defaultFeatureDetectors = false; 
            testCase.animal.updateFeatureDetectors = true; 
            testCase.animal.settleToPlace = false;
            testCase.animal.placeMatchThreshold = 0; % was 2  
            testCase.animal.showHippocampalFormationECIndices = true; 
            testCase.animal.sparseOrthogonalizingNetwork = true; 
            testCase.animal.separateMecLec = true; 
            testCase.animal.twoCuesOnly = true;
            testCase.animal.hdsPullsFeatureWeightsFromLec = true;
            testCase.animal.keepRunnerForReporting = true;             
            testCase.animal.minimumVelocity = pi/15;
            testCase.animal.build();
            testCase.animal.setChildTimekeeper(testCase.animal);             
            testCase.animal.hippocampalFormation.headDirectionSystem.minimumVelocity = pi/15;
            testCase.animal.hippocampalFormation.headDirectionSystem.animalVelocityCalibration = 2.7; 
            testCase.environment.addCue([2 1]);  %  x   ------------- cue (at 0)
            testCase.environment.addCue([0 0]);
            testCase.environment.directionIntervals = 30;
            testCase.animal.place(testCase.environment, 1, 1, pi); 
            testCase.animal.orientAnimal(pi);
            testCase.animal.hippocampalFormation.orienting = true;             
%             testCase.animal.hippocampalFormation.settle();   
% do the equivalent of settling, so we avoid activating a spurious place
% index (205), until our activation has stabilized
            
            for ii = 1:7
                testCase.animal.step();            
                disp(['HDS: ', num2str(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex()) ]); 
%                 testCase.plotGrids();
            end
            testCase.animal.hippocampalFormation.orienting = false;             
            testCase.animal.step();            
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                17, 'stable; now present features'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.nGrids, 4); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), 25); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 29); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 16); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 28);             
            
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.featuresDetected, ...
                testCase.animal.hippocampalFormation.lecSystem.featuresDetected, 'both set by placeSystem'); 
% %             testCase.assertEqual(system.lecSystem.getCueMaxActivationIndex(), 40);
% 
            testCase.assertEqual(testCase.animal.hippocampalFormation.lecSystem.getCueMaxActivationIndex(), 1);
            testCase.assertEqual(testCase.animal.hippocampalFormation.lecSystem.cueActivation(1,1:6), ...
                testCase.animal.hippocampalFormation.headDirectionSystem.uActivation(1,17:22), ...
                'head direction activation copied and shifted to canonical view'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163]); 
            testCase.animal.hippocampalFormation.orienting = true; 
            testCase.animal.hippocampalFormation.headDirectionSystem.initializeActivation(true);
            testCase.animal.hippocampalFormation.grids(1).initializeActivation();
            testCase.animal.hippocampalFormation.grids(2).initializeActivation();
            testCase.animal.hippocampalFormation.grids(3).initializeActivation();
            testCase.animal.hippocampalFormation.grids(4).initializeActivation();            
            for ii = 1:4
                testCase.animal.step();            
                disp(['HDS: ', num2str(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex()) ]); 
                disp(['Grid 1: ', num2str(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex()) ]);                 
                disp(['Grid 2: ', num2str(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex()) ]);                 
                disp(['Grid 3: ', num2str(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex()) ]);                 
                disp(['Grid 4: ', num2str(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex()) ]);                                 
%                 testCase.plotGrids();
            end
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                23, 'new stable head direction');
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), 16); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 17); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 8); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 13);             
%             testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
%                 [65 163], 'one index (LEC) matches previous [88 163]'); 
%             testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
%                 [88 163 205], 'read returns old place (at least), based on LEC input matching previous place]'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163], 'read returns old place, based on LEC input matching previous place]'); 
            
%             testCase.assertEqual(system.placeOutputIndices(), [92 230]); 
            relativeSpeed = 1;
            clockwiseNess = -1 ;  %clockwise 
            
            testCase.animal.turn(clockwiseNess, relativeSpeed); 
            testCase.assertThat(testCase.animal.currentDirection, ...
               IsEqualTo(pi*14/15, 'Within', RelativeTolerance(.00000001)));         
            for ii = 1:14
                testCase.animal.turn(clockwiseNess, relativeSpeed); 
                disp(['HDS: ', num2str(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex()) ]); 
%                 testCase.plotGrids();
            end

            testCase.assertThat(testCase.animal.currentDirection, ...
               IsEqualTo(0, 'Within', AbsoluteTolerance(.00001)));         
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                8, 'turned 15 from 23'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), 16, ...
                'turn only, so unchanged'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 17); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 8); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 13);             
%             testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), [65 163]); % 88  163 ?              
%             testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
%                 [88 163 205], 'read returns old place (at least), based on LEC input matching previous place]'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163], 'read returns old place, based on LEC input matching previous place]'); 
            testCase.animal.hippocampalFormation.settle();             
%             testCase.animal.hippocampalFormation.setReadMode(1); 
%             disp('read mode on'); 
%             for ii = 1:7
%                 testCase.animal.step();            
%                 disp(['HDS: ', num2str(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex()) ]); 
%                 disp(['Grid 1: ', num2str(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex()) ]);                 
%                 disp(['Grid 2: ', num2str(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex()) ]);                 
%                 disp(['Grid 3: ', num2str(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex()) ]);                 
%                 disp(['Grid 4: ', num2str(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex()) ]);                                 
% %                 testCase.plotGrids();
%             end
            testCase.animal.hippocampalFormation.orienting = false;
%             testCase.animal.hippocampalFormation.setReadMode(0); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
               2, 'when features were noted, physically at 15 (pi), hds at 17'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(1).getMaxActivationIndex(), 25); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(2).getMaxActivationIndex(), 29); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(3).getMaxActivationIndex(), 16); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.grids(4).getMaxActivationIndex(), 28);             
%             testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
%                 [88 163 205], 'place no longer reading, should return same as previous'); 
            testCase.assertEqual(testCase.animal.hippocampalFormation.placeOutputIndices(), ...
                [88 163], 'place no longer reading, should return same as previous'); 

        end          
        
        function testStopsRunIfWhiskerTouchingWall(testCase)
            buildAnimalInEnvironment(testCase);
            testCase.animal.keepRunnerForReporting = true;             
            testCase.animal.build();            
            testCase.animal.whiskerLength = 0.1;
            testCase.animal.motorCortex.runDistance = 5;             
            testCase.animal.place(testCase.environment, 1.69, 1, 0);              
            testCase.animal.motorCortex.run();
            testCase.assertEqual(testCase.animal.distanceTraveled, 0.1, 'one step'); 
            result = testCase.animal.motorCortex.currentPlan.getPlaceReport(6).toCharArray()'; 
            testCase.assertEqual(result, ...
                ['Move.Ongoing: Default=1  ' newline,  ...
                'Move.Run.Distance: Default=4  ' newline,  ...
                'Move.Run.ObjectSensed: Default=1  ' newline,  ...
                'Move.Run.Ongoing: Default=1  ' newline,  ...
                'Move.Run.Running: Default=1  ' newline,  ...
                'Move.Run.Speed: Default=1  ' newline,  ...
                'Move.Run.Stepped: Default=1  ' newline], 'object sensed');
            result2 = testCase.animal.motorCortex.currentPlan.getPlaceReport(8).toCharArray()'; 
            testCase.assertEqual(result2, ...
                ['Move.Ongoing: Default=1  ' newline,  ...
                'Move.Run.CleaningUp: Default=1  ' newline,  ...
                'Move.Run.Continuing: Default=1  ' newline,  ...
                'Move.Run.Distance: Default=4  ' newline,  ...
                'Move.Run.Ongoing: Default=1  ' newline,  ...
                'Move.Run.Running: Default=1  ' newline,  ...
                'Move.Run.Speed: Default=1  ' newline,  ...
                'Move.Run.Stopped: Default=1  ' newline], 'stopped, heading to done');
%              disp(testCase.animal.motorCortex.currentPlan.getPlaceReport(8));
        end          
        function testAnimalCalculatesItsAxisOfRotation(testCase) 
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();            
            testCase.animal.place(testCase.environment, 1, 1, 0);
            a = testCase.animal.axisOfRotation; 
            testCase.assertEqual(a(1,:), [1 1 0]);  % maybe                        
            testCase.assertEqual(a(2,:), [1 1 1]);                         
            testCase.animal.place(testCase.environment, 2, 3, 0);
            a = testCase.animal.axisOfRotation; 
            testCase.assertEqual(a(1,:), [2 3 0]);  % maybe                        
            testCase.assertEqual(a(2,:), [2 3 1]);                         
           
        end
        function testInitialAxisOfRotationIsOrigin(testCase) 
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();            
             a = testCase.animal.axisOfRotation; 
            testCase.assertEqual(a(1,:), [0 0 0]);  % maybe                        
            testCase.assertEqual(a(2,:), [0 0 1]);                                    
        end
        
        function testAnimalHasSubsystems(testCase)
            testCase.animal = Animal(); 
            testCase.animal.build(); 
            testCase.assertEqual(testCase.animal.motorCortex.animal, testCase.animal);                         
        end
        
        function testTurn(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();            
            testCase.animal.place(testCase.environment, 1, 1, 0);
            testCase.animal.orientAnimal(0);
            relativeSpeed = 1;
            clockwiseNess = -1 ;  %clockwise  
            testCase.animal.turn(clockwiseNess, relativeSpeed); 
            testCase.assertThat(testCase.animal.currentDirection, ...
               IsEqualTo(-pi/30, 'Within', RelativeTolerance(.00000001)));         
            relativeSpeed = 2;
            clockwiseNess = 1 ;  %counterclockwise  
            testCase.animal.turn(clockwiseNess, relativeSpeed); 
            testCase.assertThat(testCase.animal.currentDirection, ...
               IsEqualTo(pi/30, 'Within', RelativeTolerance(.00000001)));         
            testCase.animal.turn(clockwiseNess, relativeSpeed); 
            testCase.assertThat(testCase.animal.currentDirection, ...
               IsEqualTo(3*pi/30, 'Within', RelativeTolerance(.00000001)));         
        end
        function testHdsVelocityZeroBeforeAndAfterTurn(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();            
            testCase.animal.place(testCase.environment, 1, 1, 0);
            testCase.animal.orientAnimal(0);
%             testCase.assertThat(testCase.animal.headDirectionSystem.counterClockwiseVelocity, ...
%                IsEqualTo(0, 'Within', RelativeTolerance(.00000001)));         
%             testCase.assertThat(testCase.animal.headDirectionSystem.clockwiseVelocity, ...
%                IsEqualTo(0, 'Within', RelativeTolerance(.00000001)));         
            testCase.assertEqual(testCase.animal.headDirectionSystem.counterClockwiseVelocity, 0);                                     
            testCase.assertEqual(testCase.animal.headDirectionSystem.clockwiseVelocity, 0);                                     
            relativeSpeed = 1;
            clockwiseNess = -1 ;  %clockwise  
            testCase.animal.turn(clockwiseNess, relativeSpeed); 
            testCase.animal.turnDone(); % called by Turn.done 
            testCase.assertEqual(testCase.animal.headDirectionSystem.counterClockwiseVelocity, 0);                                     
            testCase.assertEqual(testCase.animal.headDirectionSystem.clockwiseVelocity, 0);                                     

        end

        function testRun(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();            
            testCase.animal.minimumRunVelocity = 0.1; 
            testCase.animal.place(testCase.environment, 1, 1, 0);
%            testCase.animal.orientAnimal(0);
            relativeSpeed = 1;
            testCase.assertThat(testCase.animal.x, ...
               IsEqualTo(1, 'Within', RelativeTolerance(.00000001)));         
            testCase.assertThat(testCase.animal.y, ...
               IsEqualTo(1, 'Within', RelativeTolerance(.00000001)));         
            testCase.animal.run(relativeSpeed); 
            testCase.assertEqual(testCase.animal.distanceTraveled, 0.1);                         
            testCase.assertThat(testCase.animal.x, ...
               IsEqualTo(1.1, 'Within', RelativeTolerance(.00000001)));         
            testCase.assertThat(testCase.animal.y, ...
               IsEqualTo(1, 'Within', RelativeTolerance(.00000001))); 
            % animal's position in the environment is also updated 
            testCase.assertThat(testCase.environment.position, ...
               IsEqualTo([1.1, 1], 'Within', RelativeTolerance(.00000001)));         
           
           
        end
        function testRunAtAngle(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();            
            testCase.animal.minimumRunVelocity = 0.1; 
            testCase.animal.place(testCase.environment, 1, 1, pi/4);
%            testCase.animal.orientAnimal(0);
            relativeSpeed = 1;
            testCase.assertThat(testCase.animal.x, ...
               IsEqualTo(1, 'Within', RelativeTolerance(.00000001)));         
            testCase.assertThat(testCase.animal.y, ...
               IsEqualTo(1, 'Within', RelativeTolerance(.00000001)));         
            testCase.animal.run(relativeSpeed); 
            testCase.assertEqual(testCase.animal.distanceTraveled, 0.1);                         
            testCase.assertThat(testCase.animal.x, ...
               IsEqualTo(1.07071, 'Within', RelativeTolerance(.00001)));         
            testCase.assertThat(testCase.animal.y, ...
               IsEqualTo(1.07071, 'Within', RelativeTolerance(.00001)));         
        end
        function testDistanceTraveledConvertedToLinearVelocity(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();            
            testCase.animal.minimumRunVelocity = 0.1; 
            testCase.animal.place(testCase.environment, 1, 1, pi/2);
            relativeSpeed = 1;
            testCase.animal.run(relativeSpeed); 
            testCase.assertEqual(testCase.animal.distanceTraveled, 0.1);
%             testCase.assertEqual(testCase.animal.cartesianVelocity, [0; 0.0001]);
            testCase.assertThat(testCase.animal.linearVelocity, ...
                IsEqualTo(0.0001, 'Within', RelativeTolerance(.00001)));         
            testCase.animal.place(testCase.environment, 1, 1, pi);
            relativeSpeed = 2;
            testCase.animal.run(relativeSpeed); 
            testCase.assertEqual(testCase.animal.distanceTraveled, 0.2);
            testCase.assertThat(testCase.animal.linearVelocity, ...
               IsEqualTo(0.0002, 'Within', RelativeTolerance(.00001)));         
        end        
        function testTurnAndRun(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();            
            testCase.animal.minimumRunVelocity = 0.1; 
            testCase.animal.place(testCase.environment, 1, 1, pi/2);
%            testCase.animal.orientAnimal(0);
            relativeSpeed = 1;
            testCase.animal.run(relativeSpeed); 
            testCase.assertEqual(testCase.animal.distanceTraveled, 0.1);                         
            testCase.assertThat(testCase.animal.x, ...
               IsEqualTo(1, 'Within', RelativeTolerance(.00001)));         
            testCase.assertThat(testCase.animal.y, ...
               IsEqualTo(1.1, 'Within', RelativeTolerance(.00001)));         
            clockwiseNess = -1 ;  %clockwise  
            testCase.animal.turn(clockwiseNess, 15); 
            testCase.assertThat(testCase.animal.currentDirection, ...
               IsEqualTo(0, 'Within', RelativeTolerance(.00000001)));         
            relativeSpeed = 2;
            testCase.animal.run(relativeSpeed); 
            testCase.assertEqual(testCase.animal.distanceTraveled, 0.2);                         
            testCase.assertThat(testCase.animal.x, ...
               IsEqualTo(1.2, 'Within', RelativeTolerance(.00001)));         
            testCase.assertThat(testCase.animal.y, ...
               IsEqualTo(1.1, 'Within', RelativeTolerance(.00001)));         
        end
        
        function testControllerIsSteppedAtEachTurn(testCase)
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();            
            testCase.assertEqual(testCase.animal.controller.getTime(), 0); 
            testCase.animal.place(testCase.environment, 1, 1, 0);
            clockwiseNess = -1;
            relativeSpeed = 1;
            testCase.animal.turn(clockwiseNess, relativeSpeed); 
            testCase.animal.turn(clockwiseNess, relativeSpeed); 
            testCase.animal.turn(clockwiseNess, relativeSpeed); 
            testCase.assertEqual(testCase.animal.controller.getTime(), 3);             
        end        
        function testClockwisenessMustBeOneOrMinusOne(testCase)
            buildAnimalInEnvironment(testCase);
            testCase.animal.build();            
            testCase.animal.place(testCase.environment, 1, 1, 0);
            clockwiseNess = -2 ;   
            try 
                testCase.animal.turn(clockwiseNess, 1); 
                testCase.assertFail('should throw'); 
            catch  ME
                testCase.assertEqual(ME.identifier, 'Animal:ClockwiseNess'); 
                testCase.assertEqual(ME.message, 'turn(clockwiseNess, relativeSpeed) clockwiseNess must be 1 (CCW) or -1 (CW).'); 
            end
        end
% see S8        function testRunThen180HeadDirectionRunBackSettlesToSamePlace(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             buildAnimalInEnvironment(testCase);
%             testCase.animal.minimumRunVelocity = 0.1; 
%             testCase.animal.place(testCase.environment, 1, 1, pi/2);
% %            testCase.animal.orientAnimal(0);
%             relativeSpeed = 1;
%             testCase.animal.run(relativeSpeed); 
%             testCase.assertEqual(testCase.animal.distanceTraveled, 0.1);                         
%             testCase.assertThat(testCase.animal.x, ...
%                IsEqualTo(1, 'Within', RelativeTolerance(.00001)));         
%             testCase.assertThat(testCase.animal.y, ...
%                IsEqualTo(1.1, 'Within', RelativeTolerance(.00001)));         
%             clockwiseNess = -1 ;  %clockwise  
%             testCase.animal.turn(clockwiseNess, 15); 
%             testCase.assertThat(testCase.animal.currentDirection, ...
%                IsEqualTo(0, 'Within', RelativeTolerance(.00000001)));         
%             relativeSpeed = 2;
%             testCase.animal.run(relativeSpeed); 
%             testCase.assertEqual(testCase.animal.distanceTraveled, 0.2);                         
%             testCase.assertThat(testCase.animal.x, ...
%                IsEqualTo(1.2, 'Within', RelativeTolerance(.00001)));         
%             testCase.assertThat(testCase.animal.y, ...
%                IsEqualTo(1.1, 'Within', RelativeTolerance(.00001)));         
%         end
%         
        function buildAnimalInEnvironment(testCase)
            testCase.environment = Environment();
            testCase.environment.addWall([0 0],[0 2]); 
            testCase.environment.addWall([0 2],[2 2]); 
            testCase.environment.addWall([0 0],[2 0]); 
            testCase.environment.addWall([2 0],[2 2]);
            testCase.environment.build();
            testCase.animal = Animal();

            
        end
    end
end