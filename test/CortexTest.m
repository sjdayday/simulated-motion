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
        
            % force the simulationsRun counter

%             testCase.assertEqual(neuralNetwork.outputLength(), ...
%                 0, 'length of the output vector');             
%             in = [1;1;0;0]; 
%             out = [0;1]; 
%             neuralNetwork.add(in,out);
%             testCase.assertEqual(neuralNetwork.inputLength(), ...
%                 1, 'length of the input vector');             
%             testCase.assertEqual(neuralNetwork.outputLength(), ...
%                 1, 'length of the output vector');             
%             neuralNetwork.add(in,out);
%             testCase.assertEqual(neuralNetwork.inputLength(), ...
%                 2, 'length of the input vector');             
%             testCase.assertEqual(neuralNetwork.outputLength(), ...
%                 2, 'length of the output vector');             
%         end
%         function testInputAndOutputConstituteSingleExecution(testCase)
%             neuralNetwork = CorticalNeuralNetwork('sim',10); 
%             in = [1;1;0;0]; 
%             out = [0;1]; 
%             neuralNetwork.add(in,out);
%             testCase.assertEqual(neuralNetwork.currentExecution, ...
%                 [1;1;0;0;0;1], 'append [in;out]');             
%             in = [2;1;0;0]; 
%             out = [0;2]; 
%             neuralNetwork.add(in,out);
%             testCase.assertEqual(neuralNetwork.currentExecution, ...
%                 [2;1;0;0;0;2], 'append [in;out]');             
%         end
%         function testRebuildNetworkAndGenerateFunctionFile(testCase)
%             neuralNetwork = CorticalNeuralNetwork('sim',10); 
%             in = [1;1;0;0]; 
%             out = [0;1]; 
%             in2 = [0;0;1;1]; 
%             out2 = [1;0]; 
% %   No network created unless there are at least two different cases
%             neuralNetwork.add(in,out);
%             neuralNetwork.add(in2,out2);
%             net = neuralNetwork.rebuildNetwork();             
%             net2 = neuralNetwork.rebuildNetwork();                         
%             testCase.assertEqual(net, net2, ...
%                 'reset random generator each time to start from same place');             
%             testCase.assertEqual(exist([neuralNetwork.neuralNetworkFunctionName,'.m'], ...
%                 'file'), 2, ...
%                 '2 = exists; function file created in current directory');             
%         end

    end
end
