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
            corticalProcess.process(); 
            weights = corticalProcess.weightMap('FoundRewardAway'); 
            testCase.assertThat(weights, ...            
                IsEqualTo([0.25,0.1250,0.6250,0], 'Within', AbsoluteTolerance(.01))); 
        end
        function testExecutedMotorPlanDrawnFromWeightedRandomSample(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex);  
            cortex.loadNetworks(20); 
            testCase.assertEqual(cortex.planNetworkRebuildCount, 1);                                                          
            corticalProcess = PlanCorticalProcess(cortex,1,2);
            corticalProcess.currentRepresentation = 'FoundRewardAway';   
            execution = corticalProcess.process(); 
            testCase.assertEqual(cortex.planNetworkRebuildCount, 2);                                              
            testCase.assertEqual(corticalProcess.motorPlan, 3);
            testCase.assertEqual(execution, [1;0;0;0;1;0;1;0]);             
            testCase.assertThat(corticalProcess.totalCost, ...            
                IsEqualTo(1.0, 'Within', RelativeTolerance(.0000001))); 
        end
        function testAddArbitraryRepresentationEntry(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex);  
            corticalProcess = PlanCorticalProcess(cortex,1,2);
            testCase.assertEqual(corticalProcess.planWeights('FoundRewardAway'), ...
                [0.25,0.25,0.25,0.25], 'defaults to uniform distribution'); 
            testCase.assertEqual(corticalProcess.representationMap('FoundRewardAway'), ...
                [1;0;1;0], 'FRA + rewarding');             
            corticalProcess.addRepresentationEntry('A', [1;0;0]);
            corticalProcess.addRepresentationEntry('FoundRewardAway', [0;1;1]);
            testCase.assertEqual(corticalProcess.representationMap('A'), ...
                [1;0;0], 'new vector');             
            testCase.assertThat(corticalProcess.planWeights('A'), ...            
                IsEqualTo([0.33,0.33,0.33], 'Within', AbsoluteTolerance(.01))); 
            testCase.assertEqual(corticalProcess.representationMap('FoundRewardAway'), ...
                [0;1;1], 'override previous vector');             
            testCase.assertThat(corticalProcess.planWeights('FoundRewardAway'), ...            
                IsEqualTo([0.33,0.33,0.33], 'Within', AbsoluteTolerance(.01))); 
        end
        function testDrawForArbitraryNumberOfMotorPlans(testCase)
            % start here
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             import matlab.unittest.constraints.AbsoluteTolerance
%             motorCortex = TestingMotorExecutions; 
%             cortex = Cortex(motorCortex);  
%             corticalProcess = PlanCorticalProcess(cortex,1,2);
%             testCase.assertEqual(corticalProcess.planWeights('FoundRewardAway'), ...
%                 [0.25,0.25,0.25,0.25], 'defaults to uniform distribution'); 
%             testCase.assertEqual(corticalProcess.representationMap('FoundRewardAway'), ...
%                 [1;0;1;0], 'FRA + rewarding');             
%             corticalProcess.addRepresentationEntry('A', [1;0;0]);
%             corticalProcess.addRepresentationEntry('FoundRewardAway', [0;1;1]);
%             testCase.assertEqual(corticalProcess.representationMap('A'), ...
%                 [1;0;0], 'new vector');             
%             testCase.assertThat(corticalProcess.planWeights('A'), ...            
%                 IsEqualTo([0.33,0.33,0.33], 'Within', AbsoluteTolerance(.01))); 
%             testCase.assertEqual(corticalProcess.representationMap('FoundRewardAway'), ...
%                 [0;1;1], 'override previous vector');             
%             testCase.assertThat(corticalProcess.planWeights('FoundRewardAway'), ...            
%                 IsEqualTo([0.33,0.33,0.33], 'Within', AbsoluteTolerance(.01))); 
        end
    end
end
