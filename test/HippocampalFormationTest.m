classdef HippocampalFormationTest < AbstractTest
    methods (Test)
        % testBinaryPerforantInputsStrengthenWeightsOnDirectPath
        function testBuildHippocampalFormation(testCase)
            system = HippocampalFormation();
            system.nHeadDirectionCells = 60; 
            system.nGridOrientations = 5; 
            system.nGridGains = 3; 
            system.gridSize = [10,9];
            system.nFeatures = 3; 
            system.distanceUnits = 10; 
            system.rewardInput = true; 
            system.build(); 
            testCase.assertEqual(system.nGrids, 7, ...
             '5 orientations @ default gain + 1 higher gain + 1 lower gain'); 
            testCase.assertEqual(system.nMecOutput, 630, ... 
                '90 per grid x 7 grids'); 
            testCase.assertEqual(system.nLecOutput, 215, ... 
                '3 features, each 60 orientation + 10 distance; 5 for reward'); 
            testCase.assertEqual(system.placeSystem.nDGInput, 845); 
            testCase.assertEqual(system.placeSystem.nCA3, 845);
%             MecOutput = [ 1 1 1 1 1 0 0 0 0 0]; 
%             LecOutput = [ 1 0 1 0 1 0 1 0 1 0]; 
%             fired = placeSystem.step(MecOutput, LecOutput); 
%             testCase.assertEqual(placeSystem.DGOutput, ...
%              [ 1 1 0 0 1 1 0 1 0 0 0 0 0 0 1 1 0 0 1 0 ]);
%             testCase.assertEqual(fired, ...
%              [ 1 1 0 0 1 1 0 1 0 0 0 0 0 0 1 1 0 0 1 0 ], ...
%               'input orthogonalized through DG, then fired as detonator synapses');
%             testCase.assertEqual(placeSystem.ECOutput, ...
%              [ 1 1 1 1 1 0 0 0 0 0 1 0 1 0 1 0 1 0 1 0 ], ...
%               'original MEC + LEC input');         
        end
    end
end