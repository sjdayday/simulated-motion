classdef HeadDirectionSystemTest < AbstractTest
    methods (Test)
        function testCreateToeplitzWeights(testCase)
            headDirectionSystem = HeadDirectionSystem(5); 
            headDirectionSystem.weightInputVector = [1 2 3 4 5]; 
            headDirectionSystem.buildWeights(); 
            testCase.assertEqual(headDirectionSystem.headDirectionWeights, ...
               [1 2 3 4 5; ...
                2 1 2 3 4; ...
                3 2 1 2 3; ...
                4 3 2 1 2; ...
                5 4 3 2 1]); 
%             testCase.assertEqual(headDirectionSystem.headDirectionWeights, ...
%                [1 5 4 3 2; ...
%                 2 1 5 4 3; ...
%                 3 2 1 5 4; ...
%                 4 3 2 1 5; ...
%                 5 4 3 2 1]); 
        end
        function testCreateWeightInputVector(testCase)
            headDirectionSystem = HeadDirectionSystem(60); 
            headDirectionSystem.buildWeights(); 
            testCase.assertEqual(headDirectionSystem.headDirectionWeights, ...
               [1 5 4 3 2; ...
                2 1 5 4 3; ...
                3 2 1 5 4; ...
                4 3 2 1 5; ...
                5 4 3 2 1]); 
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
