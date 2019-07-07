classdef GridChartNetworkTest < AbstractTest
    methods (Test)
        function testCreateGridChartNetwork(testCase)
            gridNet = GridChartNetwork(6,5); 
            testCase.assertEqual(gridNet.nX, 6, '6 cols'); 
            testCase.assertEqual(gridNet.nY, 5, '5 rows'); 
        end
        function testGridPropertiesCanBeChangedPriorToExplicitBuild(testCase)
            gridNet = GridChartNetwork(6,5); 
            s = size(gridNet.positiveWeights); 
            testCase.assertEqual(s, [0 0], 'shouldnt be built yet'); 
            
            testCase.assertEqual(gridNet.motionWeightOffset, 5, 'current default'); 
            gridNet.build(); 
            positiveWeights = gridNet.positiveWeights;
            gridNet = GridChartNetwork(6,5); 
            gridNet.build(); 
            testCase.assertEqual(gridNet.positiveWeights, positiveWeights, ... 
                'weights should be same'); 
            
            gridNet.motionWeightOffset = 6; 
            gridNet.build(); 
            testCase.assertNotEqual(gridNet.positiveWeights, positiveWeights, ... 
                'weights should be different after changing input property'); 
            
%             system = HippocampalFormation();
%             system.nearThreshold = 0.2;
%             system.nGridOrientations = 3; 
%             system.gridDirectionBiasIncrement = pi/4;   
%             system.gridExternalVelocity = false; 
%             system.nGridGains = 1; 
%             system.gridSize = [6,5];
%             system.pullVelocity = false; 
%             system.defaultFeatureDetectors = false; 
%             system.updateFeatureDetectors = true;
%             system.build();  
%             testCase.assertTrue(system.grid(1).updateFeatureDetectors); 
%             testCase.assertEqual(position(2), obj.positiveWeights, 'first position saved is maintained'); 
%             system.build();
%             system.placeSystem.currentOutput = [0 1 0 1 0 1 0 1];
%             system.animal.x = 1.1;
%             system.animal.y = 0.1;
%             result = system.savePositionForPlace([1.1 0.1], [2 4 6 8]);
%             testCase.assertEqual(result, 2, 'new place'); 
%             result = system.savePositionForPlace([1.1 0.2], [2 4 6 8]);
%             testCase.assertEqual(result, 1, 'near place'); 
%             result = system.savePositionForPlace([1.1 0.5], [2 4 6 8]);
%             testCase.assertEqual(result, 0, 'far place'); 
%             position = system.getPositionForPlace('[2 4 6 8]'); 
%             testCase.assertEqual(position(1), 1.1, 'first position saved is maintained'); 
%             testCase.assertEqual(position(2), 0.1, 'first position saved is maintained'); 

        end
        function testCreateArrayOfGridChartNetwork(testCase)
            grids(1,3) = GridChartNetwork(6,5); 
            testCase.assertEqual(grids(1,3).nX, 6, ...
                'last object in array is initialized with 6,5'); 
            testCase.assertEqual(grids(1,1).nX, 10, ...
                'other objects initialized with default 10,9'); 
        end
%         function testActivationFollowsPreviouslyActivatedFeatures(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             gridNet = GridChartNetwork(6,5); 
%             gridNet.externalVelocity = true; 
%             gridNet.nFeatureDetectors = 5; 
%             gridNet.featureGain = 3;
%             gridNet.featureOffset = 0.15;             
%             gridNet.build();
%             gridNet.build();  % build twice to mimic previous behavior prior to refactor          
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
% %             % randomly "place" animal elsewhere
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
        function testUpdateActivationWithFeatureInputs(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            gridNet = GridChartNetwork(6,5); 
            gridNet.externalVelocity = true; 
            gridNet.nFeatureDetectors = 5; 
            gridNet.featureGain = 3;
            gridNet.featureOffset = 0.15;             
            gridNet.build();
            gridNet.build();  % build twice to mimic previous behavior prior to refactor          
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             gridNet.updateFeatureWeights(); 
            for ii = 1:7
                gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%                 gridNet.updateFeatureWeights(); 
            end
            testCase.assertEqual(gridNet.getMaxActivationIndex(), ...
                18, 'stable; now present features'); 
            gridNet.featuresDetected = [0 0 1 0 0]; 
            for ii = 1:5
                gridNet.updateActivationWithFeatureInputs(); % gridNet.step(); 
            end
            w = gridNet.featureWeights; 
            testCase.assertEqual(max(w(1,:)), 0); 
            testCase.assertThat(max(w(3,:)), ...            
                IsEqualTo(0.457953284878695, 'Within', RelativeTolerance(.00000000001))); % 0.488275478428257
%             % randomly "place" animal elsewhere
            gridNet.initializeActivation(); 
            gridNet.featuresDetected = [0 0 0 0 0]; 
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
            testCase.assertEqual(gridNet.getMaxActivationIndex(), ...
                25, 'stable activation at new random orientation'); 
            gridNet.featuresDetected = [0 0 1 0 0]; 
            gridNet.readMode = 1; 
            % features now drive us back to the orientation at which they 
            % were perceived: 18
%             gridNet.updateActivationWithFeatureInputs(); % gridNet.step(); 
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 19); 
            gridNet.updateActivationWithFeatureInputs(); % gridNet.step(); 
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 18); 
            gridNet.updateActivationWithFeatureInputs(); % gridNet.step(); 
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 18); 
        end
        function testSettleEquivalentToUpdateActivationWithFeatureInputs(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            gridNet = GridChartNetwork(6,5); 
            gridNet.externalVelocity = true; 
            gridNet.nFeatureDetectors = 5; 
            gridNet.featureGain = 3;
            gridNet.featureOffset = 0.15;             
            gridNet.build();
            gridNet.build();  % build twice to mimic previous behavior prior to refactor          
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             gridNet.updateFeatureWeights(); 
            for ii = 1:7
                gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%                 gridNet.updateFeatureWeights(); 
            end
            testCase.assertEqual(gridNet.getMaxActivationIndex(), ...
                18, 'stable; now present features'); 
            gridNet.featuresDetected = [0 0 1 0 0]; 
            for ii = 1:5
                gridNet.updateActivationWithFeatureInputs(); % gridNet.step(); 
            end
            w = gridNet.featureWeights; 
            testCase.assertEqual(max(w(1,:)), 0); 
            testCase.assertThat(max(w(3,:)), ...            
                IsEqualTo(0.457953284878695, 'Within', RelativeTolerance(.00000000001))); % 0.488275478428257
%             % randomly "place" animal elsewhere
            gridNet.initializeActivation(); 
            gridNet.featuresDetected = [0 0 0 0 0]; 
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
            testCase.assertEqual(gridNet.getMaxActivationIndex(), ...
                25, 'stable activation at new random orientation'); 
            gridNet.featuresDetected = [0 0 1 0 0]; 
            gridNet.settle(); 
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 18, ...
                'back to original activation'); 
        end

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
        function testMotionInputsLeavePairwiseDistancesConstant(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            gridNet = GridChartNetwork(6,5); 
            gridNet.motionInputWeights = true; 
            gridNet.build();
            gridNet.step();             
            squaredPairwiseDists = gridNet.squaredPairwiseDists; 
            gridNet.step(); 
            testCase.assertThat(gridNet.squaredPairwiseDists, ...
                IsEqualTo(squaredPairwiseDists, 'Within', RelativeTolerance(.00000001)));         
        end
        function testVelocityProvidedExternally(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            gridNet = GridChartNetwork(10,9); 
            gridNet.externalVelocity = true; 
            gridNet.build();
            gridNet.build(); % build twice to mimic previous behavior prior to refactor            
            gridNet.step(); 
%             gridNet.plot(); pause(1);  
            gridNet.step(); 
%             gridNet.plot(); 
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 25); 
            gridNet.updateVelocity(0.00005, -0.00005); % down & right
            gridNet.step(); 
%             gridNet.plot(); pause(1);  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 24, 'slow'); 
            gridNet.step(); 
%             gridNet.plot(); pause(1);  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 32); 
            gridNet.step(); 
%             gridNet.plot(); pause(1);  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 41); 
            gridNet.step(); 
%             gridNet.plot(); pause(1);  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 49); 
            gridNet.step(); 
%             gridNet.plot(); pause(1);  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 48); 
            gridNet.step(); 
%             gridNet.plot(); pause(1);  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 56); 
            gridNet.updateVelocity(-0.00005, 0); % left only 
            gridNet.step(); 
%             gridNet.plot(); pause(1);  disp(gridNet.getMaxActivationIndex());
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 47); 
            gridNet.step(); 
%             gridNet.plot(); pause(1); disp(gridNet.getMaxActivationIndex());             
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 47); 
            gridNet.step(); 
%             gridNet.plot(); pause(1); disp(gridNet.getMaxActivationIndex());  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 38); 
            gridNet.step(); 
%             gridNet.plot(); pause(1); disp(gridNet.getMaxActivationIndex());  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 29); 
            
%             gridNet.updateVelocity(0.00005, 0.000025); % NE 
%             gridNet.step(); 
%             gridNet.plot(); pause(1);  disp(gridNet.getMaxActivationIndex());
%       
%             gridNet.step(); 
%             gridNet.plot(); pause(1);  disp(gridNet.getMaxActivationIndex());
%             gridNet.step(); 
%             gridNet.plot(); pause(1);  disp(gridNet.getMaxActivationIndex());
%             gridNet.step(); 
%             gridNet.plot(); pause(1);  disp(gridNet.getMaxActivationIndex());
%             gridNet.step(); 
%             gridNet.plot(); pause(1);  disp(gridNet.getMaxActivationIndex());
%             gridNet.step(); 
%             gridNet.plot(); pause(1);  disp(gridNet.getMaxActivationIndex());
%             gridNet.step(); 
%             gridNet.plot(); pause(1);  disp(gridNet.getMaxActivationIndex());
%             gridNet.step(); 
%             gridNet.plot(); pause(1);  disp(gridNet.getMaxActivationIndex());

            % motion downward to right, remembering that y-axis is low to
            % high indices:
            %  9 18 27 36 45 54 63 72 81 90
            %      *25*  \
            %        \   *41*  
            %         \    \ 
            %         *32*  *49*
            %         29<\38<47<56* 
            %  1 10 19 28 37 46 55 64 73 82
            %
            %  1  2  3  4  5  6  7  8  9 10
        end
        function testStepEquivalentToUpdateActivationWithMotionInputs(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            gridNet = GridChartNetwork(10,9); 
            gridNet.externalVelocity = true; 
            gridNet.build();
            gridNet.build(); % build twice to mimic previous behavior prior to refactor 
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             gridNet.plot(); pause(1);  
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             gridNet.plot(); 
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 25); 
            gridNet.updateVelocity(0.00005, -0.00005); % down & right
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             gridNet.plot(); pause(1);  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 24, 'slow'); 
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             gridNet.plot(); pause(1);  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 32); 
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             gridNet.plot(); pause(1);  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 41); 
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             gridNet.plot(); pause(1);  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 49); 
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             gridNet.plot(); pause(1);  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 48); 
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             gridNet.plot(); pause(1);  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 56); 
            gridNet.updateVelocity(-0.00005, 0); % left only 
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             gridNet.plot(); pause(1);  disp(gridNet.getMaxActivationIndex());
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 47); 
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             gridNet.plot(); pause(1); disp(gridNet.getMaxActivationIndex());             
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 47); 
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             gridNet.plot(); pause(1); disp(gridNet.getMaxActivationIndex());  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 38); 
            gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             gridNet.plot(); pause(1); disp(gridNet.getMaxActivationIndex());  
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 29); 
            
        end
        
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

%         function testCreateNetwork(testCase)
%             h = figure; 
%             colsp = 3;
%             rowsp = 3;  
%             gh = gobjects(rowsp,colsp);
%             rowOffset = 0; 
%             for kk = 1:3
%                 for ll = 1:colsp
%                     indPlot = ll+(rowOffset * colsp);
% %                     disp([kk,ll,indPlot]); 
%                     gh(kk,ll) = subplot(colsp,rowsp,indPlot); 
%                 end
%                 rowOffset = rowOffset + 1; 
%             end
%             network = GridChartNetwork(6,5);
%             network.h = h; 
%             network.gh = gh; 
%             network2 = GridChartNetwork(6,5);
%             network2.h = h; 
%             network2.gh = gh;             
%             network2.inputDirectionBias = pi/4; 
%             network2.buildNetwork(); 
%             network3 = GridChartNetwork(6,5);
%             network3.h = h; 
%             network3.gh = gh;             
%             network3.inputGain = 50; 
%             network3.buildNetwork(); 
%             for ii = 1:100
%                 for jj = 1:10
%                     network.step();
%                     network2.step();
%                     network3.step();
%                     if jj == 10
%                         figure(h);
%                         network.plotAll(1); 
%                         network2.plotAll(2); 
%                         network3.plotAll(3);                         
% %                         subplot(331);
% %                         network.plotActivation();
% %                         subplot(332);
% %                         network.plotRateMap(); 
% %                         subplot(333);
% %                         network.plotTrajectory(); 
% %                         subplot(334); 
% %                         network2.plotActivation();
% %                         subplot(335);
% %                         network2.plotRateMap(); 
% %                         subplot(336);
% %                         network2.plotTrajectory(); 
% %                         subplot(337); 
% %                         network3.plotActivation();
% %                         subplot(338);
% %                         network3.plotRateMap(); 
% %                         subplot(339);
% %                         network3.plotTrajectory(); 
%                         drawnow; 
%                     end
%                 end
%             end
%         end
      function testMotionIncreasesWithInputGain(testCase)            
            h = figure; 
            colsp = 3;
            rowsp = 3;  
            gh = gobjects(rowsp,colsp);
            rowOffset = 0; 
            for kk = 1:rowsp
                for ll = 1:colsp
                    indPlot = ll+(rowOffset * colsp);
%                     disp([kk,ll,indPlot]); 
                    gh(kk,ll) = subplot(rowsp,colsp, indPlot); 
                end
                rowOffset = rowOffset + 1; 
            end
            network = GridChartNetwork(10,9);
            network.h = h; 
            network.gh = gh; 
            network.inputGain = 1000;
            network.externalVelocity = true; 
            load '../rngDefaultSettings';
            rng(rngDefault);   % set random 
            
            network.build();             
            network2 = GridChartNetwork(10,9);
            network2.h = h; 
            network2.gh = gh;  
            network2.externalVelocity = true; 
            network2.inputGain = 2000;
%             network2.motionWeightOffset = 4; 
%             network2.inputDirectionBias = pi/4; 
            load '../rngDefaultSettings';
            rng(rngDefault);   % set random 
            network2.build(); 
            network3 = GridChartNetwork(10,9);
            network3.h = h; 
            network3.gh = gh;  
            network3.externalVelocity = true; 
            %             network3.motionInputWeights = 1;
            network3.inputGain = 3000; 
%             network3.motionWeightOffset = 4; 
%             network3.inputDirectionBias = pi/4; 
            load '../rngDefaultSettings';
            rng(rngDefault);   % set random 
            network3.build(); 
            network.updateVelocity(0.00005, 0);
            network2.updateVelocity(0.00005, 0);
            network3.updateVelocity(0.00005, 0);            
%             network4 = GridChartNetwork(10,9);
%             network4.h = h; 
%             network4.gh = gh;  
%             network4.motionInputWeights = 1;
%             network4.motionWeightOffset = 4; 
%             network4.inputDirectionBias = pi/4; 
%             network4.buildNetwork(); 
%             for ii = 1:1000
            testCase.assertEqual(network.getMaxActivationIndex(), 12, 'all start same'); 
            testCase.assertEqual(network2.getMaxActivationIndex(), 12, 'all start same'); 
            testCase.assertEqual(network3.getMaxActivationIndex(), 12, 'all start same'); 
                for jj = 1:6
%                     pause(1)
%                     disp(['1: ',num2str(network.getMaxActivationIndex())]);                      
                    network.step();
%                     disp(['2: ',num2str(network2.getMaxActivationIndex())]);                      
                    network2.step();
%                     disp(['3: ',num2str(network3.getMaxActivationIndex())]);                                          
                    network3.step();
%                     figure(h);
%                     subplot(331); 
%                     network.plotActivation(); 
%                     subplot(334); 
%                     network2.plotActivation();
%                     subplot(337); 
%                     network3.plotActivation(); 
                        drawnow;  
                end
            disp(['1: ',num2str(network.getMaxActivationIndex())]);                          
            testCase.assertEqual(network.getMaxActivationIndex(), 20, ...
                'gain 1000: small motion');
            disp(['2: ',num2str(network2.getMaxActivationIndex())]);                     
            testCase.assertEqual(network2.getMaxActivationIndex(), 47, ...
                'gain 2000: middle'); 
            disp(['3: ',num2str(network3.getMaxActivationIndex())]);
            testCase.assertEqual(network3.getMaxActivationIndex(), 74, ...
                'gain 3000: large motion'); 
        end
        
      function testMotionAtIncreasingAngleWithDirectionBias(testCase)            
            h = figure; 
            colsp = 3;
            rowsp = 3;  
            gh = gobjects(rowsp,colsp);
            rowOffset = 0; 
            for kk = 1:rowsp
                for ll = 1:colsp
                    indPlot = ll+(rowOffset * colsp);
%                     disp([kk,ll,indPlot]); 
                    gh(kk,ll) = subplot(rowsp,colsp, indPlot); 
                end
                rowOffset = rowOffset + 1; 
            end
            network = GridChartNetwork(10,9);
            network.h = h; 
            network.gh = gh; 
            network.inputDirectionBias = 0;             
%             network.inputGain = 1000;
            network.externalVelocity = true; 
            load '../rngDefaultSettings';
            rng(rngDefault);   % set random 
            
            network.build();             
            network2 = GridChartNetwork(10,9);
            network2.h = h; 
            network2.gh = gh;  
            network2.externalVelocity = true; 
            network2.inputDirectionBias = pi/8; 
%             network2.inputGain = 2000;
%             network2.motionWeightOffset = 4; 
%              network2.inputDirectionBias = pi/4; 
            load '../rngDefaultSettings';
            rng(rngDefault);   % set random 
            network2.build(); 
            network3 = GridChartNetwork(10,9);
            network3.h = h; 
            network3.gh = gh;  
            network3.externalVelocity = true; 
            %             network3.motionInputWeights = 1;
            network3.inputDirectionBias = pi/4; 
%             network3.inputGain = 3000; 
%             network3.motionWeightOffset = 4; 
%             network3.inputDirectionBias = pi/4; 
            load '../rngDefaultSettings';
            rng(rngDefault);   % set random 
            network3.build(); 
            network.updateVelocity(0.00005, 0);
            network2.updateVelocity(0.00005, 0);
            network3.updateVelocity(0.00005, 0);            
            testCase.assertEqual(network.getMaxActivationIndex(), 12, 'all start same'); 
            testCase.assertEqual(network2.getMaxActivationIndex(), 12, 'all start same'); 
            testCase.assertEqual(network3.getMaxActivationIndex(), 12, 'all start same'); 
                for jj = 1:7
                    pause(0)
%                     disp(['1: ',num2str(network.getMaxActivationIndex())]);                      
                    network.step();
%                     disp(['2: ',num2str(network2.getMaxActivationIndex())]);                      
                    network2.step();
%                     disp(['3: ',num2str(network3.getMaxActivationIndex())]);                                          
                    network3.step();
%                     figure(h);
%                     subplot(331); 
%                     network.plotActivation(); 
%                     subplot(334); 
%                     network2.plotActivation();
%                     subplot(337); 
%                     network3.plotActivation(); 
%                         drawnow;  
                end
            disp(['1: ',num2str(network.getMaxActivationIndex())]);                          
            testCase.assertEqual(network.getMaxActivationIndex(), 38, ...
                'bias 0: horizontal motion');
            disp(['2: ',num2str(network2.getMaxActivationIndex())]);                     
            testCase.assertEqual(network2.getMaxActivationIndex(), 40, ...
                'bias pi/8: slight rise'); 
            disp(['3: ',num2str(network3.getMaxActivationIndex())]);
            testCase.assertEqual(network3.getMaxActivationIndex(), 24, ...
                'bias pi/4: large rise, sometimes doesnt cross columns'); 
      end
    end


%         function testCreateNetwork(testCase)
%             h = figure; 
%             colsp = 3;
%             rowsp = 3;  
%             gh = gobjects(rowsp,colsp);
%             rowOffset = 0; 
%             for kk = 1:rowsp
%                 for ll = 1:colsp
%                     indPlot = ll+(rowOffset * colsp);
% %                     disp([kk,ll,indPlot]); 
%                     gh(kk,ll) = subplot(rowsp,colsp, indPlot); 
%                 end
%                 rowOffset = rowOffset + 1; 
%             end
%             network = GridChartNetwork(10,9);
%             network.h = h; 
%             network.gh = gh; 
%             network.inputGain = 30; 
%             network.buildNetwork();             
%             network2 = GridChartNetwork(10,9);
%             network2.h = h; 
%             network2.gh = gh;  
%             network2.motionInputWeights = 1;
%             network2.motionWeightOffset = 4; 
% %             network2.inputDirectionBias = pi/4; 
%             network2.buildNetwork(); 
%             network3 = GridChartNetwork(10,9);
%             network3.h = h; 
%             network3.gh = gh;  
%             network3.motionInputWeights = 1;
%             network3.inputGain = 2000; 
%             network3.motionWeightOffset = 4; 
% %             network3.inputDirectionBias = pi/4; 
%             network3.buildNetwork(); 
%             network4 = GridChartNetwork(10,9);
%             network4.h = h; 
%             network4.gh = gh;  
%             network4.motionInputWeights = 1;
%             network4.motionWeightOffset = 4; 
%             network4.inputDirectionBias = pi/4; 
%             network4.buildNetwork(); 
%             for ii = 1:1000
%                 for jj = 1:10
%                     network.step();
%                     network2.step();
% %                     network3.step();
% %                     network4.step();
%                     if jj == 10
%                         figure(h);
%                         network.plotAll(1); 
%                         network2.plotAll(2);
%                         network2.plotDetail(3); 
% %                         network3.plotAll(3);
% %                         network4.plotAll(5);
%                         drawnow; 
% %                         pause(0.2); 
%                     end
%                 end
%             end
%         end
%     end
end