classdef SimulationCorticalNeuralNetworkTest < AbstractTest
    methods (Test)
        function testParsesExecutionForInputAndOutput(testCase)
            neuralNetwork = SimulationCorticalNeuralNetwork(10); 
            testCase.assertEqual(neuralNetwork.numberHiddenLayer, ...
                10, 'size of the hidden layer'); 
            [in,out] = neuralNetwork.execute([1;0;0;0;1;0;1;0]); 
            testCase.assertEqual(in, [1;0;0;0;1;0]); 
            testCase.assertEqual(out, [1;0]); 
            testCase.assertEqual(neuralNetwork.currentExecution, ...
                [1;0;0;0;1;0;1;0]);             
            [in,out] = neuralNetwork.execute([1;1;1;1;1;1;0;1]); 
            testCase.assertEqual(in, [1;1;1;1;1;1]); 
            testCase.assertEqual(out, [0;1]); 
            testCase.assertEqual(neuralNetwork.currentExecution, ...
                [1;1;1;1;1;1;0;1]);             
        end
    end
end
