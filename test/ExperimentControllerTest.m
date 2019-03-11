classdef ExperimentControllerTest < AbstractTest
    methods (Test)
        function testCreatesControllerWithDefaultHeadDirectionAndChartSystems(testCase)
            controller = ExperimentController(); 
%             headDirectionSystem = HeadDirectionSystem(5); 
            testCase.assertClass(controller.animal.headDirectionSystem, ...
                'HeadDirectionSystem'); 
            testCase.assertClass(controller.chartSystem, ...
                'ChartSystem'); 
        end
        function testOverridesDefaultHeadDirectionAndChartSystemsSizes(testCase)
            controller = ExperimentController(); 
            testCase.assertEqual(controller.animal.hippocampalFormation.headDirectionSystem.nHeadDirectionCells, ...
                60, 'default number of head direction cells'); 
            controller.buildHeadDirectionSystem(20); 
            testCase.assertEqual(controller.animal.hippocampalFormation.headDirectionSystem.nHeadDirectionCells, ...
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
            testCase.assertEqual(controller.animal.hippocampalFormation.headDirectionSystem.time, 20);
        end
        function testRunsSystemsSeparatelyEachForTotalStepsResettingCurrentStep(testCase)
            controller = ExperimentController(); 
            controller.totalSteps = 20; 
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 21);
            controller.runChartSystem(); 
            testCase.assertEqual(controller.currentStep, 21);
            testCase.assertEqual(controller.animal.hippocampalFormation.headDirectionSystem.time, 20);
            testCase.assertEqual(controller.chartSystem.time, 20);           
% FIXME             testCase.assertEqual(controller.animal.time, 20);  
        end
        function testContinuesFromWhereRunLeftOff(testCase)
            controller = ExperimentController(); 
            controller.totalSteps = 20; 
            controller.runHeadDirectionSystem(); 
            controller.totalSteps = 25; 
            controller.continueHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 26);
            testCase.assertEqual(controller.animal.hippocampalFormation.headDirectionSystem.time, 25);
        end
        function testSecondRunStartsOver(testCase)
            controller = ExperimentController(); 
            controller.totalSteps = 20; 
            controller.runHeadDirectionSystem(); 
            firstSystem = controller.animal.hippocampalFormation.headDirectionSystem; 
            testCase.assertEqual(controller.currentStep, 21);
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 21);
            testCase.assertNotSameHandle(controller.animal.hippocampalFormation.headDirectionSystem, firstSystem);
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
                 'sigmaAngularWeight','sigmaAngularWeight.increment','sigmaAngularWeight.max'});
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
                 'sigmaWeightPattern','sigmaWeightPattern.increment','sigmaWeightPattern.max'});
        end
        function testPropertyMapsBuiltByDefault(testCase)
            controller = ExperimentController(); 
            testCase.assertEqual(controller.headDirectionSystemPropertyMap.Count, uint64(21));
            testCase.assertEqual(controller.chartSystemPropertyMap.Count, uint64(21));
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
            testCase.assertEqual(controller.testingStatisticsHeader, {'iteration','testProperty'});
            testCase.assertEqual(controller.testingStatisticsDetail, ... 
                [1 2; 2 2.5; 3 3; 4 3.5; 5 4]);
        end
%         function testPropertyRangesAppliedToChartSystemAndGathersStats(testCase)
% %                        obj.chartStatisticsHeader = {'iteration', 'weightSum', 'maxActivation', ... 
% %                 'deltaMaxMin', 'numMax', 'maxSlope', 'alphaOffset', ...
% %                 'betaGain', 'CInhibitionOffset', 'featureLearningRate', ...
% %                 'normalizedWeight', 'sigmaAngularWeight', 'sigmaHeadWeight', ... 
% %                 'sigmaWeightPattern'}; 
% % 
%             controller = ExperimentController(); 
%             controller.nChartSystemSingleDimensionCells = 50; 
%             controller.monitor = true; 
%             controller.totalSteps = 20; 
%             controller.setChartSystemProperty('betaGain', 0.25);  
%             controller.setChartSystemProperty('betaGain.increment', 0.05);  
%             controller.setChartSystemProperty('betaGain.max', 0.7);  
%             controller.setChartSystemProperty('sigmaWeightPattern', 0.50);  
%             controller.setChartSystemProperty('sigmaWeightPattern.increment', 0.05);  
%             controller.setChartSystemProperty('sigmaWeightPattern.max', 0.90);  
%             controller.setChartSystemProperty('CInhibitionOffset', 0.01);  
%             controller.setChartSystemProperty('CInhibitionOffset.increment', 0.03);  
%             controller.setChartSystemProperty('CInhibitionOffset.max', 0.25);  
%             controller.iterateChartSystemForPropertyRanges(); 
%         end
        function testMetricsVectorRerunsOriginalChartSystemScenario(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            controller = ExperimentController(); 
            record = [1 5.077490624715358 4.30861806429603 0.000001 1 1.00000000181092 0 0.4 0.01 0.5 0 5 0.6]; 
            controller.totalSteps = 20; 
            controller.rerunChartSystem(record);
            testCase.assertThat(controller.chartStatisticsDetail(1,:), ... 
                IsEqualTo(record, 'Within', RelativeTolerance(00000000000001)));         
            testCase.assertEqual(controller.chartStatisticsHeader, ... 
                {'iteration', 'weightSum', 'maxActivation', ... 
                'deltaMaxMin', 'numMax', 'maxSlope', 'alphaOffset', ...
                'betaGain', 'CInhibitionOffset', 'featureLearningRate', ...
                'normalizedWeight', 'sigmaAngularWeight', ... 
                'sigmaWeightPattern'});             
        end
        function testSystemIsRunWithGui(testCase)
            controller = ExperimentController(); 
            testCase.assertEqual(controller.visual, false); 
            controller.visualize(true); 
            testCase.assertSameHandle(controller.animal.headDirectionSystem.h, ...
                controller.h);
            testCase.assertSameHandle(controller.animal.h, ...
                controller.h);
            controller.visualize(false); % close handle
        end
        function testSystemProcessesEventsAtSpecifiedTime(testCase)
            controller = TestingExperimentController(); 
            controller.addEvent(controller.testingSystem, 4, 'obj.testProperty = 7;'); 
            testCase.assertEqual(controller.testingSystem.testProperty, 2);
            controller.step(controller.testingSystem); 
            controller.step(controller.testingSystem);             
            controller.step(controller.testingSystem);             
            testCase.assertEqual(controller.testingSystem.testProperty, 2, ...
                'still 2 at t=3' );
            controller.step(controller.testingSystem);             
            testCase.assertEqual(controller.testingSystem.testProperty, 7, ...
                'event processed at t=4' );
        end
        function testControllerIsAlsoSystemAndProcessesEvents(testCase)
            controller = TestingExperimentController(); 
            controller.addControllerEvent(3, 'obj.testingField = 1;');
            testCase.assertEqual(controller.testingField, 0); 
            controller.step(controller.testingSystem); 
            testCase.assertEqual(controller.testingField, 0); 
            controller.step(controller.testingSystem); 
            testCase.assertEqual(controller.testingField, 0); 
            controller.step(controller.testingSystem); 
            testCase.assertEqual(controller.testingField, 1); 
        end
        
    end
end
