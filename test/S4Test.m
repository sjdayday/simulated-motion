classdef S4Test < AbstractTest
    methods (Test)
        function testAnimalEvents(testCase)
            script = S4(); 
            testCase.assertEqual(script.ec.animal.minimumVelocity, pi/30); 
            script.run(5);
            testCase.assertEqual(script.ec.animal.minimumVelocity, pi/20); 
            testCase.assertEqual(script.ec.getTime(), 5); 
        end
        function testLongRunningBehaviorTriggersStep(testCase)
            script = S4(); 
            script.run(12);
%             turn x 10
            pause(30);
            testCase.assertEqual(script.ec.getTime(), 22); 
        end
        function testOrientAnimalDisplaysCorrectly(testCase)
            script = S4(); 
            script.run(11);
%             turn x 10
%             pause(30);
%             testCase.assertEqual(script.ec.getTime(), 22); 
        end
        
    end
end
