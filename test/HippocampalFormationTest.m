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
            testCase.assertEqual(system.nGrids, 15, ...
             '5 orientations x 3 gains'); 
            testCase.assertEqual(system.nMecOutput, 1350, ... 
                '90 per grid x 15 grids'); 
            testCase.assertEqual(system.nLecOutput, 215, ... 
                '3 features, each 60 orientation + 10 distance; 5 for reward'); 
            testCase.assertEqual(system.placeSystem.nDGInput, 1565); 
            testCase.assertEqual(system.placeSystem.nCA3, 1565);
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
        function testHippocampalFormationGridsBuilt(testCase)
            system = HippocampalFormation();
            system.nHeadDirectionCells = 60; 
            system.nGridOrientations = 4; 
            system.gridDirectionBiasIncrement = pi/4;             
            system.nGridGains = 2; 
            system.baseGain = 1500; 
            system.gridSize = [10,9];
            system.build(); 
            testCase.assertEqual(length(system.grids), 8); 
            testCase.assertEqual(system.grids(1,1).inputDirectionBias, 0); 
            testCase.assertEqual(system.grids(1,2).inputDirectionBias, pi/4); 
            testCase.assertEqual(system.grids(1,3).inputDirectionBias, 2*pi/4); 
            testCase.assertEqual(system.grids(1,4).inputDirectionBias, 3*pi/4); 
            testCase.assertEqual(system.grids(1,5).inputDirectionBias, 0); 
            testCase.assertEqual(system.grids(1,6).inputDirectionBias, pi/4); 
            testCase.assertEqual(system.grids(1,7).inputDirectionBias, 2*pi/4); 
            testCase.assertEqual(system.grids(1,8).inputDirectionBias, 3*pi/4); 
            testCase.assertEqual(system.grids(1,1).inputGain, 1500);             
            testCase.assertEqual(system.grids(1,5).inputGain, ... 
                system.grids(1,1).inputGain*1.42);             
            testCase.assertEqual(system.grids(1,8).inputGain, ... 
                system.grids(1,1).inputGain*1.42);             
        end
        function testHippocampalFormationGridsUpdateMecOutputEachStep(testCase)
            system = HippocampalFormation();
            system.nHeadDirectionCells = 60; 
            system.nGridOrientations = 3; 
            system.gridDirectionBiasIncrement = pi/4;             
            system.nGridGains = 1; 
            system.gridSize = [6,5];
            system.build();  
            system.stepMec(); 
            testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 4); 
            testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 15); 
            testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 24); 
            testCase.assertEqual(system.mecOutput, ...
                [ 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 ...
                  ]); 
            for ii = 1:20;     
                system.stepMec(); 
            end
            testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 19); 
            testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 25); 
            testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 8); 
            testCase.assertEqual(system.mecOutput, ...
                [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  ]); 
        end
        function testHeadDirectionUpdatedByAngularVelocityAtEachStep(testCase)
            system = HippocampalFormation();
            system.nHeadDirectionCells = 60; 
            system.build();  
            system.headDirectionSystem.pullVelocity = false;  
            system.step(); 
            testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), 2); 
            system.updateAngularVelocity(pi/10); 
            for ii = 1:10     
                system.step(); 
            end
            testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), 57); 
        end
        function testLinearVelocityAndOrientationToHorizontalVerticalVelocity(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            system = HippocampalFormation();
            system.nHeadDirectionCells = 60; 
            system.build();  
            system.headDirectionSystem.pullVelocity = false;  
            system.updateAngularVelocity(0); 
            system.step(); 
            system.step(); 
            testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), 8); 
            system.updateLinearVelocity(0.0005); 
            testCase.assertThat(system.calculateCartesianVelocity(), ...            
                IsEqualTo([0.000334565303179, -0.000371572412738 ], 'Within', RelativeTolerance(.00000000001)));         
        end
        function testBothAngularAndLinearVelocityCantBeNonZero(testCase)
            system = HippocampalFormation();
            system.nHeadDirectionCells = 60; 
            system.build();  
            system.updateAngularAndLinearVelocity(-pi/10, 0);             
            system.updateAngularAndLinearVelocity(0, 0.0005);             
            try 
                system.updateAngularAndLinearVelocity(-pi/10, 0.0005); 
            catch  ME
                testCase.assertEqual(ME.identifier, 'HippocampalFormation:VelocitiesNonZero'); 
                testCase.assertEqual(ME.message, 'updateAngularAndLinearVelocity() requires one argument to be zero.'); 
            end
        end
        
    end
end