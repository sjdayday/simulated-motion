classdef PlanCorticalProcessTest < AbstractTest
    methods (Test)
        function testInitializeIncludingUniformPlanWeights(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex);  
%             cortex.loadNetworks(20); 
            corticalProcess = PlanCorticalProcess(cortex,1,2);
            testCase.assertEqual(corticalProcess.physicalCost, 1); 
            testCase.assertEqual(corticalProcess.rewardPayoff, 2);
            testCase.assertEqual(corticalProcess.planWeights('FoundRewardAway'), ...
                [0.25,0.25,0.25,0.25], 'defaults to uniform distribution'); 
            testCase.assertEqual(corticalProcess.planWeights('FoundRewardHome'), ...
                [0.25,0.25,0.25,0.25], 'defaults to uniform distribution'); 
            testCase.assertEqual(corticalProcess.representationMap('FoundRewardAway'), ...
                [1;0;1;0], 'FRA + rewarding'); 
            testCase.assertEqual(corticalProcess.representationMap('FoundRewardHome'), ...
                [0;1;1;0], 'FRH + rewarding'); 
        end
        function testPlanWeightsAssociatedWithCurrentRepresentationPlusReward(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex);  
            cortex.loadNetworks(20); 
            corticalProcess = PlanCorticalProcess(cortex,1,2);            
            corticalProcess.currentRepresentation = 'FoundRewardAway';
            execution = corticalProcess.process(); 
            weights = corticalProcess.weightMap('FoundRewardAway'); 
            testCase.assertThat(weights, ...            
                IsEqualTo([0.25,0.1250,0.6250,0], 'Within', AbsoluteTolerance(.01))); 
          
%                         testCase.assertEqual(in, [1;0;1;0]); 
%             testCase.assertEqual(out, [0;0;1;0]); 
%             testCase.assertEqual(neuralNetwork.currentExecution, ...
%                 [1;0;0;0;1;0;1;0]);             
%             [in,out] = neuralNetwork.execute([1;1;1;1;1;1;0;1]); 
%             testCase.assertEqual(in, [1;1;0;1]); 
%             testCase.assertEqual(out, [1;1;1;1]); 
%             testCase.assertEqual(neuralNetwork.currentExecution, ...
%                 [1;1;1;1;1;1;0;1]);             

            
%             corticalProcess.tolerance = 1; % no simulations will be skipped
%             testCase.assertEqual(length(corticalProcess.results), ...
%                  0, 'no results yet'); 
%             execution = corticalProcess.process(); 
%             simulations = corticalProcess.simulations; 
%             testCase.assertEqual(size(corticalProcess.simulations,2), 5);                      
%             testCase.assertEqual(corticalProcess.simulations, ...
%                  [1,0,1,1,0;
%                   0,1,0,0,1;
%                   0,0,0,0,1;
%                   0,0,1,0,0;
%                   0,0,0,1,0;
%                   1,1,0,0,0;
%                   0,1,1,1,0;
%                   1,0,0,0,1]);                      
%             testCase.assertThat(corticalProcess.predictions, ...            
%                 IsEqualTo([0,0,0.5,1,0;1,1,0.5,0,1], 'Within', AbsoluteTolerance(.1))); 
% %             disp(corticalProcess.results);
%             testCase.assertEqual(length(corticalProcess.results), ...
%                  1, 'one result');                      
        end
%         function testExecutedMotorPlanDrawnFromWeightedRandomSample(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             import matlab.unittest.constraints.AbsoluteTolerance
%             motorCortex = TestingMotorExecutions; 
%             cortex = Cortex(motorCortex);  
% % %             cortex.loadNetworks(20); 
% % %             corticalProcess = PlanCorticalProcess(cortex,1,2);
% % %             testCase.assertEqual(corticalProcess.physicalCost, 1); 
% % %             testCase.assertEqual(corticalProcess.rewardPayoff, 2);
% % %               testCase.assertThat(corticalProcess.planWeights, ...            
% % %                 IsEqualTo([0.25,0.1250,0.6250,0], 'Within', AbsoluteTolerance(.01))); 
%           
% %                         testCase.assertEqual(in, [1;0;1;0]); 
% %             testCase.assertEqual(out, [0;0;1;0]); 
% %             testCase.assertEqual(neuralNetwork.currentExecution, ...
% %                 [1;0;0;0;1;0;1;0]);             
% %             [in,out] = neuralNetwork.execute([1;1;1;1;1;1;0;1]); 
% %             testCase.assertEqual(in, [1;1;0;1]); 
% %             testCase.assertEqual(out, [1;1;1;1]); 
% %             testCase.assertEqual(neuralNetwork.currentExecution, ...
% %                 [1;1;1;1;1;1;0;1]);             
% 
%             
% %             corticalProcess.tolerance = 1; % no simulations will be skipped
% %             testCase.assertEqual(length(corticalProcess.results), ...
% %                  0, 'no results yet'); 
% %             execution = corticalProcess.process(); 
% %             simulations = corticalProcess.simulations; 
% %             testCase.assertEqual(size(corticalProcess.simulations,2), 5);                      
% %             testCase.assertEqual(corticalProcess.simulations, ...
% %                  [1,0,1,1,0;
% %                   0,1,0,0,1;
% %                   0,0,0,0,1;
% %                   0,0,1,0,0;
% %                   0,0,0,1,0;
% %                   1,1,0,0,0;
% %                   0,1,1,1,0;
% %                   1,0,0,0,1]);                      
% %             testCase.assertThat(corticalProcess.predictions, ...            
% %                 IsEqualTo([0,0,0.5,1,0;1,1,0.5,0,1], 'Within', AbsoluteTolerance(.1))); 
% % %             disp(corticalProcess.results);
% %             testCase.assertEqual(length(corticalProcess.results), ...
% %                  1, 'one result');                      
%         end

    end
end
