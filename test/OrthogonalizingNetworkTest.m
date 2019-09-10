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
        function testSimilarInputsActivateSparseRandomOutputs(testCase)
            network = createOrthogonalizingNetwork(10,100); 
            network.sparse = true; 
            input =  [1 1 1 1 0 0 0 0 0 0];
            input2 = [1 0 1 1 0 0 0 0 0 0];
            input3 = [1 1 1 1 0 0 0 0 0 1];
            inputDifferent = [0 0 0 0 0 1 1 1 1 0];            
            fired = network.step(input); 
            testCase.assertEqual(fired, [0 0 0 0 1 0 0 0 0 0]);             
            fired2 = network.step(input2); 
            testCase.assertEqual(fired2, [0 0 1 0 0 0 0 0 0 0]);             
            fired3 = network.step(input3); 
            testCase.assertEqual(fired3, [1 0 0 0 0 0 0 0 0 0]);             
            firedDifferent = network.step(inputDifferent); 
            testCase.assertEqual(firedDifferent, [0 0 0 0 1 0 0 0 0 0]);             
        end
        function testCreateSparseOutputAsProductOfInputsModuloNumberOfSynapses(testCase)
            network = OrthogonalizingNetwork(10, 100);    
            network.sparse = true; 
            network.buildNetwork();             
            input = [1 1 1 1 0 0 0 0 1 0];
            sparseInput = network.buildSparseInput(input); 
            testCase.assertEqual(sparseInput, 6, ...
                '1 * 2 * 3 * 4 * 9 = 216, modulo 10 ');
            testCase.assertEqual(network.buildSparseVector(sparseInput) , [0 0 0 0 0 0 1 0 0 0], ...
            '1-based indexing, so 7');
            input = [1 1 1 1 1 0 0 0 1 0];
            sparseInput = network.buildSparseInput(input); 
            testCase.assertEqual(sparseInput, 0, ...
                '1 * 2 * 3 * 4 * 5 * 9 = 1080, modulo 10 ');             
            testCase.assertEqual(network.buildSparseVector(sparseInput) , [1 0 0 0 0 0 0 0 0 0], ...
            '1-based indexing so 0 is 1');
            input = [0 0 0 0 0 0 0 0 1 0];
            sparseInput = network.buildSparseInput(input); 
            testCase.assertEqual(sparseInput, 9, ...
                '9 = 9, modulo 10 ');             
            testCase.assertEqual(network.buildSparseVector(sparseInput) , [0 0 0 0 0 0 0 0 0 1], ...
            '1-based indexing, so 10');
            input = [0 0 0 0 0 0 0 0 0 1];
            sparseInput = network.buildSparseInput(input); 
            testCase.assertEqual(sparseInput, 0, ...
                '10, modulo 10 ');             
            testCase.assertEqual(network.buildSparseVector(sparseInput) , [1 0 0 0 0 0 0 0 0 0]);
            input = [0 0 0 0 0 0 0 0 0 0];
            sparseInput = network.buildSparseInput(input); 
            testCase.assertEqual(sparseInput, 0, ...
                '0, modulo 10 ');             
            testCase.assertEqual(network.buildSparseVector(sparseInput) , [1 0 0 0 0 0 0 0 0 0]);
        end
        
    end
end
function network = createOrthogonalizingNetwork(synapses, neurons)
    network = OrthogonalizingNetwork(synapses, neurons);    
    network.buildNetwork(); 
end
