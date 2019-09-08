classdef S6Test < AbstractTest
    methods (Test)
        function testTurnAndRun(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            import matlab.unittest.constraints.AbsoluteTolerance        
            script = S6(false); 
            script.runAll();
%             turn x 10
%             pause(30);
            v = script.ec.animal.vertices; 
            testCase.assertThat(v(1,:), ...            
                 IsEqualTo([1.7066 0.3242], 'Within', RelativeTolerance(.0001))); 
            testCase.assertThat(v(2,:), ...            
                 IsEqualTo([1.6115 0.2933], 'Within', RelativeTolerance(.0001))); 
            testCase.assertThat(v(3,:), ...            
                 IsEqualTo([1.7208 0.1185], 'Within', AbsoluteTolerance(.0001)));    
%             testCase.assertEqual(script.ec.getTime(), 22); 
            testCase.assertThat(script.ec.animal.currentDirection, ...            
                 IsEqualTo(-1.2566, 'Within', RelativeTolerance(.0001)));    
             testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                 45, 'head direction system somewhat out of sync with real direction'); 
        end        
    end
end
