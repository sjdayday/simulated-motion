classdef S14Test < AbstractTest
    methods (Test)
        function run10Steps(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance        
            script = S14(false); 
            script.runAll();
%             placeList = script.ec.animal.hippocampalFormation.placeListDisplay;
            testCase.assertEqual(script.ec.time, 20);
            testCase.assertThat(script.ec.animal.vertices, ...
                IsEqualTo([1.4103 0.9817; 1.3515 0.9008; 1.5427 0.8237], 'Within', RelativeTolerance(.001))); 
%                 IsEqualTo([1.5420 1.1020; 1.5525 1.0025; 1.7462 1.0732], 'Within', RelativeTolerance(.001))); 
            % was [1.4580 1.2933; 1.5080 1.2067; 1.6562 1.3500] at pi/6
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), 26);
            testCase.assertEqual(script.ec.animal.hippocampalFormation.placeOutputIndices(), [41 98]); 
        end       

    end
end
