classdef S4Test < AbstractTest
    methods (Test)
        function testAnimalEvents(testCase)
            script = S4(); 
            testCase.assertEqual(script.ec.animal.minimumVelocity, pi/30); 
            script.run(5);
            testCase.assertEqual(script.ec.animal.minimumVelocity, pi/20); 
        end
    end
end
