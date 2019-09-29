classdef HeadDirectionSystemTest < AbstractTest
    methods (Test)
        function testAngularVelocityMovesActivationCounterClockwiseAndClockwise(testCase)
            headDirectionSystem = HeadDirectionSystem(60); 
            randomHeadDirection = true; 
            headDirectionSystem.initializeActivation(randomHeadDirection)            
            headDirectionSystem.build();
            % TODO remove once HDS takes external input instead of pulling
            % from Animal.
            headDirectionSystem.animal = Animal; 
%             headDirectionSystem.h = figure(); 
            headDirectionSystem.pullVelocity = false;  
            headDirectionSystem.step(); 
%             headDirectionSystem.plotActivation(); 
            testCase.assertEqual(headDirectionSystem.clockwiseVelocity, 0); 
            testCase.assertEqual(headDirectionSystem.counterClockwiseVelocity, 0); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 2); 
            headDirectionSystem.updateAngularVelocity(pi/10); 
            testCase.assertEqual(headDirectionSystem.counterClockwiseVelocity, pi/10);              
            testCase.assertEqual(headDirectionSystem.clockwiseVelocity, 0); 
            headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 9); 
            headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 11); 
            for ii = 3:10     
                headDirectionSystem.step(); 
%                  disp(headDirectionSystem.getMaxActivationIndex()); 
            end
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 23); 
            headDirectionSystem.updateAngularVelocity(-2*pi/10); 
            testCase.assertEqual(headDirectionSystem.counterClockwiseVelocity, 0);             
            testCase.assertEqual(headDirectionSystem.clockwiseVelocity, 2*pi/10);
%                 disp('reversing'); 
            headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 19); 
            headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 16); 
            for ii = 3:10    
                headDirectionSystem.step(); 
%                 disp(headDirectionSystem.getMaxActivationIndex()); 
            end
            % moves roughly twice as far CW as CCW when velocity is 2x greater
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 45); 
        end
        function testBuildsAngularWeightOffsetProportionalToHeadDirectionCells(testCase)
            headDirectionSystem = HeadDirectionSystem(60); 
            testCase.assertEqual(headDirectionSystem.angularWeightPercent, 0.133, ... 
                'derived from 8/60 -- original values'); 
            headDirectionSystem.build(); 
            testCase.assertEqual(headDirectionSystem.angularWeightOffset, 8); 
            headDirectionSystem = HeadDirectionSystem(12); 
            headDirectionSystem.build(); 
            testCase.assertEqual(headDirectionSystem.angularWeightOffset, 2); 
        end
        
        function testTurnVelocityConvertsToAngularVelocity(testCase)
            headDirectionSystem = HeadDirectionSystem(60); 
            minimumVelocity = headDirectionSystem.minimumVelocity; 
            headDirectionSystem.updateTurnVelocity(1); 
            testCase.assertEqual(headDirectionSystem.clockwiseVelocity, 0); 
            testCase.assertEqual(headDirectionSystem.counterClockwiseVelocity, minimumVelocity); 
            headDirectionSystem.updateTurnVelocity(0); 
            testCase.assertEqual(headDirectionSystem.clockwiseVelocity, 0); 
            testCase.assertEqual(headDirectionSystem.counterClockwiseVelocity, 0);

            headDirectionSystem.updateTurnVelocity(-2); 
            
            testCase.assertEqual(headDirectionSystem.clockwiseVelocity, 2*minimumVelocity); 
            testCase.assertEqual(headDirectionSystem.counterClockwiseVelocity, 0);

            headDirectionSystem.updateTurnVelocity(0); 
            testCase.assertEqual(headDirectionSystem.clockwiseVelocity, 0); 
            testCase.assertEqual(headDirectionSystem.counterClockwiseVelocity, 0);
            
        end
        function testActivationFollowsPreviouslyActivatedFeatures(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            headDirectionSystem = HeadDirectionSystem(60); 
            randomHeadDirection = true; 
            headDirectionSystem.initializeActivation(randomHeadDirection)            
            headDirectionSystem.pullVelocity = false;  
            headDirectionSystem.pullFeatures = false; 
            headDirectionSystem.nFeatureDetectors = 5; 
            headDirectionSystem.build();
            for ii = 1:7
                headDirectionSystem.step();            
            end
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), ...
                10, 'stable; now present features'); 
            headDirectionSystem.featuresDetected = [0 0 1 0 1]; 
            headDirectionSystem.step();            
            w = headDirectionSystem.featureWeights; 
            testCase.assertEqual(max(w(1,:)), 0); 
            testCase.assertThat(max(w(3,:)), ...            
                IsEqualTo(0.174664933360754, 'Within', RelativeTolerance(.00000000001))); 
            % randomly "place" animal elsewhere
            headDirectionSystem.initializeActivation(true);
            headDirectionSystem.initializeActivation(true); 
            headDirectionSystem.featuresDetected = [0 0 0 0 0]; 
            headDirectionSystem.step();            
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), ...
                20, 'stable activation at new random orientation'); 
            headDirectionSystem.featuresDetected = [0 0 1 0 1]; 
            headDirectionSystem.readMode = 1; 
            % features now drive us back to the orientation at which they 
            % were perceived: 10
            headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 18); 
            headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 12); 
            headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 11); 
            headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 11); 
            headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 10); 
            headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 10); 
            headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 10); 
        end
        function testUpdateActivationWithFeatureInputs(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            headDirectionSystem = HeadDirectionSystem(60); 
            randomHeadDirection = true; 
            headDirectionSystem.initializeActivation(randomHeadDirection)            
            headDirectionSystem.pullVelocity = false;  
            headDirectionSystem.pullFeatures = false; 
            headDirectionSystem.nFeatureDetectors = 5; 
            headDirectionSystem.build();
            for ii = 1:7
                headDirectionSystem.updateActivationWithMotionInputs();
%                 headDirectionSystem.step();            
            end
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), ...
                10, 'stable; now present features'); 
            headDirectionSystem.featuresDetected = [0 0 1 0 1]; 
            headDirectionSystem.step();            
            w = headDirectionSystem.featureWeights; 
            testCase.assertEqual(max(w(1,:)), 0); 
            testCase.assertThat(max(w(3,:)), ...            
                IsEqualTo(0.174664933360754, 'Within', RelativeTolerance(.00000000001))); 
            % randomly "place" animal elsewhere
            headDirectionSystem.initializeActivation(true);
            headDirectionSystem.initializeActivation(true); 
            headDirectionSystem.featuresDetected = [0 0 0 0 0]; 
            headDirectionSystem.updateActivationWithMotionInputs();
%             headDirectionSystem.step();            
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), ...
                20, 'stable activation at new random orientation'); 
            headDirectionSystem.featuresDetected = [0 0 1 0 1]; 
            headDirectionSystem.readMode = 1; 
            % features now drive us back to the orientation at which they 
            % were perceived: 10
            headDirectionSystem.updateActivationWithFeatureInputs();
%             headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 18); 
            headDirectionSystem.updateActivationWithFeatureInputs();
%             headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 12); 
            headDirectionSystem.updateActivationWithFeatureInputs();            
%             headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 11); 
            headDirectionSystem.updateActivationWithFeatureInputs();            
%             headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 11); 
            headDirectionSystem.updateActivationWithFeatureInputs();            
%             headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 10); 
            headDirectionSystem.updateActivationWithFeatureInputs();            
%             headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 10); 
            headDirectionSystem.updateActivationWithFeatureInputs();            
%             headDirectionSystem.step(); 
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 10); 
        end
%         function testUpdateActivationWithFeatureInputs(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             gridNet = GridChartNetwork(6,5); 
%             gridNet.externalVelocity = true; 
%             gridNet.nFeatureDetectors = 5; 
%             gridNet.featureGain = 3;
%             gridNet.featureOffset = 0.15;             
%             gridNet.build();
%             gridNet.build();  % build twice to mimic previous behavior prior to refactor          
%             gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
% %             gridNet.updateFeatureWeights(); 
%             for ii = 1:7
%                 gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
% %                 gridNet.updateFeatureWeights(); 
%             end
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), ...
%                 18, 'stable; now present features'); 
%             gridNet.featuresDetected = [0 0 1 0 0]; 
%             gridNet.readMode = 0; 
%             for ii = 1:5
%                 gridNet.updateActivationWithFeatureInputs(); % gridNet.step(); 
%             end
%             w = gridNet.featureWeights; 
%             testCase.assertEqual(max(w(1,:)), 0); 
%             testCase.assertThat(max(w(3,:)), ...            
%                 IsEqualTo(0.457953284878695, 'Within', RelativeTolerance(.00000000001))); % 0.488275478428257
% %             % randomly "place" animal elsewhere
%             gridNet.initializeActivation(); 
%             gridNet.featuresDetected = [0 0 0 0 0]; 
%             gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), ...
%                 25, 'stable activation at new random orientation'); 
%             gridNet.featuresDetected = [0 0 1 0 0]; 
%             gridNet.readMode = 1; 
%             % features now drive us back to the orientation at which they 
%             % were perceived: 18
% %             gridNet.updateActivationWithFeatureInputs(); % gridNet.step(); 
% %             testCase.assertEqual(gridNet.getMaxActivationIndex(), 19); 
%             gridNet.updateActivationWithFeatureInputs(); % gridNet.step(); 
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 18); 
%             gridNet.updateActivationWithFeatureInputs(); % gridNet.step(); 
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 18); 
%         end
%         function testSettleEquivalentToUpdateActivationWithFeatureInputs(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             gridNet = GridChartNetwork(6,5); 
%             gridNet.externalVelocity = true; 
%             gridNet.nFeatureDetectors = 5; 
%             gridNet.featureGain = 3;
%             gridNet.featureOffset = 0.15;             
%             gridNet.build();
%             gridNet.build();  % build twice to mimic previous behavior prior to refactor          
%             gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
% %             gridNet.updateFeatureWeights(); 
%             for ii = 1:7
%                 gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
% %                 gridNet.updateFeatureWeights(); 
%             end
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), ...
%                 18, 'stable; now present features'); 
%             gridNet.featuresDetected = [0 0 1 0 0]; 
%             for ii = 1:5
%                 gridNet.updateActivationWithFeatureInputs(); % gridNet.step(); 
%             end
%             w = gridNet.featureWeights; 
%             testCase.assertEqual(max(w(1,:)), 0); 
%             testCase.assertThat(max(w(3,:)), ...            
%                 IsEqualTo(0.457953284878695, 'Within', RelativeTolerance(.00000000001))); % 0.488275478428257
% %             % randomly "place" animal elsewhere
%             gridNet.initializeActivation(); 
%             gridNet.featuresDetected = [0 0 0 0 0]; 
%             gridNet.updateActivationWithMotionInputs(); % gridNet.step(); 
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), ...
%                 25, 'stable activation at new random orientation'); 
%             gridNet.featuresDetected = [0 0 1 0 0]; 
%             gridNet.settle(); 
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), 18, ...
%                 'back to original activation'); 
%         end

        
        
        % testWithoutAdditionalInputActivationAmplitudeDifferencesVanish
        % testActivationCanBeMaintainedWithRandomInputButAttractorMovesRandomly
        % test...activation increases amplitude??
        % testFeatureWeightsUpdated
        % testActivityBumpMovesClockwiseAndCounterClockwise
        % testActivityBumpMovesAtSpeedProportionalToAngularVelocity
        % testFeatureDetected
        % testExistingFeatureResetsActivityBumpAfterRandomInitialPositioning
        % testFeatureWeightsStrengthen
    end
end
