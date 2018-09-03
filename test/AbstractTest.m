classdef AbstractTest < matlab.unittest.TestCase
    methods(TestMethodSetup)
        function setup(testCase)
            load '../rngDefaultSettings';
            rng(rngDefault);   % set random number generator back to default
%             disp('loaded rng')
            cd('/Users/steve/oldmac/stevedoubleday/git/simulated-motion/src')
        end
    end
end