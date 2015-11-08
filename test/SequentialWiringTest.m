classdef SequentialWiringTest < AbstractTest
    methods (Test)
        function testWiringFromSameInputIndexToOutput(testCase)
            wiring = SequentialWiring(5);
            testCase.assertEqual([1 2 3 4 5], wiring.connectionList); 
            input = [1 0 1 0 1];             
            output = wiring.connect(input);
            testCase.assertEqual(output, input);             
        end
    end
end
