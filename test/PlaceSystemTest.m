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
            testCase.assertEqual(80, sum(sum(placeSystem.network)), ...
              'number of activated synapses');         
        end
        function testPlaceSystemCreatedWithDGConnectedToCA3SparseInputs(testCase)
            outputMecLength = 10; 
            outputLecLength = 10;
            placeSystem = PlaceSystem(outputMecLength, outputLecLength); 
            placeSystem.DG.sparse = true;
            placeSystem.DG.nMEC = 5; 
            placeSystem.DG.separateMecLec = true;             
            testCase.assertEqual(placeSystem.nMEC, 10); 
            testCase.assertEqual(placeSystem.nLEC, 10); 
            testCase.assertEqual(placeSystem.nDGInput, 20); 
            testCase.assertEqual(placeSystem.nCA3, 20);
            MecOutput = [ 1 1 1 1 1 0 0 0 0 0]; 
            LecOutput = [ 1 0 1 0 1 0 1 0 1 0]; 
            fired = placeSystem.step(MecOutput, LecOutput); 
            testCase.assertEqual(placeSystem.DGOutput, ...
             [ 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 ], ...
             'only two outputs');
            testCase.assertEqual(fired, ...
             [ 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 ], ...
              'input orthogonalized through DG, then fired as detonator synapses');
            testCase.assertEqual(placeSystem.ECOutput, ...
             [ 1 1 1 1 1 0 0 0 0 0 1 0 1 0 1 0 1 0 1 0 ], ...
              'original MEC + LEC input');         
            testCase.assertEqual(20, sum(sum(placeSystem.network)), ...
              'number of activated synapses');         
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
            testCase.assertTrue(placeSystem.recallPlace([MecOutputPartial, LecOutputPartial])); 
            testCase.assertEqual(...
                placeSystem.read([MecOutputMissing, LecOutput]), Ca3Output, ...
                'retrieve places from LEC input only'); 
            testCase.assertTrue(placeSystem.recallPlace([MecOutputMissing, LecOutput]));             
            MecOutputOpposite = [ 0 0 0 0 0 1 1 1 1 1]; 
            LecOutputOpposite = [ 0 1 0 1 0 1 0 1 0 1];             
            testCase.assertEqual(...
                placeSystem.read([MecOutputOpposite, LecOutputOpposite]), zeros(1,20), ...
                'previously unseen inputs retrieve nothing'); 
            testCase.assertFalse(placeSystem.recallPlace([MecOutputOpposite, LecOutputOpposite]));                         
            
        end
        function testPlaceSystemRecognizesPlaces(testCase)
            outputMecLength = 10; 
            outputLecLength = 10; 
            placeSystem = PlaceSystem(outputMecLength, outputLecLength); 
            MecOutput = [ 1 1 1 1 1 0 0 0 0 0]; 
            LecOutput = [ 1 0 1 0 1 0 1 0 1 0]; 
            fired = placeSystem.step(MecOutput, LecOutput); 
            Ca3Output = [ 1 1 0 0 1 1 0 1 0 0 0 0 0 0 1 1 0 0 1 0 ]; 
            testCase.assertEqual(fired, Ca3Output); 
            testCase.assertEqual(placeSystem.placeId, Ca3Output); 
            MecOutputPartial = [ 1 0 0 1 1 0 0 0 0 0];             
            LecOutputPartial = [ 0 0 1 0 1 0 0 0 1 0]; 
            MecOutputMissing = zeros(1,10); 
            testCase.assertTrue(placeSystem.recallPlace([MecOutputPartial, LecOutputPartial]));             
            testCase.assertEqual(...
                placeSystem.placeId, Ca3Output); 
            testCase.assertTrue(placeSystem.recallPlace([MecOutputMissing, LecOutput]));             
            testCase.assertEqual(...
                placeSystem.placeId, Ca3Output, ...
                'retrieve places from LEC input only'); 
            MecOutputOpposite = [ 0 0 0 0 0 1 1 1 1 1]; 
            LecOutputOpposite = [ 0 1 0 1 0 1 0 1 0 1];             
            testCase.assertFalse(placeSystem.recallPlace([MecOutputOpposite, LecOutputOpposite]));                                     
            testCase.assertEqual(...
                placeSystem.placeId, zeros(1,20), ...
                'previously unseen inputs retrieve nothing');           
        end
        function testPlaceSystemShortOutputReturnsNonZeroIndices(testCase)
            outputMecLength = 10; 
            outputLecLength = 10; 
            placeSystem = PlaceSystem(outputMecLength, outputLecLength); 
            MecOutput = [ 1 1 1 1 1 0 0 0 0 0]; 
            LecOutput = [ 1 0 1 0 1 0 1 0 1 0]; 
            placeSystem.step(MecOutput, LecOutput);
            testCase.assertEqual(placeSystem.outputIndices(), [1 2 5 6 8 15 16 19]); 
%             disp(placeSystem.network); 
%             disp(placeSystem.saturation()); 
        end
    end
end