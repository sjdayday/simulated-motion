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
            testCase.assertEqual(fired, [0 0 0 0 0 0 0 0 1 0]);             
            fired2 = network.step(input2); 
            testCase.assertEqual(fired2, [0 0 0 0 0 0 0 0 1 0]);             
            fired3 = network.step(input3); 
            testCase.assertEqual(fired3, [0 0 0 0 0 0 1 0 0 0]);             
            firedDifferent = network.step(inputDifferent); 
            testCase.assertEqual(firedDifferent, [0 0 0 0 1 0 0 0 0 0]);             
        end
%         buildSparseVector(obj, sparseInput)
        function testBuildSparseVectorFromOneOrTwoInputs(testCase)
            network = createOrthogonalizingNetwork(10,100); 
            sparseVector = network.buildSparseVector([3]);
            testCase.assertEqual(sparseVector, [0 0 0 1 0 0 0 0 0 0]);             
            sparseVector = network.buildSparseVector([3 8]);
            testCase.assertEqual(sparseVector, [0 0 0 1 0 0 0 0 1 0]);             
            sparseVector = network.buildSparseVector([3 3]);
            testCase.assertEqual(sparseVector, [0 0 0 1 0 0 0 0 0 0]);             
        end
        function testIfLecIsZerosOnlyBuildOneDigitPlace(testCase)
            network = createOrthogonalizingNetwork(10,100); 
            network.nMEC = 5;        
            network.separateMecLec = true; 
            sparseInput = network.buildSparseInput([0 0 0 1 0 0 0 0 0 1]);            
%             disp(['size: ',mat2str(size(sparseInput)),mat2str(sparseInput)]); 
            testCase.assertEqual(sparseInput, [9 7], ...
                'both parts of input non-zero, so two digits');             
            sparseInput = network.buildSparseInput([0 0 0 1 0 0 0 0 0 0]);            
            testCase.assertEqual(sparseInput, [9], ...
                'LEC part of input is zero, so only one digit');             
        end
        function testSimilarInputsForMecOrLecActivateTwoSparseRandomOutputs(testCase)
            network = createOrthogonalizingNetwork(10,100); 
            network.sparse = true; 
            network.nMEC = 5; 
            network.separateMecLec = true; 
            input =  [1 0 1 1 0 1 0 0 0 0];
            input2 = [1 0 1 1 0 0 1 0 0 0];
            input3 = [1 0 1 1 0 1 0 0 0 1];
            input4 = [0 0 0 0 1 1 0 0 0 1];            
            fired = network.step(input); 
            testCase.assertEqual(fired, [0 0 0 0 0 0 0 1 1 0]);             
            fired2 = network.step(input2); 
            testCase.assertEqual(fired2, [0 0 0 0 0 0 0 0 1 1], ...
                'MEC same (9), LEC different, so one digit same');             
            fired3 = network.step(input3); 
            testCase.assertEqual(fired3, [0 0 0 0 1 0 0 0 1 0], ...
                'MEC still same (9), LEC different');             
            fired4 = network.step(input4); 
            testCase.assertEqual(fired4, [0 0 0 0 1 0 0 1 0 0], ...
                'MEC different, LEC same as previous');             
        end
        function testCreateSparseOutputUsingLowDigitsOfSin(testCase)
            network = OrthogonalizingNetwork(10, 100);    
            network.sparse = true; 
            network.buildNetwork();             
            input = [1 1 1 1 0 0 0 0 1 0];
            sparseInput = network.buildSparseInput(input); 
            testCase.assertEqual(sparseInput, 0);
            testCase.assertEqual(network.buildSparseVector(sparseInput) , [1 0 0 0 0 0 0 0 0 0]);
            input = [1 1 1 1 1 0 0 0 1 0];
            sparseInput = network.buildSparseInput(input); 
            testCase.assertEqual(sparseInput, 8);             
            testCase.assertEqual(network.buildSparseVector(sparseInput) , [0 0 0 0 0 0 0 0 1 0], ...
            '1-based indexing so 0 is 1');
            input = [0 0 0 0 0 0 0 0 1 0];
            sparseInput = network.buildSparseInput(input); 
            testCase.assertEqual(sparseInput, 1);             
            testCase.assertEqual(network.buildSparseVector(sparseInput) , [0 1 0 0 0 0 0 0 0 0]);
            input = [0 0 0 0 0 0 0 0 0 1];
            sparseInput = network.buildSparseInput(input); 
            testCase.assertEqual(sparseInput, 7);             
            testCase.assertEqual(network.buildSparseVector(sparseInput) , [0 0 0 0 0 0 0 1 0 0]);
            input = [0 0 0 0 0 0 0 0 0 0];
            sparseInput = network.buildSparseInput(input); 
            testCase.assertEqual(sparseInput, 0);             
            testCase.assertEqual(network.buildSparseVector(sparseInput) , [1 0 0 0 0 0 0 0 0 0]);
        end
        
    end
end
function network = createOrthogonalizingNetwork(synapses, neurons)
    network = OrthogonalizingNetwork(synapses, neurons);    
    network.buildNetwork(); 
end
