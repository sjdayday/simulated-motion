classdef MoveTest < AbstractTest
    methods (Test)
        function testMoveExecutesRun(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            environment = Environment();
            environment.addWall([0 0],[0 2]); 
            environment.addWall([0 2],[2 2]); 
            environment.addWall([0 0],[2 0]); 
            environment.addWall([2 0],[2 2]);
            environment.build();            
            animal = Animal();
            animal.build();
            animal.place(environment, 1, 1, 0);
            v = animal.vertices; 
            testCase.assertEqual(v(1,:), [1 1.05]);                         
            testCase.assertEqual(v(2,:), [1 0.95]);                         
            testCase.assertEqual(v(3,:), [1.2 1.0]);    
            clockwiseness = 0; 
            turn = false;
            status = []; 
%             listenAndMark = true;
% readyAck? 
            move = Move('Move.', animal, 1, 3, clockwiseness, turn, status); 
           
            move.execute(); 
            testCase.assertTrue(move.behaviorStatus.isDone);
            testCase.assertEqual(move.distanceMoved, 3);
            vv = animal.vertices; 
            testCase.assertThat(vv(1,:), ...            
                 IsEqualTo([1.3 1.05], 'Within', RelativeTolerance(.00001))); 
            testCase.assertThat(vv(2,:), ...            
                 IsEqualTo([1.3 0.95], 'Within', RelativeTolerance(.00001))); 
            testCase.assertThat(vv(3,:), ...            
                 IsEqualTo([1.5 1.0], 'Within', RelativeTolerance(.00001))); 
        end
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
%             turn = Turn('', animal, -1, 1, 3, runner); 
            turn = true; 
            clockwiseness = -1;
%             listenAndMark = true; 
            move = Move('Move.', animal, 1, 3, clockwiseness, turn, status);             
            move.execute(); 
%             testCase.assertTrue(turn.isDone);
%             testCase.assertEqual(3, turn.distanceTurned);
            testCase.assertTrue(move.behaviorStatus.isDone);
            testCase.assertEqual(move.distanceMoved, 3);
            
        end
 
    end
end