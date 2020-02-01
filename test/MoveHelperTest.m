classdef MoveHelperTest < AbstractTest
    methods (Test)
        function testMoveHelperCreatesMove(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            animal = Animal();
            animal.pullVelocityFromAnimal = false; 
            animal.build(); 
            animal.place(env, 1, 1, 0);
            motorCortex = animal.motorCortex; 
            helper = MoveHelper(motorCortex);
            behavior = motorCortex.turnBehavior; 
            distance = 15; 
            clockwiseness = 1; 
            speed = 1; 
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 58);             
            createdBehavior = helper.move(behavior, distance, speed, clockwiseness); 
%             aMove = Move(obj.movePrefix, obj.animal, obj.runSpeed, obj.runDistance, obj.clockwiseness, turn, obj.getMoveBehaviorStatus(), build);             
%             motorCortex.turnDistance = 15;

%             motorCortex.counterClockwiseTurn();
            testCase.assertClass(createdBehavior, 'Move');
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 21);
            distance = 5; 
            clockwiseness = 0; 
            speed = 1; 
            behavior = motorCortex.runBehavior; 
%             motorCortex.runSpeed = 1; 
%             motorCortex.runDistance = 5; 
%             motorCortex.run(); 
            helper.move(behavior, distance, speed, clockwiseness); 
%             testCase.assertEqual(createdBehavior, motorCortex.runBehavior);
            testCase.assertThat(animal.x, ...            
                 IsEqualTo(1, 'Within', RelativeTolerance(.00001))); 
            testCase.assertThat(animal.y, ...            
                 IsEqualTo(1.5, 'Within', RelativeTolerance(.00001))); 
            testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 21); 
        end
        
    end
end