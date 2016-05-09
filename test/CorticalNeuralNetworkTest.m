classdef CorticalNeuralNetworkTest < AbstractTest
    methods (Test)
        function testCreatesCorticalNeuralNetwork(testCase)
            neuralNetwork = CorticalNeuralNetwork('test',10); 
            testCase.assertEqual(neuralNetwork.neuralNetworkFunctionName, ...
                'testNeuralNetworkFunction', 'generated function name'); 
            testCase.assertEqual(neuralNetwork.numberHiddenLayer, ...
                10, 'size of the hidden layer'); 
            neuralNetwork = CorticalNeuralNetwork('',0); 
            testCase.assertEqual(neuralNetwork.neuralNetworkFunctionName, ...
                'NeuralNetworkFunction', 'default generated function name'); 
            testCase.assertEqual(neuralNetwork.numberHiddenLayer, ...
                4, 'default size of the hidden layer'); 
        end
        function testAppendAnInputAndOutputColumnVector(testCase)
            neuralNetwork = CorticalNeuralNetwork('test',10); 
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
        function testRebuildNetworkAndGenerateFunctionFile(testCase)
            neuralNetwork = CorticalNeuralNetwork('test',10); 
            in = [1;1;0;0]; 
            out = [0;1]; 
            in2 = [0;0;1;1]; 
            out2 = [1;0]; 
%   No network created unless there are at least two different executions
            neuralNetwork.add(in,out);
            neuralNetwork.add(in2,out2);
            net = neuralNetwork.rebuildNetwork();  
%             net.IW{1} 
            net2 = neuralNetwork.rebuildNetwork();                         
%             net2.IW{1} 
            net3 = neuralNetwork.rebuildNetwork();                         
%             net3.IW{1}
%       why is net different from net2 & 3??  makes me cross-eyed...
            testCase.assertEqual(net2, net3, ...
                'reset random generator each time to start from same place');             
            testCase.assertEqual(exist([neuralNetwork.neuralNetworkFunctionName,'.m'], ...
                'file'), 2, ...
                '2 = exists; function file created in current directory');  
            % neuralNetworkFunctionName should include .m
        end

    end
end
