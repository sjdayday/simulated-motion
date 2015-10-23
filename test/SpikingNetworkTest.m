classdef SpikingNetworkTest < matlab.unittest.TestCase
    methods (Test)
        function testSpikingNetworkWithDefaultValues(testCase)
            load '../rngDefaultSettings';
            rng(rngDefault);   % set random number generator back to default
            load 'testSpikingNetwork' expectedFirings;
            network = SpikingNetwork();
            network.buildNetwork(); 
            firings = network.runNetwork();
            testCase.assertEqual(firings, expectedFirings, ...
                'expected firings not matched');
            % following verifies that resetting rng required to get same
            % results
%             firings2 = network.runNetwork(); 
%             testCase.assertNotEqual(firings2, expectedFirings, 'should not have matched');
%             testCase.assertEqual(firings2, expectedFirings, 'will fail...');

        end
    end
end