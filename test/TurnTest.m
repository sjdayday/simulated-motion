classdef TurnTest < AbstractTest
    methods (Test)
        function testTurnExecutedInOneCommand(testCase)
            environment = Environment();
            environment.addWall([0 0],[0 2]); 
            environment.addWall([0 2],[2 2]); 
            environment.addWall([0 0],[2 0]); 
            environment.addWall([2 0],[2 2]);
            environment.build();            
            animal = Animal();
            animal.build();
            animal.place(environment, 1, 1, 0);
            status = []; 
            build = true; 
%             listenAndMark = true;
%             turn = Turn('Move.', animal, -1, 1, 3);             
            turn = Turn('', animal, -1, 1, 3, status, build); 
            turn.execute(); 
            testCase.assertTrue(turn.behaviorStatus.isDone);
            testCase.assertEqual(3, turn.distanceTurned);
        end
        
    end
end