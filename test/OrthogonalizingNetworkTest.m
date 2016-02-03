classdef OrthogonalizingNetworkTest < AbstractTest
    methods (Test)
        function testBuildNetwork(testCase)
            network = OrthogonalizingNetwork(10,100);
            % constructor equivalent to: 
%             network.nNeurons = 100; 
%             network.nSynapses = 10; 
            network.buildNetwork(); 
            testCase.assertEqual(network.network, zeros(10,100)); 
            testCase.assertEqual(network.nNeurons, 100); 
            testCase.assertEqual(network.nSynapses, 10); 
        end
        function testInputsPropagatedToInternalNetwork(testCase)
            network = createOrthogonalizingNetwork(10,100); 
            network.rebuildConnections = true; 
            network.buildNetwork(); 
            input = [1 1 1 1 1 0 0 0 0 0];
            fired = network.step(input); 
            testCase.assertEqual(fired, [1 0 1 0 0 0 0 1 1 1]);             
            fired2 = network.step(input); 
            testCase.assertEqual(fired2, [1 0 1 0 0 0 0 1 1 1]);             
            fired3 = network.step(input); 
            testCase.assertEqual(fired3, [1 0 1 0 0 0 0 1 1 1]);             
        end
        function testSimilarInputsActivateSimilarRandomOutputs(testCase)
            network = createOrthogonalizingNetwork(10,100); 
            input = [1 1 1 1 1 0 0 0 0 0];
            input2 = [1 0 1 1 1 0 0 0 0 0];
            input3 = [1 1 1 1 1 0 0 0 0 1];
            inputDifferent = [0 0 0 0 0 1 1 1 1 1];            
            fired = network.step(input); 
            testCase.assertEqual(fired, [1 0 0 0 0 0 1 0 1 1]);             
            fired2 = network.step(input2); 
            testCase.assertEqual(fired2, [1 0 0 0 0 0 1 0 1 1], ...
                'some inputs may not be transmitted');             
            fired3 = network.step(input3); 
            testCase.assertEqual(fired3, [1 0 0 0 0 1 1 0 1 1], ...
                'additional input bit just adds to previous input');             
            firedDifferent = network.step(inputDifferent); 
            testCase.assertEqual(firedDifferent , [0 1 0 1 0 1 0 0 0 1], ...
                'different inputs produce different outputs');             
        end
    end
end
function network = createOrthogonalizingNetwork(synapses, neurons)
    network = OrthogonalizingNetwork(synapses, neurons);    
    network.buildNetwork(); 
end
