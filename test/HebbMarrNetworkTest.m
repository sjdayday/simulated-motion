classdef HebbMarrNetworkTest < AbstractTest
    methods (Test)
        function testCreateHebbianNetwork(testCase)
            % testOnlyFiredSynapsesStrengthened
%             load 'testHebbianNetwork' expectedFirings;
            network = HebbMarrNetwork(); 
            network.buildNetwork(); 
            testCase.assertEqual(network.network, zeros(4,2)); 

            network = HebbMarrNetwork(); 
            % override parameters here.
            network.nNeurons = 5; 
            network.nSynapses = 10; 
            network.buildNetwork(); 
            testCase.assertEqual(network.network, zeros(10,5)); 
        end
        function testCreatesWeightFunction(testCase)
            network = HebbMarrNetwork(); 
            network.weightType = 'fred';
%             networkHandle = @network.buildNetwork; 
            testCase.verifyError(@network.buildNetwork,'HebbMarrNetwork:invalidWeightType'); 
%             network.buildNetwork(); 
%             testCase.assertEqual(network.errorMessage, 'Invalid weight type: fred\n'); 
%             network = HebbMarrNetwork(); 
%             network.weightType = 'binary'; 
%             network.buildNetwork(); 
        end
        function testThrowsIfInputsAreWrongLengthExceptInputYcanBeEmpty(testCase)
            network = HebbMarrNetwork();    
            network.nNeurons = 5; 
            network.nSynapses = 10; 
            network.weightType = 'binary'; %weights are binary
            network.buildNetwork(); 
            inputY = [1 1 1 1 1];  
            inputX = [1 1];   % wrong length X
            fh = @()network.step(inputX,inputY); 
            testCase.verifyError(fh,'HebbMarrNetwork:stepInputsWrongLength'); 
            inputY = [1 1];  % wrong length Y
            inputX = [1 1 0 0 0 0 0 0 0 0 ]; 
            fh = @()network.step(inputX,inputY); 
            testCase.verifyError(fh,'HebbMarrNetwork:stepInputsWrongLength'); 
            inputY = [];  
            inputX = [1 1 0 0 0 0 0 0 0 0 ]; 
            network.step(inputX,inputY); 
        end
        function testInputYcausesWeightsToBeUpdatedAndOutputsSameAsInputY(testCase)
            network = HebbMarrNetwork();    
            network.nNeurons = 5; 
            network.nSynapses = 10; 
            network.weightType = 'binary'; %weights are binary
            network.buildNetwork(); 
            inputY = [1 0 1 0 0];  % detonator synapses
            inputX = [1 1 0 0 0 0 0 0 0 0]; 
            fired = network.step(inputX, inputY); 
            testCase.assertEqual(fired, inputY); 
            expectedNetwork = zeros(10,5); 
            expectedNetwork(1,1) = 1; 
            expectedNetwork(2,1) = 1; 
            expectedNetwork(1,3) = 1; 
            expectedNetwork(2,3) = 1; 
            testCase.assertEqual(network.network, expectedNetwork);             
        end
        function testRetrievesStoredPattern(testCase)
            network = HebbMarrNetwork();    
            network.nNeurons = 5; 
            network.nSynapses = 10; 
            network.weightType = 'binary'; %weights are binary
            network.buildNetwork(); 
            inputY = [1 0 1 0 0];  % detonator synapses
            inputX = [1 1 0 0 0 0 0 0 0 0]; 
            network.step(inputX, inputY); 
            retrieved = network.read(inputX);
            testCase.assertEqual(retrieved, inputY); 
        end
        function testRetrievesZeroForZeroInputsOrForInputNotPreviouslyStored(testCase)
            network = HebbMarrNetwork();    
            network.nNeurons = 5; 
            network.nSynapses = 10; 
            network.weightType = 'binary'; %weights are binary
            network.buildNetwork(); 
            expected = [0 0 0 0 0]; 
            inputX = [0 0 0 0 0 0 0 0 0 0]; 
            retrieved = network.read(inputX);
            testCase.assertEqual(retrieved, expected); 
            inputX = [1 0 0 0 0 0 0 0 0 0]; 
            retrieved = network.read(inputX);
            testCase.assertEqual(retrieved, expected); 
        end
        function testRetrieveMultiplePatterns(testCase)
            network = HebbMarrNetwork();    
            network.nNeurons = 5; 
            network.nSynapses = 10; 
            network.weightType = 'binary'; %weights are binary
            network.buildNetwork(); 
            inputY1 = [1 0 1 0 0];  % detonator synapses
            inputX1 = [1 1 0 0 0 0 0 0 0 0]; 
            network.step(inputX1, inputY1); 
            inputY2 = [0 1 1 0 0];  % detonator synapses
            inputX2 = [0 1 1 0 0 0 0 0 0 0]; 
            network.step(inputX2, inputY2); 
            inputY3 = [0 0 1 1 0];  % detonator synapses
            inputX3 = [0 0 0 1 1 0 0 0 0 0]; 
            network.step(inputX3, inputY3); 
            testCase.assertEqual(network.read(inputX1), inputY1); 
            testCase.assertEqual(network.read(inputX2), inputY2); 
            testCase.assertEqual(network.read(inputX3), inputY3); 
        end
        function testRetrievesPatternFromIncompleteInput(testCase)
            network = createHebbMarrNetwork();
            inputY = [1 0 1 0 0]; 
            checkInputOutput(network, testCase, [1 1 1 1 0 0 0 0 0 0], inputY);

%             inputX = [1 1 1 1 0 0 0 0 0 0]; 
%             network.step(inputX, inputY); 
            inputX = [1 1 0 0 0 0 0 0 0 0]; 
            retrieved = network.read(inputX);
            testCase.assertEqual(retrieved, inputY); 
        end
    end
end
function network = createHebbMarrNetwork()
    network = HebbMarrNetwork();    
    network.nNeurons = 5; 
    network.nSynapses = 10; 
    network.weightType = 'binary'; %weights are binary
    network.buildNetwork(); 
end
function checkInputOutput(network, testCase, inputX, inputY)
    network.step(inputX, inputY);
    retrieved = network.read(inputX);
    testCase.assertEqual(retrieved, inputY);             
end
