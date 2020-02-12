classdef S13Test < AbstractTest
    methods (Test)
        function testSmallerHdsAndGridCellConfig(testCase)
            % TODO: nCueIntervals same as nHeadDirectionCells until
            % featureWeights / cueActivation discrepancy resolved in
            % lec.updateFeaturesDetected
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance        
            script = S13(false); 
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.nHeadDirectionCells, 30); 
            testCase.assertEqual(script.ec.animal.hippocampalFormation.lecSystem.nHeadDirectionCells, 30);         
            testCase.assertEqual(script.ec.animal.hippocampalFormation.lecSystem.nOutput, 30); % <<36
            testCase.assertEqual(script.ec.animal.hippocampalFormation.lecSystem.nCueIntervals, 30);
            testCase.assertEqual(script.ec.animal.hippocampalFormation.grids(1).nX, 6);             
            testCase.assertEqual(script.ec.animal.hippocampalFormation.grids(1).nY, 5);             
            testCase.assertEqual(script.ec.animal.hippocampalFormation.nMecOutput, 120);
            testCase.assertEqual(script.ec.animal.hippocampalFormation.nLecOutput, 30); % 36 <<
            testCase.assertEqual(script.ec.animal.hippocampalFormation.placeSystem.nNeurons, 150); % 156  
            testCase.assertEqual(script.ec.animal.hippocampalFormation.placeSystem.nSynapses, 150); % 156
            testCase.assertEqual(script.ec.animal.hippocampalFormation.nFeatureDetectors, 150);  % 156
            testCase.assertEqual(script.ec.environment.directionIntervals, 30);            
        end        
        function run40Steps(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance        
            script = S13(false); 
            script.runAll();
%             placeList = script.ec.animal.hippocampalFormation.placeListDisplay;
            testCase.assertEqual(script.ec.time, 48);
            testCase.assertThat(script.ec.animal.vertices, ...
                IsEqualTo([0.9706 1.0595; 1.0294 1.1405; 0.8382 1.2176], 'Within', RelativeTolerance(.001))); 
%                 IsEqualTo([1.5420 1.1020; 1.5525 1.0025; 1.7462 1.0732], 'Within', RelativeTolerance(.001))); 
            % was [1.4580 1.2933; 1.5080 1.2067; 1.6562 1.3500] at pi/6
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), 8);
            testCase.assertEqual(script.ec.animal.hippocampalFormation.placeOutputIndices(), [116 132]); 
        end       

    end
end
