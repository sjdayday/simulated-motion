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
        function testControllerOverridesDefaultHeadDirectionAndChartSystemsSizes(testCase)
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
        function testControllerRunsHeadDirectionSystemSystemForSpecifiedSteps(testCase)
            controller = ExperimentController(); 
            controller.totalSteps = 20; 
            testCase.assertEqual(controller.currentStep, 1);
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 21);
            testCase.assertEqual(controller.headDirectionSystem.time, 20);
        end
        function testControllerRunsSystemsSeparatelySummingTotalSteps(testCase)
            controller = ExperimentController(); 
            controller.totalSteps = 20; 
            controller.runHeadDirectionSystem(); 
            controller.totalSteps = 30; 
            controller.runChartSystem(); 
            testCase.assertEqual(controller.currentStep, 31);
            testCase.assertEqual(controller.headDirectionSystem.time, 20);
            testCase.assertEqual(controller.chartSystem.time, 10);           
        end
%         function testControllerContinuesFromWhereRunLeftOff(testCase)
%             controller = ExperimentController(); 
%             controller.totalSteps = 20; 
%             controller.runHeadDirectionSystem(); 
%             controller.totalSteps = 30; 
%             controller.runChartSystem(); 
%             testCase.assertEqual(controller.currentStep, 31);
%             testCase.assertEqual(controller.headDirectionSystem.time, 20);
%             testCase.assertEqual(controller.chartSystem.time, 10);           
%         end
      
    end
end
% function network = createHebbMarrNetwork(dimension)
%     network = HebbMarrNetwork(dimension);    
%     network.weightType = 'binary'; %weights are binary
%     network.buildNetwork(); 
% end

