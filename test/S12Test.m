classdef S12Test < AbstractTest
    methods (Test)
        function testSmallerHdsAndGridCellConfig(testCase)
            % TODO: nCueIntervals same as nHeadDirectionCells until
            % featureWeights / cueActivation discrepancy resolved in
            % lec.updateFeaturesDetected
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance        
            script = S12(false); 
%             script.runAll();
%             placeList = script.ec.animal.hippocampalFormation.placeListDisplay;
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.nHeadDirectionCells, 60); 
            testCase.assertEqual(script.ec.animal.hippocampalFormation.lecSystem.nHeadDirectionCells, 60);         
            testCase.assertEqual(script.ec.animal.hippocampalFormation.lecSystem.nOutput, 180); % 36
            testCase.assertEqual(script.ec.animal.hippocampalFormation.lecSystem.nCueIntervals, 60);
%             testCase.assertEqual(script.ec.animal.hippocampalFormation.lecSystem.nCueIntervals, 12);            
            testCase.assertEqual(script.ec.animal.hippocampalFormation.grids(1).nX, 6);             
            testCase.assertEqual(script.ec.animal.hippocampalFormation.grids(1).nY, 5);             
            testCase.assertEqual(script.ec.animal.hippocampalFormation.nMecOutput, 120);
            testCase.assertEqual(script.ec.animal.hippocampalFormation.nLecOutput, 180); % 36
            testCase.assertEqual(script.ec.animal.hippocampalFormation.placeSystem.nNeurons, 300); % 156  
            testCase.assertEqual(script.ec.animal.hippocampalFormation.placeSystem.nSynapses, 300); % 156
            testCase.assertEqual(script.ec.animal.hippocampalFormation.nFeatureDetectors, 300);  % 156
            testCase.assertEqual(script.ec.environment.directionIntervals, 60);            
%             testCase.assertThat(placeList(18,:), ...
%                 IsEqualTo([1 1 1  44  272  357  385  413  488  534], 'Within', RelativeTolerance(.1))); 
        end        
        function run20Steps(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance        
            script = S12(false); 
            script.runAll();
%             placeList = script.ec.animal.hippocampalFormation.placeListDisplay;
            testCase.assertEqual(script.ec.time, 28);
            testCase.assertThat(script.ec.animal.vertices, ...
                IsEqualTo([1.4580 1.2933; 1.5080 1.2067; 1.6562 1.3500], 'Within', RelativeTolerance(.001))); 
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), 33);
        end       

    end
end
