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
        function testRebuildNetworkAndGenerateFunctionFile(testCase)
            neuralNetwork = CorticalNeuralNetwork('sim',10); 
            in = [1;1;0;0]; 
            out = [0;1]; 
            in2 = [0;0;1;1]; 
            out2 = [1;0]; 
%   No network created unless there are at least two different cases
            neuralNetwork.add(in,out);
            neuralNetwork.add(in2,out2);
            net = neuralNetwork.rebuildNetwork();             
            net2 = neuralNetwork.rebuildNetwork();                         
            testCase.assertEqual(net, net2, ...
                'reset random generator each time to start from same place');             
            testCase.assertEqual(exist([neuralNetwork.neuralNetworkFunctionName,'.m'], ...
                'file'), 2, ...
                '2 = exists; function file created in current directory');             
        end

    end
end
