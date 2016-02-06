classdef HeadDirectionSystemTest < AbstractTest
    methods (Test)
        function testCreateHeadDirectionSystem(testCase)
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
            for ii = 1:10     
                headDirectionSystem.step(); 
%                 headDirectionSystem.plotActivation();
%                 pause(0.5); 
%                 disp(headDirectionSystem.getMaxActivationIndex()); 
            end
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 57); 
            headDirectionSystem.updateAngularVelocity(-2*pi/10); 
            testCase.assertEqual(headDirectionSystem.counterClockwiseVelocity, 0);             
            testCase.assertEqual(headDirectionSystem.clockwiseVelocity, 2*pi/10); 
%                 disp('reversing'); 
            for ii = 1:10    
                headDirectionSystem.step(); 
%                 headDirectionSystem.plotActivation(); 
%                 pause(0.5); 
%                 disp(headDirectionSystem.getMaxActivationIndex()); 
            end
            testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 35); 

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
