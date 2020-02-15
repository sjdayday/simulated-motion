classdef ExperimentControllerTest < AbstractTest
    methods (Test)
        % uncomment to run arbitrary numbers of scenarios
%         function testRunLongScenarios(testCase)
%             % runScenario initialize HDS, does navigation?
%             controller = ExperimentController(); 
%             controller.report = true; 
%             controller.reportTag = '0123EF456';
%             controller.reportPipeTag = 'v1.2.1'; 
%             controller.reportFilepath =  '../test/logs/';
% %             formattedDateTime = char(datetime(2020,1,19,16,0,55, 'Format','yyyy-MM-dd--HH-mm-ss')); 
% %             controller.reportFormattedDateTime = formattedDateTime;
% %             controller.cleanReporterFilesForTesting = true;
%             controller.nHeadDirectionCells = 30;
%             controller.nCueIntervals = 30;
%             controller.gridSize=[6,5]; 
%             controller.visualize(false);
%             controller.pullVelocityFromAnimal = false;
%             controller.pullFeaturesFromAnimal = false;  % had missed this
%             controller.defaultFeatureDetectors = false; 
%             controller.updateFeatureDetectors = true; 
%             controller.settleToPlace = false;
%             controller.placeMatchThreshold = 1; % was 2  
%             controller.showHippocampalFormationECIndices = true; 
%             controller.sparseOrthogonalizingNetwork = true; 
%             controller.separateMecLec = true; 
%             controller.twoCuesOnly = true; 
%             controller.nFeatures = 1; 
%             controller.hdsPullsFeatureWeightsFromLec = true;
%             controller.keepRunnerForReporting = true; % monitor for very large runs 
%             controller.hdsMinimumVelocity = pi/10; 
%             controller.minimumRunVelocity = 0.05; 
%             controller.minimumTurnVelocity=pi/10;
%             controller.build(); 
%             controller.stepPause = 0;
%             controller.resetSeed = false; 
%             controller.runScenarios(1, 3000); 
% % %             controller.totalSteps = 10; % 28
%             disp(controller.environment.showGridSquares()); 
% %             disp(controller.environment.showGridSquares()); 
%         end
        function testRunMultipleScenarios(testCase)
            % runScenario initialize HDS, does navigation?
            controller = ExperimentController(); 
            controller.report = true; 
            controller.reportTag = '0123EF456';
            controller.reportPipeTag = 'v1.2.1'; 
            controller.reportFilepath =  '../test/logs/';
%             formattedDateTime = char(datetime(2020,1,19,16,0,55, 'Format','yyyy-MM-dd--HH-mm-ss')); 
%             controller.reportFormattedDateTime = formattedDateTime;
            controller.cleanReporterFilesForTesting = true;
            controller.nHeadDirectionCells = 30;
            controller.nCueIntervals = 30;
            controller.gridSize=[6,5]; 
            controller.visualize(false);
            controller.pullVelocityFromAnimal = false;
            controller.pullFeaturesFromAnimal = false;  % had missed this
            controller.defaultFeatureDetectors = false; 
            controller.updateFeatureDetectors = true; 
            controller.settleToPlace = false;
            controller.placeMatchThreshold = 1; % was 2  
            controller.showHippocampalFormationECIndices = true; 
            controller.sparseOrthogonalizingNetwork = true; 
            controller.separateMecLec = true; 
            controller.twoCuesOnly = true; 
            controller.nFeatures = 1; 
            controller.hdsPullsFeatureWeightsFromLec = true;
            controller.keepRunnerForReporting = true; % monitor for very large runs 
            controller.hdsMinimumVelocity = pi/10; 
            controller.minimumRunVelocity = 0.05; 
            controller.minimumTurnVelocity=pi/10;
            controller.build(); 
            controller.stepPause = 0;
            controller.resetSeed = false; 
            controller.runScenarios(2, 10); 
% %             controller.totalSteps = 10; % 28
            testCase.assertEqual(controller.startingScenario, 2);
            testCase.assertEqual(controller.reporter.seed, uint32(2938499220)); 
            testCase.assertEqual(controller.reporter.placeId, '[16 41]'); 
            testCase.assertEqual(controller.getTime(), 10, ...
                'time restarts for each scenario');
            disp(controller.environment.showGridSquares()); 
            testCase.assertEqual(controller.reporter.gridSquarePercent, 0.02); 
        end
        function testNewScenarioBumpsSeedResetsStepsReloadsEventsForNewAnimalEnv(testCase)
            % runScenario initialize HDS, does navigation?
            controller = ExperimentController(); 
            controller.report = true; 
            controller.reportTag = '0123EF456';
            controller.reportPipeTag = 'v1.2.1'; 
            controller.reportFilepath =  '../test/logs/';
%             formattedDateTime = char(datetime(2020,1,19,16,0,55, 'Format','yyyy-MM-dd--HH-mm-ss')); 
%             controller.reportFormattedDateTime = formattedDateTime;
            controller.nHeadDirectionCells = 30;
            controller.nCueIntervals = 30;
            controller.gridSize=[6,5]; 
            controller.visualize(false);
            controller.pullVelocityFromAnimal = false;
            controller.pullFeaturesFromAnimal = false;  % had missed this
            controller.defaultFeatureDetectors = false; 
            controller.updateFeatureDetectors = true; 
            controller.settleToPlace = false;
            controller.placeMatchThreshold = 1; % was 2  
            controller.showHippocampalFormationECIndices = true; 
            controller.sparseOrthogonalizingNetwork = true; 
            controller.separateMecLec = true; 
            controller.twoCuesOnly = true; 
            controller.nFeatures = 1; 
            controller.hdsPullsFeatureWeightsFromLec = true;
            controller.keepRunnerForReporting = true; % monitor for very large runs 
            controller.hdsMinimumVelocity = pi/10; 
            controller.minimumRunVelocity = 0.05; 
            controller.minimumTurnVelocity=pi/10;
            
            controller.build(); 
            controller.stepPause = 0;
            controller.resetSeed = false; 
            testCase.assertEqual(controller.environment.gridSquareTotal(), 1, 'animal placed'); 
            testCase.assertEqual(controller.currentStep, 1); 
            controller.startingScenario = 1; 
            controller.runScenario(10); 
% %             controller.totalSteps = 10; % 28
            
            testCase.assertEqual(controller.reporter.seed, uint32(1301868182)); 
            testCase.assertEqual(controller.reporter.placeId, '[12 14]'); 
            testCase.assertEqual(controller.getTime(), 10); 
            animal1 = controller.animal; 
            environment1 = controller.environment; 
            controller.startingScenario = 2; 
            pause(1); 
            controller.runScenario(10); 
            testCase.assertEqual(controller.reporter.seed, uint32(2938499220)); 
            animal2 = controller.animal; 
            environment2 = controller.environment; 
            testCase.assertNotSameHandle(animal1, ...
                animal2, 'animal should have been re-created');
            testCase.assertNotSameHandle(environment1, ...
                environment2, 'environment should have been re-created');
            testCase.assertEqual(controller.reporter.placeId, '[16 41]'); 
            testCase.assertEqual(controller.getTime(), 10, ...
                'time restarts for each scenario');
            disp(environment2.showGridSquares()); 
        end
        function testCreatesReporterForEachRun(testCase)
            controller = ExperimentController(); 
            controller.startingScenario = 1; 
            controller.reportTag = '0123EF456';
            controller.reportPipeTag = 'v1.2.1'; 
            controller.reportFilepath =  '../test/logs/';
            formattedDateTime = char(datetime(2020,1,19,16,0,55, 'Format','yyyy-MM-dd--HH-mm-ss')); 
            controller.reportFormattedDateTime = formattedDateTime;
            controller.runScenario(0);
%             controller.build(); 

%             controller.reporter.buildFiles();  
            testCase.assertEqual(controller.reporter.getStepFile(), ...
                '../test/logs/2020-01-19--16-00-55_step.csv'); 
            testCase.assertEqual(controller.reporter.seed, ...
                uint32(1301868182), 'use second entry in current rng State as the seed'); 
%             controller.reporter.closeStepFile();
%             diary off; 
%             diary on; 
            controller.reporter.cleanFilesForTesting(); 
        end
        function testCreatesPredictableSequenceOfSeedsForRandomNumberGenerator(testCase)
         % This test depends on the details of the implementation of rng().  If this test breaks,
         % much of the ability of the system to replicate past results is
         % likely to be affected.  If replication is important, it may be necessary to fall 
         % back to an older version of Matlab.  
            controller = ExperimentController(); 
            controller.build(); 
            testCase.assertEqual(controller.bumpRandomSeed(), ...
                uint32(1301868182), 'use second entry in current rng State as the seed'); 
            testCase.assertEqual(controller.bumpRandomSeed(), ...
                uint32(2938499220), 'use second entry in current rng State as the seed'); 
            testCase.assertEqual(controller.bumpRandomSeed(), ...
                uint32(1137848623), 'use second entry in current rng State as the seed'); 
        end
        function testCreatesControllerWithDefaultHeadDirectionAndChartSystems(testCase)
            controller = ExperimentController(); 
            controller.build(); 
%             headDirectionSystem = HeadDirectionSystem(5); 
            testCase.assertClass(controller.animal.headDirectionSystem, ...
                'HeadDirectionSystem'); 
            testCase.assertClass(controller.chartSystem, ...
                'ChartSystem'); 
        end
        function testOverridesDefaultHeadDirectionAndChartSystemsSizes(testCase)
            controller = ExperimentController(); 
            controller.build(); 
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
        function testRunsHeadDirectionSystemForSpecifiedSteps(testCase)
            controller = ExperimentController(); 
            controller.build();
            controller.totalSteps = 20; 
            testCase.assertEqual(controller.currentStep, 1);
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 21);
            testCase.assertEqual(controller.animal.hippocampalFormation.headDirectionSystem.getTime(), 20);
        end
        function testCanSubstituteAnotherHdsCollaborator(testCase)
            controller = ExperimentController(); 
            controller.build();
            controller.totalSteps = 20; 
            testCase.assertEqual(controller.currentStep, 1);
            forced = HeadDirectionSystemForced(60); 
            forced.build();
            controller.rebuildHeadDirectionSystemFlag = false; 
            controller.animal.hippocampalFormation.headDirectionSystem = forced; 
%                 controller.overrideSystem(name, forced); 
            testCase.assertEqual(class(controller.animal.hippocampalFormation.headDirectionSystem), 'HeadDirectionSystemForced');            
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(class(controller.animal.hippocampalFormation.headDirectionSystem), 'HeadDirectionSystemForced');                        
            testCase.assertEqual(controller.currentStep, 21);
            testCase.assertEqual(controller.animal.hippocampalFormation.headDirectionSystem.getTime(), 20);
        end
        function testCanRunSystemForOneOrMoreSteps(testCase)
            controller = TestingExperimentController(); 
            controller.build();
            controller.totalSteps = 20; 
            testCase.assertEqual(controller.currentStep, 1);
            controller.runSystemForSteps(controller.testingSystem, 1); 
            testCase.assertEqual(controller.currentStep, 2);
            controller.runSystemForSteps(controller.testingSystem, 1);
            testCase.assertEqual(controller.currentStep, 3);
            controller.runSystemForSteps(controller.testingSystem, 4);
            testCase.assertEqual(controller.currentStep, 7);
            % let it run remainder of steps
            controller.runSystem(controller.testingSystem);
            testCase.assertEqual(controller.currentStep, 21);
        end
        function testSystemDoesNotStepBeyondTotal(testCase)
            controller = TestingExperimentController(); 
            controller.build();
            controller.totalSteps = 20; 
            controller.runSystemForSteps(controller.testingSystem, 8); 
            testCase.assertEqual(controller.currentStep, 9);
            controller.runSystemForSteps(controller.testingSystem, 8);
            testCase.assertEqual(controller.currentStep, 17);
            controller.runSystemForSteps(controller.testingSystem, 8);
            testCase.assertEqual(controller.currentStep, 21);
        end
        function testOneLastStepDoesntRun(testCase)
            controller = TestingExperimentController(); 
            controller.build();
            controller.totalSteps = 20; 
            controller.runSystemForSteps(controller.testingSystem, 20); 
            testCase.assertEqual(controller.currentStep, 21);
            controller.runSystemForSteps(controller.testingSystem, 1);
            testCase.assertEqual(controller.currentStep, 21);
        end
        function testHdsRunsForSteps(testCase)
            controller = ExperimentController(); 
            controller.build();
            controller.totalSteps = 20; 
            controller.runHeadDirectionSystemForSteps(5); 
            testCase.assertEqual(controller.currentStep, 6);
            controller.runHeadDirectionSystemForSteps(10); 
            testCase.assertEqual(controller.currentStep, 16);
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 21);
        end
        function testTracksCurrentStepForSystem(testCase)
            controller = ExperimentController();
            controller.build();
            testCase.assertEqual(controller.getCurrentStep('HeadDirectionSystem'), 1);
            testCase.assertEqual(controller.getCurrentStep('ChartSystem'), 1);
            controller.incrementCurrentStep('HeadDirectionSystem');
            controller.incrementCurrentStep('HeadDirectionSystem');
            testCase.assertEqual(controller.getCurrentStep('HeadDirectionSystem'), 3);
            testCase.assertEqual(controller.getCurrentStep('ChartSystem'), 1);
        end
        
        function testRunsSeparatelyEachForStepsButDoubleTimeResettingCurrentStep(testCase)
            controller = ExperimentController(); 
            controller.build();
            controller.totalSteps = 20; 
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 21);
            controller.runChartSystem(); 
            testCase.assertEqual(controller.currentStep, 21);
            testCase.assertEqual(controller.animal.hippocampalFormation.headDirectionSystem.getTime(), 40, ...
                'experiment controller is timekeeper for all components');
            testCase.assertEqual(controller.chartSystem.getTime(), 40, ...
                'experiment controller is timekeeper for all components');           
            testCase.assertEqual(controller.animal.getTime(), 40, ...
                'experiment controller is timekeeper for all components');  
        end
        function testContinuesFromWhereRunLeftOff(testCase)
            controller = ExperimentController(); 
            controller.build();
            controller.totalSteps = 20; 
            controller.runHeadDirectionSystem(); 
            controller.totalSteps = 25; 
            controller.continueHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 26);
            testCase.assertEqual(controller.animal.hippocampalFormation.headDirectionSystem.getTime(), 25);
        end
        function test2ndRunStartsOverIffTotalStepsIncreasedAndMapReinitialized(testCase)
            controller = ExperimentController(); 
            controller.build();
            controller.totalSteps = 20; 
            controller.runHeadDirectionSystem(); 
            firstSystem = controller.animal.hippocampalFormation.headDirectionSystem; 
            testCase.assertEqual(controller.currentStep, 21);
            controller.totalSteps = 40; 
            controller.buildSystemMap();
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 41);
            testCase.assertNotSameHandle(controller.animal.hippocampalFormation.headDirectionSystem, firstSystem);
        end
        function testContinueInvokesRunIfNoPreviousRun(testCase)
            controller = ExperimentController(); 
            controller.build();
            controller.totalSteps = 20; 
            controller.continueHeadDirectionSystem(); 
            testCase.assertEqual(controller.currentStep, 21);
        end
        function testRunUsesDefaultSeed(testCase)
            controller = ExperimentController(); 
            controller.build();
            controller.totalSteps = 5; 
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(round(rand()*1000)/1000, 0.815);
            controller.buildSystemMap(); 
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(round(rand()*1000)/1000, 0.815);
        end
        function testResetsDefaultSeed(testCase)
            controller = ExperimentController(); 
            controller.build();
            controller.totalSteps = 5; 
            controller.resetRandomSeed(true); 
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(round(rand()*1000)/1000, 0.815, ...
                'default is to reset seed');
            controller.resetRandomSeed(false);
            controller.buildSystemMap();
            controller.runHeadDirectionSystem(); 
            testCase.assertEqual(round(rand()*1000)/1000, 0.255, 'different seed');
        end
        function testAddPropertyAndSupportingKeysInMapWithValueInTargetSystem(testCase)
            controller = TestingExperimentController(); 
            controller.build();
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
            controller.build();
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
            controller.build();
            testCase.assertEqual(controller.headDirectionSystemPropertyMap.Count, uint64(21));
            testCase.assertEqual(controller.chartSystemPropertyMap.Count, uint64(21));
        end
        function testPropertyRangesAppliedToSystemAndGathersStats(testCase)
            controller = TestingExperimentController(); 
            controller.build();
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
            controller.build();
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
            controller.build();
            testCase.assertSameHandle(controller.animal.h, ...
                controller.h);
            testCase.assertSameHandle(controller.animal.headDirectionSystem.h, ...
                controller.h);
            testCase.assertSameHandle(controller.animal.hippocampalFormation.headDirectionSystem.h, ...
                controller.h);
            controller.visualize(false); % close handle
        end
        function testSystemProcessesEventsAtSpecifiedTime(testCase)
            controller = TestingExperimentController(); 
            controller.build();
            controller.addEvent(controller.testingSystem, 4, 'obj.testProperty = 7;'); 
            testCase.assertEqual(controller.testingSystem.testProperty, 2);
            controller.stepForSystem(controller.testingSystem); 
            controller.stepForSystem(controller.testingSystem);             
            controller.stepForSystem(controller.testingSystem);             
            testCase.assertEqual(controller.testingSystem.testProperty, 2, ...
                'still 2 at t=3' );
            controller.stepForSystem(controller.testingSystem);             
            testCase.assertEqual(controller.testingSystem.testProperty, 7, ...
                'event processed at t=4' );
        end
        function testControllerIsAlsoSystemAndProcessesEventsExactlyOnce(testCase)
            controller = TestingExperimentController(); 
            controller.build();
            % odd equation, but event was firing twice
            controller.addControllerEvent(3, 'obj.testingField = obj.testingField + 1;');
            testCase.assertEqual(controller.testingField, 0); 
            controller.stepForSystem(controller.testingSystem); 
            testCase.assertEqual(controller.testingField, 0); 
            controller.stepForSystem(controller.testingSystem); 
            testCase.assertEqual(controller.testingField, 0); 
            controller.stepForSystem(controller.testingSystem); 
            testCase.assertEqual(controller.testingField, 1); 
        end
        
    end
end
