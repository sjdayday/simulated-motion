classdef S12Test < AbstractTest
    methods (Test)
        function testSmallerHdsAndGridCellConfig(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance        
            script = S12(false); 
%             script.runAll();
%             placeList = script.ec.animal.hippocampalFormation.placeListDisplay;
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.nHeadDirectionCells, 60); 
            testCase.assertEqual(script.ec.animal.hippocampalFormation.lecSystem.nHeadDirectionCells, 60);         
            testCase.assertEqual(script.ec.animal.hippocampalFormation.lecSystem.nOutput, 36);
            testCase.assertEqual(script.ec.animal.hippocampalFormation.lecSystem.nCueIntervals, 12);
            testCase.assertEqual(script.ec.animal.hippocampalFormation.grids(1).nX, 6);             
            testCase.assertEqual(script.ec.animal.hippocampalFormation.grids(1).nY, 5);             
            testCase.assertEqual(script.ec.animal.hippocampalFormation.nMecOutput, 120);
            testCase.assertEqual(script.ec.animal.hippocampalFormation.nLecOutput, 36);
            testCase.assertEqual(script.ec.animal.hippocampalFormation.placeSystem.nNeurons, 156);  
            testCase.assertEqual(script.ec.animal.hippocampalFormation.placeSystem.nSynapses, 156); 
            testCase.assertEqual(script.ec.animal.hippocampalFormation.nFeatureDetectors, 156);
            testCase.assertEqual(script.ec.environment.directionIntervals, 60);            
%             testCase.assertThat(placeList(18,:), ...
%                 IsEqualTo([1 1 1  44  272  357  385  413  488  534], 'Within', RelativeTolerance(.1))); 
        end        
    end
end