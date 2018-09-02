classdef TurnTest < AbstractTest
    methods (Test)
        function testTurnsForMarkedDistanceThenDone(testCase)
            turn = Turn(); 
            turn.markPlace('Move.Turn.Clockwise');
            turn.markPlace('Move.Turn.Speed');
            turn.markPlaceMultipleTokens('Move.Turn.Distance', 3); 
            turn.run();
            pause(1); 
            testCase.assertTrue(turn.isDone);
            testCase.assertEqual(3, turn.distanceTurned);
        end
    end
end