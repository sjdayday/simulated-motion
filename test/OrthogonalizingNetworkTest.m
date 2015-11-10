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
            testCase.assertEqual(fired, [1 1 1 0 0 0 0 1 1 0]);             
%             testCase.assertEqual(sum(sum(network.network)), 5);             
            
        end
%         function testThrowsIfInputsAreWrongLengthExceptInputYcanBeEmpty(testCase)
%             network = createHebbMarrNetwork(5);
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
%         function testInputYcausesWeightsToBeUpdatedAndOutputsSameAsInputY(testCase)
%             network = createHebbMarrNetwork(5);
%             inputY = [1 0 1 0 0];  % detonator synapses
%             inputX = [1 1 0 0 0]; 
%             fired = network.step(inputX, inputY); 
%             testCase.assertEqual(fired, inputY); 
%             expectedNetwork = zeros(5,5); 
%             expectedNetwork(1,1) = 1; 
%             expectedNetwork(2,1) = 1; 
%             expectedNetwork(1,3) = 1; 
%             expectedNetwork(2,3) = 1; 
%             testCase.assertEqual(network.network, expectedNetwork);             
%         end
%         function testRetrievesStoredPattern(testCase)
%             network = createHebbMarrNetwork(5);
%             checkInputOutput(network, testCase, [1 1 0 0 0], [1 0 1 0 0]);
%         end
%         function testRetrievesZeroForZeroInputsOrForInputNotPreviouslyStored(testCase)
%             network = createHebbMarrNetwork(5);
%             checkInputOutput(network, testCase, [0 0 0 0 0], [0 0 0 0 0]);
%             inputX = [1 0 0 0 0]; 
%             retrieved = network.read(inputX);
%             testCase.assertEqual(retrieved, [0 0 0 0 0]); 
%         end
%         function testRetrieveMultiplePatterns(testCase)
%             network = createHebbMarrNetwork(5);
%             checkInputOutput(network, testCase, [1 1 0 0 0], [1 0 1 0 0]);
%             checkInputOutput(network, testCase, [0 1 1 0 0], [0 1 1 0 0]);
%             checkInputOutput(network, testCase, [0 0 0 1 1], [0 0 1 1 0]);
%         end
%         function testRetrievesPatternFromIncompleteInput(testCase)
%             network = createHebbMarrNetwork(5);
%             inputY = [1 0 1 0 0]; 
%             checkInputOutput(network, testCase, [1 1 1 1 0], inputY);
%             inputX = [1 1 0 0 0]; 
%             retrieved = network.read(inputX);
%             testCase.assertEqual(retrieved, inputY); 
%         end
%         function testBookHeteroassociationExamples(testCase)
%             network = createHebbMarrNetwork(6);
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
function network = createOrthogonalizingNetwork(synapses, neurons)
    network = OrthogonalizingNetwork(synapses, neurons);    
    network.buildNetwork(); 
end
% function checkInputOutput(network, testCase, inputX, inputY)
%     network.step(inputX, inputY);
%     retrieved = network.read(inputX);
%     testCase.assertEqual(retrieved, inputY);             
% end
