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
            input = [1 1 1 1 1 0 0 0 0 0];
            fired = network.step(input); 
            testCase.assertEqual(fired, [1 0 1 0 0 0 0 1 1 1]);             
            
        end
    end
end
function network = createOrthogonalizingNetwork(synapses, neurons)
    network = OrthogonalizingNetwork(synapses, neurons);    
    network.buildNetwork(); 
end
