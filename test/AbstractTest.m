classdef AbstractTest < matlab.unittest.TestCase
    % overrides working directory (cd or pwd) to the src directory, after
    % the allTests.m TestSuite.fromFolder function finds the tests in the
    % test directory 
    methods(TestMethodSetup)
        function setup(testCase)
            load '../rngDefaultSettings';
            rng(rngDefault);   % set random number generator back to default
%             disp('loaded rng')
            cd ../src
        end
    end
end