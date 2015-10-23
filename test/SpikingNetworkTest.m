classdef SpikingNetworkTest < matlab.unittest.TestCase
    methods (Test)
        function testSpikingNetworkWithDefaultValues(testCase)
            load '../rngDefaultSettings';
            rng(rngDefault);   % set random number generator back to default
            load 'testSpikingNetwork' expectedFirings;
            network = SpikingNetwork();
            % override parameters here. Plot: SpikingNetworkTestPlot.fig
            % Defaults to the following:
            network.recoveryRate = 0.02; 
            network.subthresholdFluctuationSensitivity = 0.2; 
            network.membranePotentialReset = -65; 
            network.recoveryReset = 8; 
            % generates "fast spiking(?)": SpikingNetworkTestFastPlot.fig 
%             network.recoveryRate = 0.02; 
%             network.subthresholdFluctuationSensitivity = 0.2; 
%             network.membranePotentialReset = -55; 
%             network.recoveryReset = 4; 
            % generates "bursting (?)": SpikingNetworkTestBurstPlot.fig
%             network.recoveryRate = 0.1; 
%             network.subthresholdFluctuationSensitivity = 0.2; 
%             network.membranePotentialReset = -65; 
%             network.recoveryReset = 2; 
            % generates "fast bursting (?)": SpikingNetworkTestFastBurstPlot.fig 
%             network.recoveryRate = 0.1; 
%             network.subthresholdFluctuationSensitivity = 0.25; 
%             network.membranePotentialReset = -65; 
%             network.recoveryReset = 2; 
            
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