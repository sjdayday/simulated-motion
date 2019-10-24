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
%         function testMoveReinitializeHdsManuallyOrientToPreviousHeadDirection(testCase)
% %           LEC system test: remember current head direction (not cue
% %           direction), at primary cue alignment
% %           place pointing away from cue
% %           establish head direction
% %           save canonical cue weights at head direction offset from cue.  
% %           re-initialize HDS
% %           manually turn to align physical head direction and primary cue
% %           animal.turn()
% %           readMode
% %           pulls to original head direction offset
%             
%             
%             %             % [when] do we need to do this? 
% %             % orient, turning 19? 9? until pointing at cue, currently HD
% %             = 11? 1?        
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             import matlab.unittest.constraints.AbsoluteTolerance                                    
%             system = HippocampalFormation();
%             system.nGridOrientations = 3; 
%             system.nHeadDirectionCells = 60; 
%             system.gridDirectionBiasIncrement = pi/4;   
%             system.gridExternalVelocity = true; 
%             system.nGridGains = 1; 
%             system.gridSize = [6,5];
%             system.pullVelocity = false;
%             system.pullFeatures = false; 
%             system.defaultFeatureDetectors = false; 
%             system.updateFeatureDetectors = true;
%             system.sparseOrthogonalizingNetwork = true; 
%             system.separateMecLec = true; 
%             system.hdsPullsFeatureWeightsFromLec = true; 
%             system.nFeatures = 3;
% %             system.showIndices = true; 
% 
% %             testCase.hf = system; 
% %             testCase.h=figure; 
% %             testCase.counter = 0; 
% %             hold on;  
% %             system.h = testCase.h;
% %             system.visual = true; 
%             
%             system.build(); 
% 
%             
% %         lec = LecSystem();
% %         lec.nHeadDirectionCells = 60;
% %         lec.nCueIntervals = 60; 
% % %         lec.nCueIntervals = 12;         
% %         lec.nFeatures = 3; 
% %         lec.nFeatureDetectors = 5;        
% %         lec.build(); 
%             env = Environment();
%             env.addWall([0 0],[0 2]); 
%             env.addWall([0 2],[2 2]); 
%             env.addWall([0 0],[2 0]); 
%             env.addWall([2 0],[2 2]);
%             env.directionIntervals = 60;
%             env.center = [1 1]; 
%             env.build();  
% 
% %             env.setPosition([0.5 1]);             
%     %             env.setPosition([0.5 1]); 
%             env.addCue([2 1]);  %  x   ------------- cue (at 0)
%             env.addCue([0 0]);            
%             env.addCue([1 2]);  % cue at pi/2                        
%             system.lecSystem.setEnvironment(env); 
% %             headDirectionSystem = HeadDirectionSystem(60); 
% %         randomHeadDirection = true; 
% %         headDirectionSystem.initializeActivation(randomHeadDirection)            
% %         headDirectionSystem.pullVelocity = false;  
% %         headDirectionSystem.pullFeatures = false; 
% %         headDirectionSystem.nFeatureDetectors = 5;
% %         headDirectionSystem.build();
% 
% %         lec.headDirectionSystem = headDirectionSystem; 
% %         headDirectionSystem.lec = lec; 
% %         lec.setEnvironment(env);         
%         
% %         disp(['LEC: ', lec.printOutputIndices() ]); 
%             system.animal.place(env, 1, 1, pi/2);  
% %             system.animal.place(env, 1, 1, pi); 
%             system.animal.hippocampalFormation = system; 
%             for ii = 1:7
%                 system.step();            
%                 disp(['HDS: ', num2str(system.headDirectionSystem.getMaxActivationIndex()) ]); 
% %                 testCase.plotGrids();
%             end
%             testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), ...
%                 10, 'stable; now present features'); 
%             testCase.assertEqual(system.headDirectionSystem.featuresDetected, ...
%                 system.lecSystem.featuresDetected, 'both set by placeSystem'); 
% %             testCase.assertEqual(system.lecSystem.getCueMaxActivationIndex(), 40);
% 
%             testCase.assertEqual(system.lecSystem.getCueMaxActivationIndex(), 55);
%             testCase.assertEqual(system.lecSystem.cueActivation(1,55:60), ...
%                 system.headDirectionSystem.uActivation(1,10:15), ...
%                 'head direction activation copied and shifted to canonical view'); 
%             testCase.assertEqual(system.placeOutputIndices(), [92 230]); 
%             system.orienting = true; 
%             system.headDirectionSystem.initializeActivation(true);
%             for ii = 1:2
%                 system.step();            
%                 disp(['HDS: ', num2str(system.headDirectionSystem.getMaxActivationIndex()) ]); 
% %                 testCase.plotGrids();
%             end
%             testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), ...
%                 45, 'new stable head direction'); 
%             testCase.assertEqual(system.placeOutputIndices(), [92 230]); 
%             relativeSpeed = 1;
%             clockwiseNess = -1 ;  %clockwise 
%             
%             system.animal.turn(clockwiseNess, relativeSpeed); 
%             testCase.assertThat(system.animal.currentDirection, ...
%                IsEqualTo(pi*14/30, 'Within', RelativeTolerance(.00000001)));         
%             for ii = 1:14
%                 system.animal.turn(clockwiseNess, relativeSpeed); 
%                 disp(['HDS: ', num2str(system.headDirectionSystem.getMaxActivationIndex()) ]); 
% %                 testCase.plotGrids();
%             end
% %                IsEqualTo(pi*29/30, 'Within', RelativeTolerance(.00000001)));         
% %             for ii = 1:29
% %                 system.animal.turn(clockwiseNess, relativeSpeed); 
% %                 disp(['HDS: ', num2str(system.headDirectionSystem.getMaxActivationIndex()) ]); 
% % %                 testCase.plotGrids();
% %             end
% 
%             testCase.assertThat(system.animal.currentDirection, ...
%                IsEqualTo(0, 'Within', AbsoluteTolerance(.00001)));         
% %             testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), ...
% %                 18, 'new head direction...expected 45-30=15'); 
% 
%             testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), ...
%                 33, 'new head direction...expected 45-15=30'); 
%             testCase.assertEqual(system.placeOutputIndices(), [92 230]); 
%             
%             system.headDirectionSystem.readMode = 1;
%             system.lecSystem.readMode = 1;
% %             figure; 
% %             hold on;
%             for ii = 1:14
%                 system.step();            
%                 disp(['HDS: ', num2str(system.headDirectionSystem.getMaxActivationIndex()) ]); 
% %                 plot(system.headDirectionSystem.uActivation); 
%                 disp(['LEC: ', num2str(system.lecSystem.getCueMaxActivationIndex()) ]); 
% %                 testCase.plotGrids();
%             end
%             system.orienting = false ; 
%         % features now drive us back to the canonical offset of HDS at which they 
%         % were perceived: 55
%             testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), 54, ....
%                 'pulled gradually to 54 (cue max is 55)'); 
% %             testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), 39, ....
% %                 'pulled immediately'); 
%         end
% TODO:  model after copied/commented HF test, above
        function testBothHdsAndGridsRecallPositionDirectionAfterOrienting(testCase)
%             system = HippocampalFormation();
%             system.nGridOrientations = 3; 
%             system.nHeadDirectionCells = 60; 
%             system.gridDirectionBiasIncrement = pi/4;   
%             system.gridExternalVelocity = true; 
%             system.nGridGains = 1; 
%             system.gridSize = [6,5];
%             system.pullVelocity = false;
%             system.pullFeatures = false; 
%             system.defaultFeatureDetectors = false; 
%             system.updateFeatureDetectors = true;
%             system.sparseOrthogonalizingNetwork = true; 
%             system.separateMecLec = true; 
%             system.hdsPullsFeatureWeightsFromLec = true; 
%             system.nFeatures = 3;
            
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
%         function testCurrentDirection(testCase)
%             testCase.animal = Animal(); 
%             testCase.animal.build(); 
%             testCase.animal.
%             testCase.assertEqual(animal.motorCortex.animal, testCase.animal);                         
%         end
        
%         function testCalculatesRelativeDistanceToCues(testCase)
%             lec = LecSystem();
%             lec.distanceUnits = 8;
%             lec.nHeadDirectionCells = 60;
%             lec.nFeatures = 3; 
%             lec.rewardUnits = 5; 
%             lec.build(); 
%             testCase.assertEqual(lec.nOutput, 209); 
%         end
%         function testCreateArrayOfGridChartNetwork(testCase)
%             grids(1,3) = GridChartNetwork(6,5); 
%             testCase.assertEqual(grids(1,3).nX, 6, ...
%                 'last object in array is initialized with 6,5'); 
%             testCase.assertEqual(grids(1,1).nX, 10, ...
%                 'other objects initialized with default 10,9'); 
%         end
%         function testActivationFollowsPreviouslyActivatedFeatures(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             gridNet = GridChartNetwork(6,5); 
%             gridNet.externalVelocity = true; 
%             gridNet.nFeatureDetectors = 5; 
%             gridNet.featureGain = 3;
%             gridNet.featureOffset = 0.15;             
%             gridNet.buildNetwork();
%             gridNet.step(); 
%             for ii = 1:7
%                 gridNet.step();            
%             end
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), ...
%                 18, 'stable; now present features'); 
%             gridNet.featuresDetected = [0 0 1 0 0]; 
%             for ii = 1:5
%                 gridNet.step();            
%             end
%             w = gridNet.featureWeights; 
%             testCase.assertEqual(max(w(1,:)), 0); 
%             testCase.assertThat(max(w(3,:)), ...            
%                 IsEqualTo(0.488275478428257, 'Within', RelativeTolerance(.00000000001))); 
% %             % randomly "place" testCase.animal elsewhere
%             gridNet.initializeActivation(); 
%             gridNet.featuresDetected = [0 0 0 0 0]; 
%             gridNet.step();            
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), ...
%                 25, 'stable activation at new random orientation'); 
%             gridNet.featuresDetected = [0 0 1 0 0]; 
%             gridNet.readMode = 1; 
%             % features now drive us back to the orientation at which they 
%             % were perceived: 18
%             gridNet.step(); 
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 19); 
%             gridNet.step(); 
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 18); 
%             gridNet.step(); 
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 18); 
%             gridNet.step(); 
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 18); 
%         end

%         function testPositiveAndNegativeMotionWeights(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             gridNet = GridChartNetwork(6,5); 
%             gridNet.buildNetwork();
%             testCase.assertEqual(length(gridNet.horizonalWeightInputVector), 6, ...
%                 'weights operate row at a time, until/unless I figure out how to process 5X6 matrix in one pass');
%             testCase.assertEqual(length(gridNet.verticalWeightInputVector), 5);
%             testCase.assertEqual(size(gridNet.positiveHorizontalWeights), [6 6 ]);
%             testCase.assertEqual(size(gridNet.negativeHorizontalWeights), [6 6]);
%             testCase.assertEqual(size(gridNet.positiveVerticalWeights), [5 5]);
%             testCase.assertEqual(size(gridNet.negativeVerticalWeights), [5 5]);
%             % assumes row at a time processing
% %             horizontalPositive = [0.184796813628934   0.201687064406685 0.184796813628934 0.147980845516166 0.129517595665892];            
%             horizontalPositive = [0.184796813628934  0.201687064406685   0.184796813628934   0.147980845516166   0.129517595665892 0.147980845516166];            
%             testCase.assertThat(gridNet.positiveHorizontalWeights(1,:), ...
%                 IsEqualTo(horizontalPositive, 'Within', RelativeTolerance(.0000000001)));         
% %             horizontalNegative = [0.147980845516166 0.129517595665892, 0.147980845516166   0.184796813628934   0.201687064406685];
%             horizontalNegative = [0.184796813628934   0.147980845516166 0.129517595665892, 0.147980845516166   0.184796813628934   0.201687064406685];
%             testCase.assertThat(gridNet.negativeHorizontalWeights(1,:), ...
%                 IsEqualTo(horizontalNegative, 'Within', RelativeTolerance(.0000000001)));         
%             % vertical processing, after transposition, implies shift
%             % to the left to make numbers be more positive after transpose back 
% %             verticalPositive = [0.184796813628934   0.147980845516166 0.129517595665892, 0.147980845516166   0.184796813628934   0.201687064406685];
%             verticalPositive = [0.203028146638744   0.185744160092518   0.185744160092518   0.203028146638744   0.208235290447501];
% 
% %             verticalPositive = [0.184796813628934   0.201687064406685 0.184796813628934 0.147980845516166 0.129517595665892];
%             testCase.assertThat(gridNet.positiveVerticalWeights(1,:), ...
%                 IsEqualTo(verticalPositive, 'Within', RelativeTolerance(.00000001)));         
% %             verticalNegative = [0.184796813628934  0.201687064406685   0.184796813628934   0.147980845516166   0.129517595665892 0.147980845516166];            
%             verticalNegative = [0.203028146638744   0.208235290447501 0.203028146638744   0.185744160092518   0.185744160092518];
% %             verticalNegative = [0.147980845516166 0.129517595665892, 0.147980845516166   0.184796813628934   0.201687064406685];
%             testCase.assertThat(gridNet.negativeVerticalWeights(1,:), ...
%                 IsEqualTo(verticalNegative, 'Within', RelativeTolerance(.00000001)));         
%         end
%         function testVelocityProvidedExternally(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             gridNet = GridChartNetwork(10,9); 
%             gridNet.externalVelocity = true; 
%             gridNet.buildNetwork();
%             gridNet.step(); 
% %             gridNet.plot(); pause(1);  
%             gridNet.step(); 
% %             gridNet.plot(); 
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 25); 
%             gridNet.updateVelocity(0.00005, -0.00005); % down & right
%             gridNet.step(); 
% %             gridNet.plot(); pause(1);  
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 24, 'slow'); 
%             gridNet.step(); 
% %             gridNet.plot(); pause(1);  
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 32); 
%             gridNet.step(); 
% %             gridNet.plot(); pause(1);  
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 41); 
%             gridNet.step(); 
% %             gridNet.plot(); pause(1);  
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 49); 
%             gridNet.step(); 
% %             gridNet.plot(); pause(1);  
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 48); 
%             gridNet.step(); 
% %             gridNet.plot(); pause(1);  
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 56); 
%             gridNet.updateVelocity(-0.00005, 0); % left only 
%             gridNet.step(); 
% %             gridNet.plot(); pause(1);  disp(gridNet.getMaxActivationIndex());
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 47); 
%             gridNet.step(); 
% %             gridNet.plot(); pause(1); disp(gridNet.getMaxActivationIndex());             
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 47); 
%             gridNet.step(); 
% %             gridNet.plot(); pause(1); disp(gridNet.getMaxActivationIndex());  
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 38); 
%             gridNet.step(); 
% %             gridNet.plot(); pause(1); disp(gridNet.getMaxActivationIndex());  
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 29); 
%             % motion downward to right, remembering that y-axis is low to
%             % high indices:
%             %  9 18 27 36 45 54 63 72 81 90
%             %      *25*  \
%             %        \   *41*  
%             %         \    \ 
%             %         *32*  *49*
%             %         29<\38<47<56* 
%             %  1 10 19 28 37 46 55 64 73 82
%             %
%             %  1  2  3  4  5  6  7  8  9 10
%         end
        
%         function testBuildsHorizontalMotionSynapticInput(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             gridNet = GridChartNetwork(6,5); 
%             gridNet.motionInputWeights = 1; 
%             gridNet.buildNetwork();
%             gridNet.activation = ...
%                 [0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 2 1 0 0 0 1 0 0 0 0 0 0 0]; 
%             % looks like:
% %             0     0     0     0     0     0
% %             0     0     0     1     0     0
% %             0     0     1     2     1     0
% %             0     0     0     1     0     0
% %             0     0     0     0     0     0
%             gridNet.velocity = [ 0.3; 0.2]; 
%             % shifted right
%             horizontalInput = ...
%                    [0   0   0   0   0   0;
%                     0.044394253654850   0.038855278699768   0.044394253654850   0.055439044088680   0.060506119322006   0.055439044088680;
%                     0.183082830098147   0.166499064709234   0.183082830098147   0.215778461154216   0.231890326821372   0.215778461154216;
%                     0.044394253654850   0.038855278699768   0.044394253654850   0.055439044088680   0.060506119322006   0.055439044088680;
%                     0   0   0   0   0   0; ];
%             testCase.assertThat(gridNet.calculateHorizontalInput(), ...
%             IsEqualTo(horizontalInput, 'Within', RelativeTolerance(.00000001)));         
%         end
%         function testBuildsVerticalMotionSynapticInput(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             gridNet = GridChartNetwork(6,5); 
%             gridNet.motionInputWeights = 1; 
%             gridNet.buildNetwork();
%             gridNet.activation = ...
%                 [0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 2 1 0 0 0 1 0 0 0 0 0 0 0]; 
%                         % looks like:
% %             0     0     0     0     0     0
% %             0     0     0     1     0     0
% %             0     0     1     2     1     0
% %             0     0     0     1     0     0
% %             0     0     0     0     0     0
% 
%             gridNet.velocity = [ 0.3; 0.2]; 
%             % shifted up
%             verticalInput = ...
%               [0                   0   0.040605629327749   0.160007148763501   0.040605629327749                   0; 
%                0                   0   0.041647058089500   0.164505374834498   0.041647058089500                   0;
%                0                   0   0.040605629327749   0.160007148763501   0.040605629327749                   0;
%                0                   0   0.037148832018504   0.152052125383259   0.037148832018504                   0;
%                0                   0   0.037148832018504   0.152052125383259   0.037148832018504                   0];            
%            testCase.assertThat(gridNet.calculateVerticalInput(), ...
%                 IsEqualTo(verticalInput, 'Within', RelativeTolerance(.00000001)));
%             reshapeInput = reshape(verticalInput,1,gridNet.nCells);
%             verticalInputReshaped = reshape(reshapeInput,gridNet.nY,gridNet.nX); 
%             testCase.assertThat(verticalInputReshaped, ...
%                 IsEqualTo(verticalInput, 'Within', RelativeTolerance(.00000001)));
%             
%         end
%         function testWeightOffset(testCase)
%             
%         end
%         function testWeightOrientation(testCase)
%             
%         end
%         function testWeightGain(testCase)
%             
%         end
%         function testSingle(testCase)
%             gridNet = GridChartNetwork(6,5);
%             gridNet.motionInputWeights = 1;
%             gridNet.buildNetwork();
%             gridNet.step();
%             gridNet.plot();
%             gridNet.step();
%             gridNet.plot();
%             for ii = 1:100
%                 for jj = 1:10
%                     gridNet.step();
%                     if jj == 10
%                         gridNet.plot();
%                         drawnow;
%                     end
%                 end
%             end
%         end
    end
end