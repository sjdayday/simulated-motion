classdef TurnTest < AbstractTest
    methods (Test)
%         function testTurnsForMarkedDistanceThenDone(testCase)
%             turn = Turn('Move.Turn.', Animal()); 
%             turn.markPlace('Move.Turn.Clockwise');
%             turn.markPlace('Move.Turn.Speed');
%             turn.markPlaceMultipleTokens('Move.Turn.Distance', 3); 
%             turn.run();
%             pause(1); 
%             testCase.assertTrue(turn.isDone);
%             testCase.assertEqual(3, turn.distanceTurned);
%         end
        function testTurnExecutedInOneCommand(testCase)
            turn = Turn('Move.Turn.', Animal(), -1, 1, 3); 
%             turn.markPlace('Move.Turn.Clockwise');
%             turn.markPlace('Move.Turn.Speed');
%             turn.markPlaceMultipleTokens('Move.Turn.Distance', 3); 
%             turn.run();
%             pause(1); 
%   test Clockwise vs counter 
            testCase.assertTrue(turn.isDone);
            testCase.assertEqual(3, turn.distanceTurned);
        end
        
    end
end