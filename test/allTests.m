function [ result ] = allTests()
% must *run* from the simulated-motion/src directory, but must *reference* the
% simulated-motion/test directory.  See AbstractTest.m
% May require
% addpath('[complete path to git]/simulated-motion/src')
% addpath('[complete path to git]/simulated-motion/test')
% savepath '[complete path to git]/simulated-motion/src/pathdef.m'
% savepath '[complete path to git]/simulated-motion/test/pathdef.m'
    clear all
    clear classes
    import matlab.unittest.TestSuite
    cd ../test
    suiteFolder = TestSuite.fromFolder(pwd);
    result = run(suiteFolder);
end