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
        function testOverridesDefaultHeadDirectionAndChartSystemsSizes(testCase)
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
        function testRunsHeadDirectionSystemSystemForSpecifiedSteps(testCase)
            controller = ExperimentController(); 
            controller.totalSteps = 20; 
            testCase.assertEqual(controller.currentStep, 1);
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 21);
            testCase.assertEqual(controller.headDirectionSystem.time, 20);
        end
        function testRunsSystemsSeparatelyEachForTotalStepsResettingCurrentStep(testCase)
            controller = ExperimentController(); 
            controller.totalSteps = 20; 
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 21);
            controller.runChartSystem(); 
            testCase.assertEqual(controller.currentStep, 21);
            testCase.assertEqual(controller.headDirectionSystem.time, 20);
            testCase.assertEqual(controller.chartSystem.time, 20);           
        end
        function testContinuesFromWhereRunLeftOff(testCase)
            controller = ExperimentController(); 
            controller.totalSteps = 20; 
            controller.runHeadDirectionSystem(); 
            controller.totalSteps = 25; 
            controller.continueHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 26);
            testCase.assertEqual(controller.headDirectionSystem.time, 25);
        end
        function testSecondRunStartsOver(testCase)
            controller = ExperimentController(); 
            controller.totalSteps = 20; 
            controller.runHeadDirectionSystem(); 
            firstSystem = controller.headDirectionSystem; 
            testCase.assertEqual(controller.currentStep, 21);
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 21);
            testCase.assertNotSameHandle(controller.headDirectionSystem, firstSystem);
        end
        function testContinueInvokesRunIfNoPreviousRun(testCase)
            controller = ExperimentController(); 
            controller.totalSteps = 20; 
            controller.continueHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 21);
        end
        function testRunUsesDefaultSeed(testCase)
            controller = ExperimentController(); 
            controller.totalSteps = 5; 
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(round(rand()*1000)/1000, 0.815);
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(round(rand()*1000)/1000, 0.815);
        end
        function testResetsDefaultSeed(testCase)
            controller = ExperimentController(); 
            controller.totalSteps = 5; 
            controller.resetRandomSeed(true); 
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(round(rand()*1000)/1000, 0.815, ...
                'default is to reset seed');
            controller.resetRandomSeed(false); 
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(round(rand()*1000)/1000, 0.255, 'different seed');
        end
        function testAddPropertyAndGenerateSupportingKeysInMapAllDefaultingToOne(testCase)
            controller = ExperimentController(); 
            controller.addHeadDirectionSystemProperty('sigmaHeadWeight'); 
            testCase.assertEqual(... 
                controller.getHeadDirectionSystemProperty('sigmaHeadWeight'), 1);
            testCase.assertEqual(... 
                controller.getHeadDirectionSystemProperty('sigmaHeadWeight.increment'), 1);
            testCase.assertEqual(... 
                controller.getHeadDirectionSystemProperty('sigmaHeadWeight.max'), 1);
            testCase.assertEqual(... 
                controller.headDirectionSystemPropertyMap.keys, ...
                {'sigmaHeadWeight','sigmaHeadWeight.increment','sigmaHeadWeight.max'});
        end
        function testBuildPropertyMapsWithDefaultKeys(testCase)
            controller = ExperimentController(); 
            controller.buildHeadDirectionSystemPropertyMap(); 
            testCase.assertEqual(... 
                controller.headDirectionSystemPropertyMap.keys, ...
                {... 
                 'CInhibitionOffset','CInhibitionOffset.increment','CInhibitionOffset.max', ...
                 'alphaOffset','alphaOffset.increment','alphaOffset.max', ...
                 'angularWeightOffset','angularWeightOffset.increment','angularWeightOffset.max', ...
                 'betaGain','betaGain.increment','betaGain.max', ...
                 'featureLearningRate','featureLearningRate.increment','featureLearningRate.max', ...
                 'normalizedWeight','normalizedWeight.increment','normalizedWeight.max', ...
                 'sigmaAngularWeight','sigmaAngularWeight.increment','sigmaAngularWeight.max', ...
                 'sigmaHeadWeight','sigmaHeadWeight.increment','sigmaHeadWeight.max'});
        end
        
    end
end
% function network = createHebbMarrNetwork(dimension)
%     network = HebbMarrNetwork(dimension);    
%     network.weightType = 'binary'; %weights are binary
%     network.buildNetwork(); 
% end

