classdef S5Test < AbstractTest
    methods (Test)
        function testTurnAndRun(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            script = S5(); 
            script.runAll();
%             turn x 10
%             pause(30);
            v = script.ec.animal.vertices; 
            testCase.assertThat(v(1,:), ...            
                 IsEqualTo([0.6822 0.8165], 'Within', RelativeTolerance(.0001))); 
            testCase.assertThat(v(2,:), ...            
                 IsEqualTo([0.6322 0.9031], 'Within', RelativeTolerance(.0001))); 
            testCase.assertThat(v(3,:), ...            
                 IsEqualTo([0.4840 0.7598], 'Within', RelativeTolerance(.0001)));    
%             testCase.assertEqual(script.ec.getTime(), 22); 
%             testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
%                 22); 
             % HDS is not tracking 
        end
        
    end
end
