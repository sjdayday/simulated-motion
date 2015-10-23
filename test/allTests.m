function [ result ] = allTests()
    clear all
    clear classes
    import matlab.unittest.TestSuite
    suiteFolder = TestSuite.fromFolder(pwd);
    result = run(suiteFolder);
end