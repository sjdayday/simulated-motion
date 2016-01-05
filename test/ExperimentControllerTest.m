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
        function testAddPropertyAndSupportingKeysInMapWithValueInTargetSystem(testCase)
            controller = TestingExperimentController(); 
            targetSystem = TestingSystem(); 
            controller.addSystemProperty(controller.testingSystemPropertyMap, 'testProperty', targetSystem); 
            testCase.assertEqual(... 
                controller.getSystemProperty(controller.testingSystemPropertyMap, 'testProperty'), 2);
            testCase.assertEqual(... 
                controller.getSystemProperty(controller.testingSystemPropertyMap, 'testProperty.increment'), 1);
            testCase.assertEqual(... 
                controller.getSystemProperty(controller.testingSystemPropertyMap, 'testProperty.max'), 2);
            testCase.assertEqual(... 
                controller.testingSystemPropertyMap.keys, ...
                {'testProperty','testProperty.increment','testProperty.max'});
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
            controller.buildChartSystemPropertyMap(); 
            testCase.assertEqual(... 
                controller.chartSystemPropertyMap.keys, ...
                {... 
                 'CInhibitionOffset','CInhibitionOffset.increment','CInhibitionOffset.max', ...
                 'alphaOffset','alphaOffset.increment','alphaOffset.max', ...
                 'betaGain','betaGain.increment','betaGain.max', ...
                 'featureLearningRate','featureLearningRate.increment','featureLearningRate.max', ...
                 'normalizedWeight','normalizedWeight.increment','normalizedWeight.max', ...
                 'sigmaAngularWeight','sigmaAngularWeight.increment','sigmaAngularWeight.max', ...
                 'sigmaHeadWeight','sigmaHeadWeight.increment','sigmaHeadWeight.max', ...
                 'sigmaWeightPattern','sigmaWeightPattern.increment','sigmaWeightPattern.max'});
        end
        function testPropertyMapsBuiltByDefault(testCase)
            controller = ExperimentController(); 
            testCase.assertEqual(controller.headDirectionSystemPropertyMap.Count, uint64(24));
            testCase.assertEqual(controller.chartSystemPropertyMap.Count, uint64(24));
        end
        function testPropertyRangesAppliedToSystemAndGathersStats(testCase)
            controller = TestingExperimentController(); 
            controller.totalSteps = 3; 
            testCase.assertEqual(controller.iteration, 0);
            controller.setSystemProperty(controller.testingSystemPropertyMap, ...
                'testProperty.max', 4);  
            controller.setSystemProperty(controller.testingSystemPropertyMap, ...
                'testProperty.increment', 0.5);  
            controller.iterateTestingSystemForPropertyRanges(); 
            testCase.assertEqual(controller.iteration, 5);
            testCase.assertEqual(controller.statisticsHeader, {'iteration','testProperty'});
            testCase.assertEqual(controller.statisticsDetail, ... 
                [1 2; 2 2.5; 3 3; 4 3.5; 5 4]);
        end
        function testPropertyRangesAppliedToChartSystemAndGathersStats(testCase)
            controller = ExperimentController(); 
            controller.totalSteps = 20; 
            testCase.assertEqual(controller.iteration, 0);
            controller.setChartSystemProperty('betaGain', 0.41);  
            controller.setChartSystemProperty('betaGain.increment', 0.1);  
            controller.setChartSystemProperty('betaGain.max', 0.44);  
            controller.setChartSystemProperty('sigmaWeightPattern', 0.65);  
            controller.setChartSystemProperty('sigmaWeightPattern.increment', 0.05);  
            controller.setChartSystemProperty('sigmaWeightPattern.max', 0.75);  
            controller.setChartSystemProperty('CInhibitionOffset', 0.01);  
            controller.setChartSystemProperty('CInhibitionOffset.increment', 0.02);  
            controller.setChartSystemProperty('CInhibitionOffset.max', 0.07);  
            controller.iterateChartSystemForPropertyRanges(); 
%             testCase.assertEqual(controller.iteration, 5);
%             testCase.assertEqual(controller.statisticsHeader, {'iteration','testProperty'});
%             testCase.assertEqual(controller.statisticsDetail, ... 
%                 [1 2; 2 2.5; 3 3; 4 3.5; 5 4]);
            disp(controller.statisticsHeader);
            disp(controller.statisticsDetail);            
        end
        
%                     obj.betaGain = 0.42; % was .75
%             obj.alphaOffset = 0; 
%             obj.sigmaWeightPattern = 0.7; %  2*pi/10
%             obj.CInhibitionOffset = 0.02; 

    end
end
% function network = createHebbMarrNetwork(dimension)
%     network = HebbMarrNetwork(dimension);    
%     network.weightType = 'binary'; %weights are binary
%     network.buildNetwork(); 
% end

