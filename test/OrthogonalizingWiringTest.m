classdef OrthogonalizingWiringTest < AbstractTest
    methods (Test)
        function testWiringFromInputToRandomIndicesInLargerInternalVector(testCase)
            wiring = OrthogonalizingWiring([5 10]);
            testCase.assertEqual([9 10 2 10 7], wiring.connectionList); 
            input = [1 1 0 1 1];             
            output = wiring.connect(input);
            testCase.assertEqual(output, [0 0 0 0 0 0 1 0 1 1]);             
        end
    end
end
