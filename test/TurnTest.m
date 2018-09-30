classdef TurnTest < AbstractTest
    methods (Test)
        function testTurnExecutedInOneCommand(testCase)
            animal = Animal();
            animal.build();
            turn = Turn('Move.Turn.', animal, -1, 1, 3); 
            testCase.assertTrue(turn.isDone);
            testCase.assertEqual(3, turn.distanceTurned);
        end
        
    end
end