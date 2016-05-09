classdef CorticalProcessTest < AbstractTest
    methods (Test)
        function testCorticalProcess(testCase)
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex);             
            corticalProcess = CorticalProcess(cortex,0.2,1,2,3); 
            testCase.assertClass(corticalProcess.cortex, 'Cortex');             
            testCase.assertEqual(corticalProcess.simulationCost, ...
                0.2, 'cost for each simulated execution'); 
            testCase.assertEqual(corticalProcess.physicalCost, ...
                1, 'cost for each physical execution'); 
            testCase.assertEqual(corticalProcess.rewardPayoff, ...
                2, 'reward for each rewarding execution'); 
            testCase.assertEqual(corticalProcess.numberSimulations, ...
                3, 'number of quiet awake simulations'); 
        end
        function testProcessAndUpdateResult(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex);             
            corticalProcess = TestingCorticalProcess(cortex,0.1,1,2,3); 
            testCase.assertEqual(length(corticalProcess.results), ...
                 0, 'no results yet'); 
            % force the simulationsRun counter 
            corticalProcess.simulationsRun = 4; 
            execution = corticalProcess.process(); 
%             disp(execution); 
            testCase.assertEqual(length(corticalProcess.results), ...
                 1, 'one result');                      
%           Expecting result: 2 - (0.1 * 4) - 1 = 0.6                 
            testCase.assertThat(corticalProcess.currentResult(), ...            
                IsEqualTo(0.6, 'Within', RelativeTolerance(.0000001))); 
            % force the simulationsRun counter
            corticalProcess.simulationsRun = 0; 
            execution = corticalProcess.process(); 
%             disp(execution);
            testCase.assertEqual(length(corticalProcess.results), ...
                 2, '2nd result');                      
%           Expecting result: 0.6 + (0 - (0.2 * 0) - 1) = -0.4                 
            testCase.assertThat(corticalProcess.currentResult(), ...            
                IsEqualTo(-0.4, 'Within', RelativeTolerance(.0000001))); 
%             disp(corticalProcess.results);
        end

    end
end
