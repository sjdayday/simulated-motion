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
            testCase.assertThat(corticalProcess.currentResult(), ...            
                IsEqualTo(0.7, 'Within', RelativeTolerance(.0000001))); 
            
        end
% test using planCorticalProcess to drive simulation
    end
end
