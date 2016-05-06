classdef CorticalNeuralNetworkTest < AbstractTest
    methods (Test)
        function testCreatesCorticalNeuralNetwork(testCase)
            neuralNetwork = CorticalNeuralNetwork('sim',10); 
            testCase.assertEqual(neuralNetwork.neuralNetworkFunctionName, ...
                'simNeuralNetworkFunction', 'generated function name'); 
            testCase.assertEqual(neuralNetwork.numberHiddenLayer, ...
                10, 'size of the hidden layer'); 
            neuralNetwork = CorticalNeuralNetwork('',0); 
            testCase.assertEqual(neuralNetwork.neuralNetworkFunctionName, ...
                'NeuralNetworkFunction', 'default generated function name'); 
            testCase.assertEqual(neuralNetwork.numberHiddenLayer, ...
                4, 'default size of the hidden layer'); 
        end
        function testAppendAnInputAndOutputColumnVector(testCase)
            neuralNetwork = CorticalNeuralNetwork('sim',10); 
            testCase.assertEqual(neuralNetwork.inputLength(), ...
                0, 'length of the input vector');             
            testCase.assertEqual(neuralNetwork.outputLength(), ...
                0, 'length of the output vector');             
            in = [1;1;0;0]; 
            out = [0;1]; 
            neuralNetwork.add(in,out);
            testCase.assertEqual(neuralNetwork.inputLength(), ...
                1, 'length of the input vector');             
            testCase.assertEqual(neuralNetwork.outputLength(), ...
                1, 'length of the output vector');             
            neuralNetwork.add(in,out);
            testCase.assertEqual(neuralNetwork.inputLength(), ...
                2, 'length of the input vector');             
            testCase.assertEqual(neuralNetwork.outputLength(), ...
                2, 'length of the output vector');             
        end
        function testInputAndOutputConstituteSingleExecution(testCase)
            neuralNetwork = CorticalNeuralNetwork('sim',10); 
            in = [1;1;0;0]; 
            out = [0;1]; 
            neuralNetwork.add(in,out);
            testCase.assertEqual(neuralNetwork.currentExecution, ...
                [1;1;0;0;0;1], 'append [in;out]');             
            in = [2;1;0;0]; 
            out = [0;2]; 
            neuralNetwork.add(in,out);
            testCase.assertEqual(neuralNetwork.currentExecution, ...
                [2;1;0;0;0;2], 'append [in;out]');             
        end

    end
end
