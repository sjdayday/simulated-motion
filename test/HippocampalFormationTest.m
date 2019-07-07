classdef HippocampalFormationTest < AbstractTest
    properties
        hf
        h
        counter
    end
    methods (Test)
        % testBinaryPerforantInputsStrengthenWeightsOnDirectPath
        function testBuildHippocampalFormation(testCase)
            system = HippocampalFormation();
            system.defaultFeatureDetectors = false; 
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
            testCase.assertEqual(system.nLecOutput, 180, ... 
                '3 features, each 60 orientation'); 
            testCase.assertEqual(system.placeSystem.nDGInput, 1530); 
            testCase.assertEqual(system.placeSystem.nCA3, 1530);
            testCase.assertEqual(system.nFeatureDetectors, 1530);
            testCase.assertEqual(system.headDirectionSystem.nFeatureDetectors, 1530);            
            testCase.assertEqual(system.grids(1).nFeatureDetectors, 1530);            
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
            testCase.assertEqual(system.grids(1).inputDirectionBias, 0); 
            testCase.assertEqual(system.grids(2).inputDirectionBias, pi/4); 
            testCase.assertEqual(system.grids(3).inputDirectionBias, 2*pi/4); 
            testCase.assertEqual(system.grids(4).inputDirectionBias, 3*pi/4); 
            testCase.assertEqual(system.grids(5).inputDirectionBias, 0); 
            testCase.assertEqual(system.grids(6).inputDirectionBias, pi/4); 
            testCase.assertEqual(system.grids(7).inputDirectionBias, 2*pi/4); 
            testCase.assertEqual(system.grids(8).inputDirectionBias, 3*pi/4); 
            testCase.assertEqual(system.grids(1).inputGain, 1500);             
            testCase.assertEqual(system.grids(5).inputGain, ... 
                system.grids(1,1).inputGain*1.42);             
            testCase.assertEqual(system.grids(8).inputGain, ... 
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
            testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 8); 
            testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 17); 
            testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 14); 
%             testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 4); 
%             testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 15); 
%             testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 24); 
            testCase.assertEqual(system.mecOutput, ...
               [ 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
        %                 [ 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
%                   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 ...
%                   0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  ]); 
            for ii = 1:20    
                system.stepMec(); 
            end
            testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 22); 
            testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 26); 
            testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 29); 
            
            testCase.assertEqual(system.mecOutput, ...
                [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 ...
                  ]); 
        end
        function testHeadDirectionUpdatedByTurnVelocityAtEachStep(testCase)
            system = HippocampalFormation();
            system.nHeadDirectionCells = 60; 
            system.pullVelocity = false; 
            system.build();  
%             system.headDirectionSystem.pullVelocity = false;  
%             system.updateAngularVelocity(pi/10);
            system.updateTurnVelocity(2);            
            system.step(); 
            testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), 4); % was 55 
            system.step(); 
            testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), 10); % was 55 
            system.step(); 
            testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), 13); % was 56 
            for ii = 3:10     
                system.step(); 
            end
            testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), 24); %was 8 
        end
        function testUpdateTurnVelocityTranslatedToAngularVelocity(testCase)
            system = HippocampalFormation();
            system.nHeadDirectionCells = 60; 
            system.pullVelocity = false; 
            system.build();  
            system.updateTurnVelocity(1);
%             testCase.assertEqual(signedAngularVelocity, pi/20); 
            testCase.assertEqual(system.angularVelocity, pi/20);             
            system.updateTurnVelocity(-2);
%             testCase.assertEqual(signedAngularVelocity, -2*pi/20); 
            testCase.assertEqual(system.angularVelocity, -2*pi/20);             
            system.updateTurnVelocity(0);
%             testCase.assertEqual(signedAngularVelocity, 0); 
            testCase.assertEqual(system.angularVelocity, 0);             
        end
        function testLinearVelocityAndOrientationToHorizontalVerticalVelocity(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance                        
            system = HippocampalFormation();
            system.nHeadDirectionCells = 60; 
            system.pullVelocity = false;             
            system.build();  
%             system.headDirectionSystem.pullVelocity = false;  
%       angular/turn velocity ignored
%             system.updateAngularVelocity(pi/10); 
%             system.updateTurnVelocity(-2);             
            system.step(); 
            system.step(); 
%             testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), 8); 
            system.headDirectionSystem.uActivation = zeros(1,60);
            system.headDirectionSystem.uActivation(8) = 1; 
            testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), ... 
                8, 'forced'); 
            system.updateCurrentHeadDirection();
            system.updateLinearVelocity(0.0005);
            testCase.assertThat(system.calculateCartesianVelocity(), ...            
                IsEqualTo([0.0003345, 0.0003715], 'Within', AbsoluteTolerance(.0000001)));         
        end
        function testCalculateCartesianVelocity(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance            
            import matlab.unittest.constraints.AbsoluteTolerance                        
            system = HippocampalFormation();
            system.nHeadDirectionCells = 60; 
            system.pullVelocity = false; 
            system.build();  
            system.updateLinearVelocity(0); 
            system.currentHeadDirection = 1; 
            testCase.assertThat(system.calculateCartesianVelocity(), ...            
                IsEqualTo([0, 0 ], 'Within', AbsoluteTolerance(.00000000001)));         
            system.updateLinearVelocity(0.00005); 
            system.currentHeadDirection = 60; 
            testCase.assertThat(system.calculateCartesianVelocity(), ...            
                IsEqualTo([0.00005, 0 ], 'Within', AbsoluteTolerance(.00000000001)));         
            system.currentHeadDirection = 30; 
            testCase.assertThat(system.calculateCartesianVelocity(), ...            
                IsEqualTo([-0.00005, 0], 'Within', AbsoluteTolerance(.00000000001)));         
            system.currentHeadDirection = 15; 
            testCase.assertThat(system.calculateCartesianVelocity(), ...            
                IsEqualTo([0, 0.00005], 'Within', AbsoluteTolerance(.00000000001)));         
            system.currentHeadDirection = 45; 
            testCase.assertThat(system.calculateCartesianVelocity(), ...            
                IsEqualTo([0, -0.00005], 'Within', AbsoluteTolerance(.00000000001)));         
            system.currentHeadDirection = 8; 
            testCase.assertThat(system.calculateCartesianVelocity(), ...            
                IsEqualTo([0.00003345, 0.00003715], 'Within', AbsoluteTolerance(.00000001)));         
            
        end
        function testBothAngularAndLinearVelocityCantBeNonZero(testCase)
            system = HippocampalFormation();
            system.nHeadDirectionCells = 60; 
            system.pullVelocity = false; 
            system.build();  
            system.updateTurnAndLinearVelocity(-2, 0);             
            system.updateTurnAndLinearVelocity(0, 0.0005);             
            try 
                system.updateTurnAndLinearVelocity(-2, 0.0005); 
                testCase.assertEqual(1,0, 'should throw'); 
            catch  ME
                testCase.assertEqual(ME.identifier, 'HippocampalFormation:VelocitiesNonZero'); 
                testCase.assertEqual(ME.message, 'updateTurnAndLinearVelocity() requires one argument to be zero; cannot both be turning and running simultaneously.'); 
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
%    angular / turn velocity unnecessary             
%             system.updateAngularVelocity(0);
            system.step(); 
            system.step(); 
            system.headDirectionSystem.uActivation = zeros(1,60);
            system.headDirectionSystem.uActivation(8) = 1; 
            testCase.assertEqual(system.headDirectionSystem.getMaxActivationIndex(), ... 
                8, 'forced'); % up and right for first grid; w bias, third is straight up
            testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 78); 
            testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 68); 
            testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 15); 
%             disp(system.grids(1,1).getMaxActivationIndex()); 
%             system.grids(1,1).plot(); pause(1);   
%             testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 15); 
%             testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 33); 
%             testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 73); 
            system.updateTurnAndLinearVelocity(0, 0.0001); % up, right                   
            system.step();                                     
            testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 88); 
            testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 69); 
            testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 7, ...
                'wraps to mid-top grid');             
%             disp(system.grids(1,1).getMaxActivationIndex()); 
%             system.grids(1,1).plot(); pause(1);   
            system.step(); 
            testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 89); 
            testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 70); 
            testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 7);     
%             testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 26); 
%             testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 44); 
%             testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 3);     
%             disp(system.grids(1,1).getMaxActivationIndex()); 
%             system.grids(1,1).plot(); pause(1);             
            system.step();                                     
            testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 9); 
            testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 71);
            testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 89);
%             testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 44); 
%             testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 53);
%             testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 13);
%             disp(system.grids(1,1).getMaxActivationIndex()); 
%             system.grids(1,1).plot(); pause(1);             
            system.step();                                     
            testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 18); 
            testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 72);
            testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 90);
%             testCase.assertEqual(system.grids(1,1).getMaxActivationIndex(), 45); 
%             testCase.assertEqual(system.grids(1,2).getMaxActivationIndex(), 63);
%             testCase.assertEqual(system.grids(1,3).getMaxActivationIndex(), 13);
%             disp(system.grids(1,1).getMaxActivationIndex()); 
%             system.grids(1,1).plot(); pause(1);             
%             for ii = 1:10
%                 system.step();     
%                 system.grids(1,1).plot(); pause(1); 
%                 disp(system.grids(1,1).getMaxActivationIndex()); 
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
            mecOutput = [ 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  ];
            testCase.assertEqual(system.mecOutput, mecOutput); 
            system.stepPlace(); 
            placeOutput = system.placeOutput; 
            mecLecOutput = [mecOutput, zeros(1,system.nLecOutput)]; 
            testCase.assertEqual(system.placeSystem.read(mecLecOutput), ...
                placeOutput, 'use MEC output to retrieve saved place output'); 
%             disp(system.placeSystem.outputIndices());  % 30    88    90
        end
        function testMecAndLecOutputUpdatesPlaceSystemThenRetrievesSamePlace(testCase)
            system = HippocampalFormation();
            system.nGridOrientations = 3; 
            system.nHeadDirectionCells = 60; 
            system.gridDirectionBiasIncrement = pi/4;   
            system.gridExternalVelocity = false; 
            system.nGridGains = 1; 
            system.gridSize = [6,5];
            system.pullVelocity = false; 
            system.nHeadDirectionCells = 60;
            system.nFeatures = 3; 
            system.build(); 
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.distanceIntervals = 8;
            env.directionIntervals = 60;
            env.center = [1 1]; 
            env.build();
            system.lecSystem.setEnvironment(env); 
            env.setPosition([0.5 1]);             
%             env.setPosition([0.5 1]); 
            env.addCue([2 1]);  %  x   ------------- cue (at 0)
            env.addCue([0 0]);            
%             currentHeadDirection = 10;
%             system.lecSystem.buildCanonicalView(currentHeadDirection); 

            system.step(); % stepMec 
            mecOutput = [ 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  ];
%             mecOutput = [ 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
%                   0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
%                   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 ...
%                   ];
            testCase.assertEqual(system.mecOutput, mecOutput); 
            lecOutput = system.lecOutput; 
            testCase.assertEqual(lecOutput, ...
                [ 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...                  
                  1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  ]);             
            system.stepPlace(); 
            placeOutput = system.placeOutput; 
%             disp(placeOutput); 
            mecLecOutput = [mecOutput, lecOutput]; 
            testCase.assertEqual(system.placeSystem.outputIndices(), ...
               [47    95    96   135   161   243]);  
            testCase.assertEqual(system.placeSystem.read(mecLecOutput), ...
                placeOutput, 'use MEC & LEC output to retrieve saved place output'); 
            mecOutputOnly = [mecOutput, zeros(1,system.nLecOutput)]; 
            testCase.assertEqual(system.placeSystem.read(mecOutputOnly), ...
                placeOutput, 'use MEC output to retrieve saved place output'); 
            lecOutputOnly = [zeros(1,system.nMecOutput), lecOutput]; 
            testCase.assertEqual(system.placeSystem.read(lecOutputOnly), ...
                placeOutput, 'use LEC output to retrieve saved place output'); 
            zeroOutput = [zeros(1,system.nMecOutput), zeros(1,system.nLecOutput)];
            testCase.assertEqual(system.placeSystem.read(zeroOutput), ...
                zeros(1,length(placeOutput)), ...
                'simple counter case; zeros does not retrieve place'); 
%             disp(system.placeSystem.outputIndices());  % 30    88    90
        end
        function testHdsAndGridsTreatPlaceOutputAsDetectedFeatures(testCase)
            system = HippocampalFormation();
            system.nGridOrientations = 3; 
            system.nHeadDirectionCells = 60; 
            system.gridDirectionBiasIncrement = pi/4;   
            system.gridExternalVelocity = false; 
            system.nGridGains = 1; 
            system.gridSize = [6,5];
            system.pullVelocity = false; 
            system.defaultFeatureDetectors = false; 
            system.updateFeatureDetectors = true;
            system.build();  
            testCase.assertEqual(system.headDirectionSystem.featuresDetected, ...
                zeros(1,system.placeSystem.nCA3)); 
            s = size(system.headDirectionSystem.featureWeights); 
            testCase.assertEqual(system.placeSystem.nCA3, s(1), ...
                'featureWeights rebuilt when featuresDetected is updated'); 
            system.step(); 
            testCase.assertEqual(system.placeSystem.outputIndices(), [56 63 119]); % [5 49 116]            
            featureIndices = find(system.headDirectionSystem.featuresDetected == 1);  
            testCase.assertEqual(featureIndices, [56 63 119]); 
            for jj = 1:3
                featureIndices = find(system.grids(1,jj).featuresDetected == 1);  
                testCase.assertEqual(featureIndices, [56 63 119]); 
            end
        end
        function testPlaceOutputAccumulatesAsList(testCase)
            system = HippocampalFormation();
            system.build();
            system.placeSystem.currentOutput = [0 1 0 1 0 1 0 1];
            system.addOutputToPlacesList(); 
            system.placeSystem.currentOutput = [1 0 1 0 1 0 1 0];
            system.addOutputToPlacesList(); 
            system.placeSystem.currentOutput = [0 1 0 1 0 1 0 1];
            system.addOutputToPlacesList(); 
            disp(system.placeList); 
            testCase.assertEqual([2 4 6 8; 1 3 5 7; 2 4 6 8], ...
                 system.placeList);
            system.placeSystem.currentOutput = [0 1 0 1 0 1];
            system.addOutputToPlacesList(); 
            testCase.assertEqual([2 4 6 8; 1 3 5 7; 2 4 6 8; 2 4 6 0], ...
                 system.placeList,'shorter indices zero-filled at end');
            system.placeSystem.currentOutput = [0 1 0 1 0 1 1 1 1 1];
            system.addOutputToPlacesList(); 
            testCase.assertEqual([2 4 6 8; 1 3 5 7; 2 4 6 8; 2 4 6 0; 2 4 6 7], ...
                 system.placeList,'longer indices truncated');
        end
        function testNewAnimalPositionAndPlaceOutputAccumulatesAsList(testCase)
            system = HippocampalFormation();
            system.build();
            system.placeSystem.currentOutput = [0 1 0 1 0 1 0 1];
            system.animal.x = 1.1;
            system.animal.y = 0.1;
            system.addPositionAndPlaceIfDifferent();
%             disp(system.placeListDisplay); 
            system.placeSystem.currentOutput = [1 0 1 0 1 0 1 0];
            system.animal.x = 1.2;
            system.animal.y = 0.1;
            system.addPositionAndPlaceIfDifferent();
            result = 2; 
            testCase.assertEqual(system.placeListDisplay, ...
                [result 1.1 0.1 2 4 6 8; result 1.2 0.1 1 3 5 7]);
            system.addPositionAndPlaceIfDifferent();
            testCase.assertEqual(system.placeListDisplay, ...
                [result 1.1 0.1 2 4 6 8; result 1.2 0.1 1 3 5 7],'duplicates not added');        
        end
        function testMapBuiltKeyStringPlaceIdValuePosition(testCase)
            system = HippocampalFormation();
            system.build();
            system.placeSystem.currentOutput = [0 1 0 1 0 1 0 1];
            system.animal.x = 1.1;
            system.animal.y = 0.1;
            system.addPositionAndPlaceIfDifferent();
            position = system.getPositionForPlace('[2 4 6 8]'); 
            testCase.assertEqual(position(1), 1.1); 
            testCase.assertEqual(position(2), 0.1); 
            try 
                system.getPositionForPlace('[5 5 7 8]'); 
                testCase.assertFail('should throw'); 
            catch  EX
                testCase.assertEqual(EX.identifier, 'MATLAB:Containers:Map:NoKey'); 
            end
        end
        function testCurrentPlacePositionNearOrFarFromSavedPosition(testCase)
            system = HippocampalFormation();
            system.nearThreshold = 0.2;
            system.build();
            system.placeSystem.currentOutput = [0 1 0 1 0 1 0 1];
            system.animal.x = 1.1;
            system.animal.y = 0.1;
            result = system.savePositionForPlace([1.1 0.1], [2 4 6 8]);
            testCase.assertEqual(result, 2, 'new place'); 
            result = system.savePositionForPlace([1.1 0.2], [2 4 6 8]);
            testCase.assertEqual(result, 1, 'near place'); 
            result = system.savePositionForPlace([1.1 0.5], [2 4 6 8]);
            testCase.assertEqual(result, 0, 'far place'); 
            position = system.getPositionForPlace('[2 4 6 8]'); 
            testCase.assertEqual(position(1), 1.1, 'first position saved is maintained'); 
            testCase.assertEqual(position(2), 0.1, 'first position saved is maintained'); 

        end
        function testSettlesToOriginalPlaceWhenNear(testCase)
            system = HippocampalFormation();
            testCase.hf = system; 
            testCase.h=figure; 
            testCase.counter = 0; 
            hold on;  
            system.h = testCase.h;
            system.visual = true; 
            system.settleToPlace = true; 
            % system.animal.minimumRunVelocity = 0.05 ; 
            system.nGridOrientations = 3; 
            system.nHeadDirectionCells = 60; 
            system.gridDirectionBiasIncrement = pi/4;   
            system.gridExternalVelocity = true; 
            system.nGridGains = 1; 
            system.gridSize = [6,5];
            system.pullVelocity = false; 
            system.nFeatures = 3; 

            system.defaultFeatureDetectors = false; 
            system.updateFeatureDetectors = true;
            system.showIndices = true; 
            system.build();
            
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.distanceIntervals = 8;
            env.directionIntervals = 60;
            env.center = [1 1]; 
            env.build();
            system.lecSystem.setEnvironment(env); 
            env.setPosition([0.5 1]);             
%             env.setPosition([0.5 1]); 
            env.addCue([2 1]);  %  x   ------------- cue (at 0)
            env.addCue([0 0]);            
%             currentHeadDirection = 10;
%             system.lecSystem.buildCanonicalView(currentHeadDirection); 
            testCase.plotGrids();
            system.step(); % stepMec and stepPlace 
            testCase.plotGrids();
            system.step(); % stepMec and stepPlace 
            testCase.plotGrids();
            system.step(); % stepMec and stepPlace 
            testCase.plotGrids();
            system.step(); % stepMec and stepPlace 
            testCase.plotGrids();
%             mecOutput = [ 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
%                   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
%                   0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
%                   ];
%             testCase.assertEqual(system.mecOutput, mecOutput); 
%             lecOutput = system.lecOutput; 
%             testCase.assertEqual(lecOutput, ...
%                 [ 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
%                   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
%                   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
%                   0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
%                   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...                  
%                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
%                   ]);             
%             system.stepPlace(); % <==
            
%             placeOutput = system.placeOutput; 
% %             disp(placeOutput); 
%             mecLecOutput = [mecOutput, lecOutput]; 
%             testCase.assertEqual(system.mecOutputIndices(), ...
%                [17 33 87], 'original mec output');  % [17 33 87]
%             testCase.assertEqual(system.lecOutputIndices(), ...
%                [1 101 151], 'original lec output');  
%             testCase.assertEqual(system.placeSystem.outputIndices(), ...
%                [54 95 106 161 243 268]);  
            disp('about to move'); 
            % mimic small run
            system.updateTurnAndLinearVelocity(0, 0.0003); 
            system.stepMec();             
            testCase.plotGrids();
            system.stepMec();             
            testCase.plotGrids();
            system.stepMec();             
            testCase.plotGrids();
            system.stepMec();             
            testCase.plotGrids();
            system.stepMec();             
            testCase.plotGrids();
            system.stepMec();             
            testCase.plotGrids();
%             system.updateTurnAndLinearVelocity(0, 0.00015); 
            env.setPosition([0.6 1]);
            % calculate new place 
            system.stepHds(); 
            system.stepMec(); 
            system.stepLec(); 
            testCase.plotGrids();
            testCase.assertTrue(system.placeRecognized()); 
            testCase.assertEqual(system.placeSystem.outputIndices(), ...
               [54 95 106 161 243 268]); 
            testCase.assertEqual(system.mecOutputIndices(), ...
               [17 33 83], 'different mec output');  % [17 58 83] 17 33 83
            testCase.assertEqual(system.lecOutputIndices(), ...
               [1 100 151], 'different lec output');  
            
            system.settle(); 
            testCase.plotGrids();
            testCase.assertEqual(system.mecOutputIndices(), ...
               [17 33 87], 'settle back to original mec output');  
          
            
%             system.step(); 
%             testCase.assertEqual(system.placeSystem.outputIndices(), [56 63 119]); % [5 49 116]            
            
%             testCase.assertEqual(system.headDirectionSystem.featuresDetected, ...
%                 zeros(1,system.placeSystem.nCA3));
%             system.build();
%             system.placeSystem.currentOutput = [0 1 0 1 0 1 0 1];
%             system.animal.x = 1.1;
%             system.animal.y = 0.1;
%             result = system.savePositionForPlace([1.1 0.1], [2 4 6 8]);
%             testCase.assertEqual(result, 2, 'new place'); 
%             result = system.savePositionForPlace([1.1 0.2], [2 4 6 8]);
%             testCase.assertEqual(result, 1, 'near place'); 
%             result = system.savePositionForPlace([1.1 0.5], [2 4 6 8]);
%             testCase.assertEqual(result, 0, 'far place'); 
%             position = system.getPositionForPlace('[2 4 6 8]'); 
%             testCase.assertEqual(position(1), 1.1, 'first position saved is maintained'); 
%             testCase.assertEqual(position(2), 0.1, 'first position saved is maintained'); 

        end
        function plotGrids(testCase)
            testCase.counter = testCase.counter + 1; 
            figure(testCase.h); 
            subplot(2,3,1); 

            testCase.hf.grids(1).plotActivation(); 
            subplot(2,3,2); 
            testCase.hf.grids(2).plotActivation(); 
            subplot(2,3,3); 
            testCase.hf.grids(3).plotActivation(); 
            subplot(2,3,4);             
            title({'counter ',sprintf('t = %d',testCase.counter)})
            pause(1); 
        end
        
    end
end