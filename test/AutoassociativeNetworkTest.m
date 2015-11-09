classdef AutoassociativeNetworkTest < AbstractTest
    methods (Test)
%         function testCreateHebbianNetwork(testCase)
%             network = HebbMarrNetwork(5); 
%             network.buildNetwork(); 
%             testCase.assertEqual(network.network, zeros(5,5)); 
%         end
%         function testThrowsForInvalidWeightFunction(testCase)
%             network = HebbMarrNetwork(5); 
%             network.weightType = 'fred';
%             testCase.verifyError(@network.buildNetwork,'HebbMarrNetwork:invalidWeightType'); 
%         end
%         function testThrowsIfInputsAreWrongLengthExceptInputYcanBeEmpty(testCase)
%             network = createHebbMarrNetwork(5, 5);
%             inputY = [1 1 1 1 1];  
%             inputX = [1 1];   % wrong length X
%             fh = @()network.step(inputX,inputY); 
%             testCase.verifyError(fh,'HebbMarrNetwork:stepInputsWrongLength'); 
%             inputY = [1 1];  % wrong length Y
%             inputX = [1 1 0 0 0]; 
%             fh = @()network.step(inputX,inputY); 
%             testCase.verifyError(fh,'HebbMarrNetwork:stepInputsWrongLength'); 
%             inputY = [];  
%             inputX = [1 1 0 0 0]; 
%             network.step(inputX,inputY); 
%         end
        function testIdenticalInputsAreRetrievedWhenIncompleteOrCorrupted(testCase)
            network = createAutoassociativeNetwork(5);
            inputY = [1 0 1 0 1];  % detonator synapses
            inputX = [1 0 1 0 1]; 
            fired = network.step(inputX, inputY); 
            testCase.assertEqual(fired, inputY); 
            retrieved = network.read([1 0 1 0 0]); %incomplete
            testCase.assertEqual(retrieved, inputY); 
            retrieved = network.read([1 0 1 1 0]); %corrupted
            testCase.assertEqual(retrieved, inputY);             
        end
        function testRetrievesPatternsInOriginalSequence(testCase)
            network = createAutoassociativeNetwork(6);
            testCase.assertEqual([0 0 0 0 0 0], network.getCurrentInputX());             
            inputY1 = [1 0 1 0 0 0];  % detonator synapses
            inputX = [0 0 0 0 0 0]; 
            fired = network.step(inputX, inputY1); 
            testCase.assertEqual(fired, network.getCurrentInputX()); 
%             inputX = fired; 
            inputY2 = [0 1 0 1 0 0];  % detonator synapses
            fired = network.step(inputX, inputY2); 
            testCase.assertEqual(fired, network.getCurrentInputX()); 
            inputY3 = [0 0 0 0 1 1];  % detonator synapses
            fired = network.step(inputX, inputY3); 
            testCase.assertEqual(fired, network.getCurrentInputX()); 
            retrieved = network.read(inputY1); 
            testCase.assertEqual(retrieved, inputY2);             
            retrieved = network.read(retrieved); 
            testCase.assertEqual(retrieved, inputY3);             
        end
        function testNonZeroInputXoverridesCurrentInputX(testCase)
            % .... but should it?  do we need explicit reset? 
            network = createAutoassociativeNetwork(6);
            inputY1 = [1 0 1 0 0 0];  % detonator synapses
            inputX1 = [1 0 1 0 0 0]; 
            fired = network.step(inputX1, inputY1); 
            testCase.assertEqual(fired, network.getCurrentInputX()); 
            inputY2 = [0 1 0 1 0 0];  
            inputX2 = [0 0 0 1 1 1]; 
            fired = network.step(inputX2, inputY2);             
            testCase.assertEqual(fired, inputY2); 
            retrieved = network.read(inputX2); 
            testCase.assertEqual(retrieved, inputY2);             
            retrieved = network.read(inputX1); 
            testCase.assertEqual(retrieved, inputY1); 
            % X1 associated with Y1, not Y2            
        end
        
        % when does new inputX override currentInputX?  
        % reset:  conflict between Y1 and Y2 
%         function testRetrievesZeroForZeroInputsOrForInputNotPreviouslyStored(testCase)
%             network = createHebbMarrNetwork(5, 5);
%             checkInputOutput(network, testCase, [0 0 0 0 0], [0 0 0 0 0]);
%             inputX = [1 0 0 0 0]; 
%             retrieved = network.read(inputX);
%             testCase.assertEqual(retrieved, [0 0 0 0 0]); 
%         end
%         function testRetrieveMultiplePatterns(testCase)
%             network = createHebbMarrNetwork(5, 5);
%             checkInputOutput(network, testCase, [1 1 0 0 0], [1 0 1 0 0]);
%             checkInputOutput(network, testCase, [0 1 1 0 0], [0 1 1 0 0]);
%             checkInputOutput(network, testCase, [0 0 0 1 1], [0 0 1 1 0]);
%         end
%         function testRetrievesPatternFromIncompleteInput(testCase)
%             network = createHebbMarrNetwork(5, 5);
%             inputY = [1 0 1 0 0]; 
%             checkInputOutput(network, testCase, [1 1 1 1 0], inputY);
%             inputX = [1 1 0 0 0]; 
%             retrieved = network.read(inputX);
%             testCase.assertEqual(retrieved, inputY); 
%         end
%         function testBookHeteroassociationExamples(testCase)
%             network = createHebbMarrNetwork(6, 6);
%             checkInputOutput(network, testCase, [0 0 0 1 1 1], [1 1 0 1 0 0]);  %X1,Y1
%             checkInputOutput(network, testCase, [1 0 1 0 1 0], [0 0 1 0 1 1]);  %X2,Y2
%             checkInputOutput(network, testCase, [0 0 1 0 1 1], [1 0 0 1 1 0]);  %X3,Y3
%             retrieved = network.read([0 0 1 0 0 1]);  % subset of X3
%             testCase.assertEqual(retrieved, [1 0 0 1 1 0]); % retrieves Y3 
%             % When approx 50% of synapses are on, the network is saturated
%             checkInputOutput(network, testCase, [0 1 1 1 0 0], [1 1 0 0 0 1]);  %X4,Y4
%             retrieved = network.read([0 0 1 0 1 1]);  % X3
%             testCase.assertNotEqual(retrieved, [1 0 0 1 1 0]); % not Y3 
%             testCase.assertEqual(retrieved, [1 1 0 1 1 0]); % saturated--error 
%         end
    end
end
function network = createAutoassociativeNetwork(dimension)
    network = AutoassociativeNetwork(dimension);    
    network.weightType = 'binary'; %weights are binary
    network.buildNetwork(); 
end
function checkInputOutput(network, testCase, inputX, inputY)
    network.step(inputX, inputY);
    retrieved = network.read(inputX);
    testCase.assertEqual(retrieved, inputY);             
end
