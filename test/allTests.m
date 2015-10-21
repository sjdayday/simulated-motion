function [ result ] = allTests()
    clear all
    import matlab.unittest.TestSuite
    suiteFolder = TestSuite.fromFolder(pwd);
    result = run(suiteFolder);
end