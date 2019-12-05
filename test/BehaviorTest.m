classdef BehaviorTest < AbstractTest
    methods (Test)
        function testBehaviorStandardSemantics(testCase)
            behavior = Behavior('', Animal());
%             testCase.assertEqual(behavior.getPetriNetPath(), [cd, '/petrinet/']);
            testCase.assertEqual(behavior.getDefaultPetriNet(), 'base-control.xml');
%             testCase.assertEqual(behavior.buildPetriNetName(), [cd, '/petrinet/base-control.xml']);
            behavior.buildStandardSemantics();
            behavior.run();
            pause(1);  % wait for events 
            testCase.assertTrue(behavior.isDone);
        end
        function testBehaviorHasAccessToAnimalsSystems(testCase)
            animal = Animal();
            animal.build(); 
%             animal.headDirectionSystem = HeadDirectionSystem(60); 
            behavior = Behavior('', animal);
            testCase.assertEqual(behavior.motorCortex, animal.motorCortex);
        end
    end
end