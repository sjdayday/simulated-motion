classdef AutoassociativeNetworkTest < AbstractTest
    methods (Test)
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
        function testShortOutputIsNonZeroIndices(testCase)
            network = createAutoassociativeNetwork(5);
            inputY = [1 0 1 0 1];  % detonator synapses
            inputX = [1 0 1 0 1]; 
            network.step(inputX, inputY); 
            testCase.assertEqual(network.outputIndices(), [1 3 5]);
            network.read(inputY); 
            testCase.assertEqual(network.outputIndices(), [1 3 5]);
            network.read([0 1 0 1 0]); 
            disp(network.outputIndices()); 
            testCase.assertEqual(network.outputIndices(), zeros(1,0));            
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
    end
end
function network = createAutoassociativeNetwork(dimension)
    network = AutoassociativeNetwork(dimension);    
    network.weightType = 'binary'; %weights are binary
    network.buildNetwork(); 
end