function [ result ] = allTests()
    clear all
    clear classes
    import matlab.unittest.TestSuite
    suiteFolder = TestSuite.fromFolder('/Users/steve/oldmac/stevedoubleday/git/simulated-motion/test');
    result = run(suiteFolder);
end