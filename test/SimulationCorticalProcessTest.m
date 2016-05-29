classdef SimulationCorticalProcessTest < AbstractTest
    methods (Test)
        function testSimulationRunsMultipleScenariosBeforePhysicalExecution(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex);  
            cortex.loadNetworks(20); 
            corticalProcess = SimulationCorticalProcess(cortex,0.2,1,2,5);
            testCase.assertEqual(corticalProcess.predictionThreshold, ...
                 0.9, 'default');             
            corticalProcess.predictionThreshold = 1; % no simulations will be skipped
            testCase.assertEqual(length(corticalProcess.results), ...
                 0, 'no results yet'); 
            corticalProcess.currentRepresentation = 'FoundRewardAway';                
            execution = corticalProcess.process(); 
            simulations = corticalProcess.simulations; 
            testCase.assertEqual(size(corticalProcess.simulations,2), 5);                      
            testCase.assertEqual(corticalProcess.simulations, ...
                 [1,1,1,1,1;
                  0,0,0,0,0;
                  0,0,0,0,0;
                  0,1,0,0,0;
                  0,0,1,1,1;
                  1,0,0,0,0;
                  0,1,1,1,1;
                  1,0,0,0,0]);                      
            testCase.assertThat(corticalProcess.predictions, ...            
                IsEqualTo([0,0.5,1,1,1;1,0.5,0,0,0], 'Within', AbsoluteTolerance(.1))); 
%             disp(corticalProcess.results);
            testCase.assertEqual(length(corticalProcess.results), ...
                 1, 'one result');                      
        end
        function testSimulationRunsUntilPredictedRewardThenPhysicalExecution(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex);  
            cortex.loadNetworks(20); 
            testCase.assertEqual(cortex.simulationNetworkRebuildCount, 1);                                  
            corticalProcess = SimulationCorticalProcess(cortex,0.1,1,2,5); 
            testCase.assertEqual(length(corticalProcess.results), ...
                 0, 'no results yet'); 
            corticalProcess.currentRepresentation = 'FoundRewardAway';                
            execution = corticalProcess.process(); 
            testCase.assertEqual(cortex.simulationNetworkRebuildCount, 2);                                  
            simulations = corticalProcess.simulations;           
            testCase.assertEqual(size(corticalProcess.simulations,2), 3);                      
            testCase.assertEqual(corticalProcess.simulations(:,3), ...
                 [1;0;0;0;1;0;1;0]);                      
            testCase.assertThat(corticalProcess.predictions, ...            
                IsEqualTo([0,0.5,1;1,0.5,0], 'Within', AbsoluteTolerance(.1))); 
%           Expecting result: 2 - (0.1 * 3) - 1 = 0.7                 
            testCase.assertThat(corticalProcess.totalCost, ...            
                IsEqualTo(0.7, 'Within', RelativeTolerance(.0000001))); 
            
        end
        function testUsesPlanCorticalProcessToDriveSimulation(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex);  
            cortex.loadNetworks(20); 
            testingCorticalProcess = TestingCorticalProcess(cortex,0.1,1,2,3); 
            testingCorticalProcess.force = true; 
%             planCorticalProcess = PlanCorticalProcess(cortex,1,2);     
            testCase.assertEqual(cortex.simulationNetworkRebuildCount, 1);                                  
            simulationCost = 0.1; 
            simCorticalProcess = SimulationCorticalProcess(cortex,simulationCost,1,2,5); 
            simCorticalProcess.predictionThreshold = 0.5; 
            % use what planCorticalProcess knows about motor plans to suggest one to
            % simulate
            simCorticalProcess.planCorticalProcess = testingCorticalProcess; 
            simCorticalProcess.usePlanCorticalProcess = 1;
            testingCorticalProcess.forcedExecution=[1;0;1;0;0;0;1;0]; % Plan A, rewarding
            simCorticalProcess.currentRepresentation = 'FoundRewardAway';                
            
            simCorticalProcess.process(); 
            testCase.assertEqual(cortex.simulationNetworkRebuildCount, 2);                                  
            simulations = simCorticalProcess.simulations;           
            testCase.assertEqual(size(simulations,2), 1);                      
            testCase.assertEqual(simulations(:,1), ...
                 [1;0;1;0;0;0;1;0]);                                  
        end
        function testAddArbitraryRepresentationEntry(testCase)
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex);  
            corticalProcess = SimulationCorticalProcess(cortex,0.1,1,2,5); 
            testCase.assertEqual(corticalProcess.representationMap('FoundRewardAway'), ...
                [1;0], 'default');             
            corticalProcess.addRepresentationEntry('A', [1;0;0]);
            corticalProcess.addRepresentationEntry('FoundRewardAway', [0;1;1]);
            testCase.assertEqual(corticalProcess.representationMap('A'), ...
                [1;0;0], 'new vector');             
            testCase.assertEqual(corticalProcess.representationMap('FoundRewardAway'), ...
                [0;1;1], 'override previous vector');             
        end
        
    end
end
