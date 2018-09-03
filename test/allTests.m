function [ result ] = allTests()
% must *run* from the simulated-motion/src directory, but must *reference* the
% simulated-motion/test directory.  See AbstractTest.m
    clear all
    clear classes
    import matlab.unittest.TestSuite
    cd ../test
    suiteFolder = TestSuite.fromFolder(pwd);
    result = run(suiteFolder);
end