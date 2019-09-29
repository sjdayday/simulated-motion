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
        end
        function testCreateArrayOfGridChartNetwork(testCase)
            grids(1,3) = GridChartNetwork(6,5); 
            testCase.assertEqual(grids(1,3).nX, 6, ...
                'last object in array is initialized with 6,5'); 
            testCase.assertEqual(grids(1,1).nX, 10, ...
                'other objects initialized with default 10,9'); 
        end
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
            gridNet.readMode = 0; 
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
        function testSettleGetsCurrentActivationIfNoFeatureInputOverlap(testCase)
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
            gridNet.featuresDetected = [0 1 0 0 0]; % no overlap  
            gridNet.settle(); 
            testCase.assertEqual(gridNet.getMaxActivationIndex(), 25, ...
                'stay at current activation'); 
        end
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