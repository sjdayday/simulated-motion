classdef PlaceSystemTest < AbstractTest
    methods (Test)
        % testBinaryPerforantInputsStrengthenWeightsOnDirectPath
        function testPlaceSystemCreatedWithDGConnectedToCA3(testCase)
            outputMecLength = 10; 
            outputLecLength = 10; 
            placeSystem = PlaceSystem(outputMecLength, outputLecLength); 
            testCase.assertEqual(placeSystem.nMEC, 10); 
            testCase.assertEqual(placeSystem.nLEC, 10); 
            testCase.assertEqual(placeSystem.nDGInput, 20); 
            testCase.assertEqual(placeSystem.nCA3, 20);
            MecOutput = [ 1 1 1 1 1 0 0 0 0 0]; 
            LecOutput = [ 1 0 1 0 1 0 1 0 1 0]; 
            fired = placeSystem.step(MecOutput, LecOutput); 
            testCase.assertEqual(placeSystem.DGOutput, ...
             [ 1 1 0 0 1 1 0 1 0 0 0 0 0 0 1 1 0 0 1 0 ]);
            testCase.assertEqual(fired, ...
             [ 1 1 0 0 1 1 0 1 0 0 0 0 0 0 1 1 0 0 1 0 ], ...
              'input orthogonalized through DG, then fired as detonator synapses');
            testCase.assertEqual(placeSystem.ECOutput, ...
             [ 1 1 1 1 1 0 0 0 0 0 1 0 1 0 1 0 1 0 1 0 ], ...
              'original MEC + LEC input');         
        end
        function testPlaceSystemReturnsCa3OutputsFromFragmentaryEcOutputs(testCase)
            outputMecLength = 10; 
            outputLecLength = 10; 
            placeSystem = PlaceSystem(outputMecLength, outputLecLength); 
            MecOutput = [ 1 1 1 1 1 0 0 0 0 0]; 
            LecOutput = [ 1 0 1 0 1 0 1 0 1 0]; 
            fired = placeSystem.step(MecOutput, LecOutput); 
            Ca3Output = [ 1 1 0 0 1 1 0 1 0 0 0 0 0 0 1 1 0 0 1 0 ]; 
            testCase.assertEqual(fired, Ca3Output); 
            MecOutputPartial = [ 1 0 0 1 1 0 0 0 0 0];             
            LecOutputPartial = [ 0 0 1 0 1 0 0 0 1 0]; 
            MecOutputMissing = zeros(1,10); 
            testCase.assertEqual(...
                placeSystem.read([MecOutputPartial, LecOutputPartial]), Ca3Output); 
            testCase.assertEqual(...
                placeSystem.read([MecOutputMissing, LecOutput]), Ca3Output, ...
                'retrieve places from LEC input only'); 
        end
    end
end