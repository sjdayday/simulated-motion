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
            corticalProcess.simulationPredictionThreshold = 0.5;
            corticalProcess.usePlanCorticalProcess = 1;
            
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
            testCase.assertEqual(corticalProcess.simulationCorticalProcess.predictionThreshold, ...
                0.5, 'threshold above which the probability of a predicted reward is treated as high enough to select'); 
            testCase.assertEqual(corticalProcess.simulationCorticalProcess.usePlanCorticalProcess, ...
                1, 'planCorticalProcess to be used during simulation'); 
            testCase.assertClass(corticalProcess.simulationCorticalProcess.planCorticalProcess, ... 
                'PlanCorticalProcess');             

        end
        function testCurrentRepresentationDrivesBothProcesses(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex);  
            cortex.loadNetworks(20);             
            corticalProcess = CombinedCorticalProcess(cortex);
            corticalProcess.simulationCost = 0.1;
            corticalProcess.physicalCost = 1;
            corticalProcess.rewardPayoff = 2;            
            corticalProcess.numberSimulations = 5; 
            corticalProcess.simulationPredictionThreshold = 0.5;
            corticalProcess.usePlanCorticalProcess = 1;
            
            corticalProcess.build(); 
            testCase.assertEqual(length(... 
                corticalProcess.planCorticalProcess.results), 0, 'no results yet'); 
            testCase.assertEqual(length(... 
                corticalProcess.simulationCorticalProcess.results), 0, 'no results yet'); 
            
            corticalProcess.currentRepresentation = 'FoundRewardAway';
            corticalProcess.process();    
            testCase.assertEqual(length(... 
                corticalProcess.planCorticalProcess.results), 1, ... 
                'both processes now have results'); 
            testCase.assertEqual(length(... 
                corticalProcess.simulationCorticalProcess.results), 1, ... 
                'both processes now have results'); 
        end
        function testTracksCostOfSimulationRelativeToPlan(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex);  
            cortex.loadNetworks(20);             
            corticalProcess = CombinedCorticalProcess(cortex);
            corticalProcess.simulationCost = 0.1;
            corticalProcess.physicalCost = 1;
            corticalProcess.rewardPayoff = 2;            
            corticalProcess.numberSimulations = 5; 
            corticalProcess.simulationPredictionThreshold = 0.5;
            corticalProcess.usePlanCorticalProcess = 1;
            
            corticalProcess.build(); 
            corticalProcess.currentRepresentation = 'FoundRewardAway';
            corticalProcess.process();    
            testCase.assertThat(corticalProcess.planCorticalProcess.results(end), ...            
                IsEqualTo(1.0, 'Within', RelativeTolerance(.0000001))); 
            testCase.assertThat(corticalProcess.simulationCorticalProcess.results(end), ...            
                IsEqualTo(0.9, 'Within', RelativeTolerance(.0000001))); 
            testCase.assertThat(corticalProcess.results(end), ...            
                IsEqualTo(-0.1, 'Within', RelativeTolerance(.0000001))); 
            testCase.assertThat(corticalProcess.totalCost, ...            
                IsEqualTo(-0.1, 'Within', RelativeTolerance(.0000001))); 
            corticalProcess.currentRepresentation = 'FoundRewardHome';
            corticalProcess.process();    
            testCase.assertThat(corticalProcess.planCorticalProcess.results(end), ...            
                IsEqualTo(-1.0, 'Within', RelativeTolerance(.0000001))); 
            testCase.assertThat(corticalProcess.simulationCorticalProcess.results(end), ...            
                IsEqualTo(-1.5, 'Within', RelativeTolerance(.0000001))); 
            testCase.assertThat(corticalProcess.results(end), ...            
                IsEqualTo(-0.5, 'Within', RelativeTolerance(.0000001))); 
            testCase.assertThat(corticalProcess.meanCost(), ...            
                IsEqualTo(-0.3, 'Within', RelativeTolerance(.0000001))); 
            testCase.assertThat(corticalProcess.totalCost, ...            
                IsEqualTo(-0.6, 'Within', RelativeTolerance(.0000001))); 
%             disp(corticalProcess.planCorticalProcess.results(end)); 
%             disp(corticalProcess.simulationCorticalProcess.results(end));             
%             disp(corticalProcess.results(end));
%  cumulativeResults:  total.  results:  single trials:  meanCost is what
%  is tracked.    
        end

    end
end
