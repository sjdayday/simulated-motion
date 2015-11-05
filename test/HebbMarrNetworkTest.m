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
        
%                 function testSpikingNetworkStepByStep(testCase)
% %             load '../rngDefaultSettings';
% %             rng(rngDefault);   % set random number generator back to default
%             load 'testSpikingNetwork' expectedFirings;
%             network = SpikingNetwork();            
%             network.buildNetwork();
%             firings = [];
%             for t=1:network.totalMilliseconds          % simulation of 1000 ms 
%                %Create some random input external to the network
%                externalInput=[5*randn(network.nExcitatoryNeurons,1); ... 
%                    2*randn(network.nInhibitoryNeurons,1)]; % e.g., thalamic input 
% 
%                fired = network.step(externalInput);
% 
%                if ~isempty(fired)
%                    firings=[firings; t+0*fired, fired];
%                end;
%             end;
%             
%             testCase.assertEqual(firings, expectedFirings, ...
%                 'expected firings not matched');
% 
%         end

    end
end