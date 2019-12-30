classdef BehaviorTest < AbstractTest
    methods (Test)
        function testBehaviorStandardSemantics(testCase)
            behavior = TestingBehavior('', Animal(), []);
%             testCase.assertEqual(behavior.getPetriNetPath(), [cd, '/petrinet/']);
            testCase.assertEqual(behavior.behaviorStatus.getDefaultPetriNet(), 'base-control.xml');
%             testCase.assertEqual(behavior.buildPetriNetName(), [cd, '/petrinet/base-control.xml']);
            behavior.behaviorStatus.acknowledging = false; 
            behavior.buildStandardSemantics();
%             behavior.execute();            
            behavior.run();
            pause(1);  % wait for events 
            testCase.assertTrue(behavior.behaviorStatus.isDone);
        end
        function testBehaviorHasAccessToAnimalsSystems(testCase)
            animal = Animal();
            animal.build(); 
%             animal.headDirectionSystem = HeadDirectionSystem(60); 
            behavior = TestingBehavior('', animal, []);
            testCase.assertEqual(behavior.motorCortex, animal.motorCortex);
        end
        function testWhenIncludedBehaviorWillBePassedRunnerWithItsBehaviorStatus(testCase)
%  currently uninteresting, because only working use case is when 
%  Move passes a manually created Run/TurnBSInclude.  
%  Behavior.buildStatus doesn't currently call getIncludeStatus(obj)
% ... so of course passed behaviorStatus has the runner it originally created 
            animal = Animal();
            animal.build(); 
            status = [];
%             animal.headDirectionSystem = HeadDirectionSystem(60); 
            behavior = TestingBehavior('', animal, status);
            behavior.behaviorStatus.acknowledging = false;             
            behavior.behaviorStatus.buildRunner(); 
            runner = behavior.behaviorStatus.runner; 
            anotherBehavior = TestingBehavior('', animal, behavior.behaviorStatus);
            testCase.assertEqual(anotherBehavior.behaviorStatus.runner, runner);
%             anotherStatus = anotherBehavior.behaviorStatus; 
%             testCase.assertClass(anotherStatus, 'TestingBehaviorStatusInclude'); 
        end
        function testReturnsStandaloneBehaviorStatusForTurnOrRunWhenNonePassed(testCase)
            animal = Animal();
            animal.build(); 
            status = [];
%             animal.headDirectionSystem = HeadDirectionSystem(60); 
%             behavior = Behavior('', animal, status);
%             listenAndMark = true;
%             turn = Turn('Move.', animal, -1, 1, 3);             
            behavior = TestingBehavior('', animal, status);
            
%             behavior.buildStatus(status); 
            status  = behavior.behaviorStatus;
            testCase.assertClass(status, 'TestingBehaviorStatusStandalone'); 
        end
        
    end
end