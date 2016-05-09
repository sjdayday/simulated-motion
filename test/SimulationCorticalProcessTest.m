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
            corticalProcess.tolerance = 1; % no simulations will be skipped
            testCase.assertEqual(length(corticalProcess.results), ...
                 0, 'no results yet'); 
            execution = corticalProcess.process(); 
            simulations = corticalProcess.simulations; 
            testCase.assertEqual(size(corticalProcess.simulations,2), 5);                      
            testCase.assertEqual(corticalProcess.simulations, ...
                 [1,0,1,1,0;
                  0,1,0,0,1;
                  0,0,0,0,1;
                  0,0,1,0,0;
                  0,0,0,1,0;
                  1,1,0,0,0;
                  0,1,1,1,0;
                  1,0,0,0,1]);                      
            testCase.assertThat(corticalProcess.predictions, ...            
                IsEqualTo([0,0,0.5,1,0;1,1,0.5,0,1], 'Within', AbsoluteTolerance(.1))); 
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
            corticalProcess = SimulationCorticalProcess(cortex,0.1,1,2,5); 
            testCase.assertEqual(length(corticalProcess.results), ...
                 0, 'no results yet'); 
            execution = corticalProcess.process(); 
            simulations = corticalProcess.simulations; 
            testCase.assertEqual(size(corticalProcess.simulations,2), 4);                      
            testCase.assertEqual(corticalProcess.simulations(:,4), ...
                 [1;0;0;0;1;0;1;0]);                      
            testCase.assertThat(corticalProcess.predictions, ...            
                IsEqualTo([0,0,0.5,1;1,1,0.5,0], 'Within', AbsoluteTolerance(.1))); 
%           Expecting result: 2 - (0.1 * 4) - 1 = 0.6                 
            testCase.assertThat(corticalProcess.currentResult(), ...            
                IsEqualTo(0.6, 'Within', RelativeTolerance(.0000001))); 
            
        end

    end
end
