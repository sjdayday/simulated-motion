classdef S8Test < AbstractTest
    methods (Test)
        function testSomePlacesAreCloseOnReturnRunWithForcedHds(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance        
            script = S8(false); 
            script.runAll();
            placeList = script.ec.animal.hippocampalFormation.placeListDisplay;
            testCase.assertEqual(size(placeList), [24 10]); 
            testCase.assertThat(placeList(20,:), ...
                IsEqualTo([1 1 1  44  272  352  385  413  488  534], 'Within', RelativeTolerance(.1))); 
        end        
    end
end
