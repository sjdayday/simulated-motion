classdef RunTest < AbstractTest
    methods (Test)
        function testRunExecutedInOneCommand(testCase)
            environment = Environment();
            environment.addWall([0 0],[0 2]); 
            environment.addWall([0 2],[2 2]); 
            environment.addWall([0 0],[2 0]); 
            environment.addWall([2 0],[2 2]);
            environment.build();            
            animal = Animal();
            animal.build();
            animal.place(environment, 1, 1, 0);
            run = Run('Move.', animal, 1, 3); 
            testCase.assertTrue(run.isDone);
            testCase.assertEqual(3, run.distanceRun);
        end
        
    end
end