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
            system.gridExternalVelocity = false; 
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
            system.pullVelocity = false; 
            system.build();  
%             system.headDirectionSystem.pullVelocity = false;  
            system.step(); 
            testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), 54); 
            system.updateAngularVelocity(pi/10); 
            for ii = 1:10     
                system.step(); 
            end
            testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), 38); 
        end
        function testLinearVelocityAndOrientationToHorizontalVerticalVelocity(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            system = HippocampalFormation();
            system.nHeadDirectionCells = 60; 
            system.pullVelocity = false;             
            system.build();  
%             system.headDirectionSystem.pullVelocity = false;  
            system.updateAngularVelocity(0); 
            system.step(); 
            system.step(); 
%             testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), 8); 
            system.headDirectionSystem.uActivation = zeros(1,60);
            system.headDirectionSystem.uActivation(8) = 1; 
            testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), ... 
                8, 'forced'); 
            system.updateLinearVelocity(0.0005); 
            testCase.assertThat(system.calculateCartesianVelocity(), ...            
                IsEqualTo([0.000334565303179, -0.000371572412738 ], 'Within', RelativeTolerance(.00000000001)));         
        end
        function testBothAngularAndLinearVelocityCantBeNonZero(testCase)
            system = HippocampalFormation();
            system.nHeadDirectionCells = 60; 
            system.pullVelocity = false; 
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
        function testCartesianVelocitiesUpdateGrids(testCase)
            system = HippocampalFormation();
            system.nHeadDirectionCells = 60; 
            system.nGridOrientations = 3;
%             system.gridExternalVelocity = true; % default 
            system.gridDirectionBiasIncrement = pi/4;             
            system.nGridGains = 1; 
            system.gridSize = [10,9];
%             system.headDirectionSystem.pullVelocity = false;  
            system.pullVelocity = false; 
            system.build();  
            system.updateAngularVelocity(0); 
            system.step(); 
            system.step(); 
            system.headDirectionSystem.uActivation = zeros(1,60);
            system.headDirectionSystem.uActivation(8) = 1; 
            testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), ... 
                8, 'forced'); 
            testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 15); 
            testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 33); 
            testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 73); 
            system.updateAngularAndLinearVelocity(0, 0.0001); % down, right                   
            system.step();                                     
            testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 23); 
            testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 41); 
            testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 45, ...
                'wraps to mid-top grid');             
%             disp(system.grids(1,3).getMaxActivationIndex()); 
%             system.grids(1,3).plot(); pause(1);   
            system.step(); 
            testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 23); 
            testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 41); 
            testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 54);     
%             disp(system.grids(1,3).getMaxActivationIndex()); 
%             system.grids(1,3).plot(); pause(1);             
            system.step();                                     
            testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 31); 
            testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 49);
            testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 62);
%             disp(system.grids(1,3).getMaxActivationIndex()); 
%             system.grids(1,3).plot(); pause(1);             
            system.step();                                     
            testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 39); 
            testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 57);
            testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 61);
%             disp(system.grids(1,3).getMaxActivationIndex()); 
%             system.grids(1,3).plot(); pause(1);             
%             for ii = 1:10
%                 system.step();     
%                 system.grids(1,3).plot(); pause(1); 
%                 disp(system.grids(1,3).getMaxActivationIndex()); 
%             end
        end
        function testMecOutputUpdatesPlaceSystemThenRetrievesSamePlace(testCase)
            system = HippocampalFormation();
            system.nGridOrientations = 3; 
            system.nHeadDirectionCells = 60; 
            system.gridDirectionBiasIncrement = pi/4;   
            system.gridExternalVelocity = false; 
            system.nGridGains = 1; 
            system.gridSize = [6,5];
            system.pullVelocity = false; 
            system.build();  
            system.stepMec(); 
            mecOutput = [ 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 ...
                  ];
            testCase.assertEqual(system.mecOutput, mecOutput); 
            system.stepPlace(); 
            placeOutput = system.placeOutput; 
            mecLecOutput = [mecOutput, zeros(1,system.nLecOutput)]; 
            testCase.assertEqual(system.placeSystem.read(mecLecOutput), ...
                placeOutput, 'use MEC output to retrieved saved place output'); 
%             disp(system.placeSystem.outputIndices()); 
        end
        function testHeadDirectionSystemTreatsPlaceOutputAsDetectedFeatures(testCase)
            system = HippocampalFormation();
            system.nGridOrientations = 3; 
            system.nHeadDirectionCells = 60; 
            system.gridDirectionBiasIncrement = pi/4;   
            system.gridExternalVelocity = false; 
            system.nGridGains = 1; 
            system.gridSize = [6,5];
            system.pullVelocity = false; 
            system.defaultFeatureDetectors = false; 
            system.build();  
            testCase.assertEqual(system.headDirectionSystem.featuresDetected, ...
                zeros(1,system.placeSystem.nCA3));                         
            system.step(); 
            testCase.assertEqual(system.placeSystem.outputIndices(), [30 88 90]);             
            featureIndices = find(system.headDirectionSystem.featuresDetected == 1);  
            testCase.assertEqual(featureIndices, [30 88 90]);             
        end
        
    end
end