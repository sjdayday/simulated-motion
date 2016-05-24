classdef CombinedCorticalProcessTest < AbstractTest
    methods (Test)
        function testCorticalProcess(testCase)
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex);             
            corticalProcess = CombinedCorticalProcess(cortex);
            corticalProcess.simulationCost = 0.1;
            corticalProcess.physicalCost = 1;
            corticalProcess.rewardPayoff = 2;            
            corticalProcess.numberSimulations = 5;            
            corticalProcess.build(); 
            testCase.assertClass(corticalProcess.simulationCorticalProcess, ... 
                'SimulationCorticalProcess');             
            testCase.assertClass(corticalProcess.planCorticalProcess, ... 
                'PlanCorticalProcess');             
            testCase.assertEqual(corticalProcess.simulationCorticalProcess.simulationCost, ...
                0.1, 'cost for each simulated execution'); 
            testCase.assertEqual(corticalProcess.planCorticalProcess.simulationCost, ...
                0, 'default'); 
            testCase.assertEqual(corticalProcess.simulationCorticalProcess.physicalCost, ...
                1, 'cost for each physical execution'); 
            testCase.assertEqual(corticalProcess.planCorticalProcess.physicalCost, ...
                1, 'cost for each physical execution'); 
            testCase.assertEqual(corticalProcess.simulationCorticalProcess.rewardPayoff, ...
                2, 'reward for each rewarding execution'); 
            testCase.assertEqual(corticalProcess.planCorticalProcess.rewardPayoff, ...
                2, 'reward for each rewarding execution'); 
            testCase.assertEqual(corticalProcess.simulationCorticalProcess.numberSimulations, ...
                5, 'number of quiet awake simulations'); 
            testCase.assertEqual(corticalProcess.planCorticalProcess.numberSimulations, ...
                0, 'number of quiet awake simulations'); 
% start here
            %         simulationCorticalProcess.predictionThreshold = 0.5; 
%         steps = 70; 
%         % use what planCorticalProcess knows about motor plans to suggest one to
%         % simulate
%         simulationCorticalProcess.planCorticalProcess = planCorticalProcess; 
%         simulationCorticalProcess.usePlanCorticalProcess = 1;

        end
%         function testProcessAndUpdateResult(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             motorCortex = TestingMotorExecutions; 
%             cortex = Cortex(motorCortex);             
%             corticalProcess = TestingCorticalProcess(cortex,0.1,1,2,3); 
%             testCase.assertEqual(length(corticalProcess.results), ...
%                  0, 'no results yet'); 
%             % force the simulationsRun counter 
%             corticalProcess.simulationsRun = 4; 
%             execution = corticalProcess.process(); 
% %             disp(execution); 
%             testCase.assertEqual(length(corticalProcess.results), ...
%                  1, 'one result');                      
% %           Expecting result: 2 - (0.1 * 4) - 1 = 0.6                 
%             testCase.assertThat(corticalProcess.currentResult(), ...            
%                 IsEqualTo(0.6, 'Within', RelativeTolerance(.0000001))); 
%             % force the simulationsRun counter
%             corticalProcess.simulationsRun = 0; 
%             execution = corticalProcess.process(); 
% %             disp(execution);
%             testCase.assertEqual(length(corticalProcess.results), ...
%                  2, '2nd result');                      
% %           Expecting result: 0.6 + (0 - (0.2 * 0) - 1) = -0.4                 
%             testCase.assertThat(corticalProcess.currentResult(), ...            
%                 IsEqualTo(-0.4, 'Within', RelativeTolerance(.0000001))); 
% %             disp(corticalProcess.results);
%         end

    end
end
