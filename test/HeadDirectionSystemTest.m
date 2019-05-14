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
