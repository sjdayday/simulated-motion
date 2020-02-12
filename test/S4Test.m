classdef S4Test < AbstractTest
    methods (Test)
        function testAnimalEvents(testCase)
            script = S4(false); 
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.minimumVelocity, pi/20); 
            script.run(5);
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.minimumVelocity, pi/30); 
            testCase.assertEqual(script.ec.getTime(), 5); 
        end
        function testLongRunningBehaviorTriggersStep(testCase)
            script = S4(false); 
            script.run(12);
%             turn x 10
%             pause(10);
            testCase.assertEqual(script.ec.getTime(), 22); 
        end
        function testOrientAnimalDrivesHdsBack(testCase)
            % when PN is done, should stop angular motion of HDS 
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            script = S4(false); 
            script.run(12);
%             turn x 10
%             pause(2);
            testCase.assertEqual(script.ec.getTime(), 22); 
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                51); % was 29 
            v = script.ec.animal.vertices; 
            testCase.assertThat(v(1,:), ...            
                 IsEqualTo([1 1.05], 'Within', RelativeTolerance(.0001))); 
            testCase.assertThat(v(2,:), ...            
                 IsEqualTo([1 0.95], 'Within', RelativeTolerance(.0001))); 
            testCase.assertThat(v(3,:), ...            
                 IsEqualTo([1.2 1], 'Within', RelativeTolerance(.0001)));    
%             testCase.assertEqual(script.ec.getTime(), 22); 
            script.run(5);
%             testCase.assertEqual(script.ec.getTime(), 24); 
%             testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
%                 20); 
%             script.run(1);
            testCase.assertEqual(script.ec.getTime(), 27); 
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                59); % was 5
            script.run(8);
%             pause(10);
            testCase.assertEqual(script.ec.getTime(), 30); 
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                60); 
            
        end
        
    end
end
