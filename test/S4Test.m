classdef S4Test < AbstractTest
    methods (Test)
        function testAnimalEvents(testCase)
            script = S4(); 
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.minimumVelocity, pi/20); 
            script.run(5);
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.minimumVelocity, pi/30); 
            testCase.assertEqual(script.ec.getTime(), 5); 
        end
        function testLongRunningBehaviorTriggersStep(testCase)
            script = S4(); 
            script.run(12);
%             turn x 10
            pause(10);
            testCase.assertEqual(script.ec.getTime(), 22); 
        end
        function testOrientAnimalDrivesHdsBack(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            script = S4(); 
            script.run(12);
%             turn x 10
            pause(2);
            testCase.assertEqual(script.ec.getTime(), 22); 
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                19); 
            v = script.ec.animal.vertices; 
            testCase.assertThat(v(1,:), ...            
                 IsEqualTo([1 1.05], 'Within', RelativeTolerance(.0001))); 
            testCase.assertThat(v(2,:), ...            
                 IsEqualTo([1 0.95], 'Within', RelativeTolerance(.0001))); 
            testCase.assertThat(v(3,:), ...            
                 IsEqualTo([1.2 1], 'Within', RelativeTolerance(.0001)));    
%             testCase.assertEqual(script.ec.getTime(), 22); 
            script.run(3);
%             testCase.assertEqual(script.ec.getTime(), 24); 
%             testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
%                 20); 
%             script.run(1);
            testCase.assertEqual(script.ec.getTime(), 25); 
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                14); 
            script.run(10);
%             pause(10);
            testCase.assertEqual(script.ec.getTime(), 35); 
            testCase.assertEqual(script.ec.animal.hippocampalFormation.headDirectionSystem.getMaxActivationIndex(), ...
                60); 
            
        end
        
    end
end
