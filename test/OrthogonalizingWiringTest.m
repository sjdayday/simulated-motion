classdef OrthogonalizingWiringTest < AbstractTest
    methods (Test)
        function testBuildingConnectionsDefaultsToFirstTimeOnly(testCase)
            wiring = OrthogonalizingWiring([5 10]);
            testCase.assertEqual([9 10 2 10 7], wiring.connectionList, ...
                'using default seed'); 
            input = [1 1 1 1 1];             
            output = wiring.connect(input);
            testCase.assertEqual(output, [0 1 0 0 0 0 1 0 1 1]); 
            input = [1 0 1 1 1];             
            output = wiring.connect(input);
            testCase.assertEqual(output, [0 1 0 0 0 0 1 0 1 1], ...
                'two input indices both connect to 10, so output unchanged'); 
            input = [0 0 1 1 1];             
            output = wiring.connect(input);
            testCase.assertEqual(output, [0 1 0 0 0 0 1 0 0 1], ...
                'first index now zero, so 9th output index is zero'); 
            
%             testCase.assertEqual(wiring.seed, 54);             
%             testCase.assertEqual([5 4 2 6 1], wiring.connectionList, ...
%                 'seed constructed from input'); 
%             testCase.assertEqual(output, [1 0 0 1 1 1 0 0 0 0]);             
        end
        function testWiringFromInputToRandomIndicesInLargerInternalVector(testCase)
            wiring = OrthogonalizingWiring([5 10]);
            wiring.rebuildConnections = true; 
            testCase.assertEqual([9 10 2 10 7], wiring.connectionList, ...
                'using default seed'); 
            input = [1 1 0 1 1];             
            output = wiring.connect(input);
            testCase.assertEqual(wiring.seed, 54);             
            testCase.assertEqual([5 4 2 6 1], wiring.connectionList, ...
                'seed constructed from input'); 
            testCase.assertEqual(output, [1 0 0 1 1 1 0 0 0 0]);             
        end
        function testWiringFromLargeInternalVectorToSmallerOutput(testCase)
            wiring = OrthogonalizingWiring([10 5]);
            wiring.rebuildConnections = true; 
            testCase.assertEqual([5 5 1 5 4 1 2 3 5 5], wiring.connectionList); 
            input = [0 0 0 0 0 0 1 0 1 1];             
            output = wiring.connect(input);
            testCase.assertEqual(output, [1 1 0 0 1]);             
        end
    end
end
