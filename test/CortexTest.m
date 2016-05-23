classdef CortexTest < AbstractTest
    methods (Test)
        function testCortexInitialization(testCase)
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex); 
            testCase.assertClass(cortex.simulationNeuralNetwork, ...
                'SimulationCorticalNeuralNetwork'); 
            testCase.assertClass(cortex.planNeuralNetwork, ...
                'PlanCorticalNeuralNetwork');            
            testCase.assertEqual(length(cortex.motorCortex.testingExecutions), ...
                1600, 'number of test executions'); 
        end
        function testDrawRandomExecution(testCase)
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex); 
            execution = cortex.randomMotorExecution(); 
            testCase.assertEqual(execution, [1;0;0;0;1;0;1;0]);             
        end
        function testRandomDrawByPartialInput(testCase)
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex); 
            execution = cortex.randomDrawByPartialInput([1;0]); 
            testCase.assertEqual(execution, [1;0;0;0;1;0;1;0]);             
%             disp(execution); 
            execution = cortex.randomDrawByPartialInput([0;1]); 
%             disp(execution); 
            testCase.assertEqual(execution, [0;1;0;1;0;0;0;1]); 
        end        
        function testLoadExecutionsAndBuildNetwork(testCase)
            % FIXME:  weights vary depending on side effects, e.g, other
            % tests
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex); 
            cortex.loadNetworks(20); 
            testCase.assertEqual( ... 
                length(cortex.simulationNeuralNetwork.executions), 20);
            netWeights = cortex.simulationNeuralNetwork.network.IW{1}; 
            testCase.assertThat(netWeights(1,1), ...            
                IsEqualTo(1.5636, 'Within', RelativeTolerance(.0001))); 
%                 IsEqualTo(-1.24078, 'Within', RelativeTolerance(.0001)));             
            
%             disp(netWeights); 
        end
        function testRebuildNetworksSinglyOrAllAtOnce(testCase)
            motorCortex = TestingMotorExecutions; 
            cortex = Cortex(motorCortex); 
            testCase.assertEqual(cortex.simulationNetworkRebuildCount, 0);
            testCase.assertEqual(cortex.planNetworkRebuildCount, 0);            
            cortex.loadNetworks(10); 
            testCase.assertEqual(cortex.simulationNetworkRebuildCount, 1);
            testCase.assertEqual(cortex.planNetworkRebuildCount, 1);            
            cortex.simulationRebuild(); 
            testCase.assertEqual(cortex.simulationNetworkRebuildCount, 2);
            testCase.assertEqual(cortex.planNetworkRebuildCount, 1);            
            cortex.planRebuild(); 
            testCase.assertEqual(cortex.simulationNetworkRebuildCount, 2);
            testCase.assertEqual(cortex.planNetworkRebuildCount, 2);   
            cortex.rebuildAll(); 
            testCase.assertEqual(cortex.simulationNetworkRebuildCount, 3);
            testCase.assertEqual(cortex.planNetworkRebuildCount, 3);   
        end
        % TODO: consider executing network calls rebuildAll()

    end
end
