classdef ExperimentControllerTest < AbstractTest
    methods (Test)
        function testCreatesControllerWithDefaultHeadDirectionAndChartSystems(testCase)
            controller = ExperimentController(); 
%             headDirectionSystem = HeadDirectionSystem(5); 
            testCase.assertClass(controller.headDirectionSystem, ...
                'HeadDirectionSystem'); 
            testCase.assertClass(controller.chartSystem, ...
                'ChartSystem'); 
        end
        function testcontrollerOverridesDefaultHeadDirectionAndChartSystemsSizes(testCase)
            controller = ExperimentController(); 
            testCase.assertEqual(controller.headDirectionSystem.nHeadDirectionCells, ...
                60, 'default number of head direction cells'); 
            controller.buildHeadDirectionSystem(20); 
            testCase.assertEqual(controller.headDirectionSystem.nHeadDirectionCells, ...
                20, 'new number of head direction cells'); 
            testCase.assertClass(controller.chartSystem, ...
                'ChartSystem'); 
            testCase.assertEqual(controller.chartSystem.nSingleDimensionCells, ...
                10, 'default number of single dimension chart cells'); 
            controller.buildChartSystem(12); 
            testCase.assertEqual(controller.chartSystem.nSingleDimensionCells, ...
                12, 'new number of single dimension chart cells'); 
        end
%         function testCreateWeightInputVector(testCase)
%             headDirectionSystem = HeadDirectionSystem(60); 
%             headDirectionSystem.buildWeights(); 
%             testCase.assertEqual(headDirectionSystem.headDirectionWeights, ...
%                [1 5 4 3 2; ...
%                 2 1 5 4 3; ...
%                 3 2 1 5 4; ...
%                 4 3 2 1 5; ...
%                 5 4 3 2 1]); 
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
