classdef AnimalTest < AbstractTest
    properties
        environment
        animal
    end
    methods (Test)
        function testAnimalKnowsItsEnvironment(testCase)
            buildAnimalInEnvironment(testCase);
            testCase.animal.place(testCase.environment, 0.5, 0.25, 0);  
            testCase.assertEqual(testCase.animal.closestWallDistance(), 0.25);                         
        end
        function testAnimalCalculatesVerticesAtOriginDirectionZeroAtBuild(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
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
                testCase.assertEqual(ME.message, 'animal must be placed before it can turn or move:  place(...)'); 
            end
        end
        % turns accumulate 
        function testAnimalVerticesReflectCumulativeTurns(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
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
        function testAnimalCalculatesItsAxisOfRotation(testCase) 
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            buildAnimalInEnvironment(testCase);
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
        function testClockwisenessMustBeOneOrMinusOne(testCase)
            buildAnimalInEnvironment(testCase);
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
        function buildAnimalInEnvironment(testCase)
            testCase.environment = Environment();
            testCase.environment.addWall([0 0],[0 2]); 
            testCase.environment.addWall([0 2],[2 2]); 
            testCase.environment.addWall([0 0],[2 0]); 
            testCase.environment.addWall([2 0],[2 2]);
            testCase.environment.build();
            testCase.animal = Animal();
            testCase.animal.build();
            
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