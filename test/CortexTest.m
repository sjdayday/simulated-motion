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
