classdef PlaceSystemTest < AbstractTest
    methods (Test)
        % testBinaryPerforantInputsStrengthenWeightsOnDirectPath
        function testPlaceSystemCreatedWithDGConnectedToCA3(testCase)
            outputMecLength = 50; 
            outputLecLength = 50; 
            placeSystem = PlaceSystem(outputMecLength, outputLecLength); 
            testCase.assertEqual(placeSystem.nMEC, 50); 
            testCase.assertEqual(placeSystem.nLEC, 50); 
            testCase.assertEqual(placeSystem.nDGInput, 100); 
            testCase.assertEqual(placeSystem.nCA3, 100);             
        end
%         function testPositiveAndNegativeMotionWeights(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             gridNet = GridChartNetwork(6,5); 
%             gridNet.buildNetwork();
%             testCase.assertEqual(length(gridNet.horizonalWeightInputVector), 6, ...
%                 'weights operate row at a time, until/unless I figure out how to process 5X6 matrix in one pass');
%             testCase.assertEqual(length(gridNet.verticalWeightInputVector), 5);
%             testCase.assertEqual(size(gridNet.positiveHorizontalWeights), [6 6 ]);
%             testCase.assertEqual(size(gridNet.negativeHorizontalWeights), [6 6]);
%             testCase.assertEqual(size(gridNet.positiveVerticalWeights), [5 5]);
    end
end