classdef RunTest < AbstractTest
    methods (Test)
        function testRunExecutedInOneCommand(testCase)
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
%             run = Run('Move.', animal, 1, 3); 
            status = []; 
            build = true; 
%             listenAndMark = true; 
            run = Run('', animal, 1, 3, status, build);             
%             run = Run('', animal, 1, 3, runner);             
            run.execute(); 
            testCase.assertTrue(run.behaviorStatus.isDone);
            testCase.assertEqual(3, run.distanceRun);
            vv = animal.vertices; 
            testCase.assertThat(vv(1,:), ...            
                 IsEqualTo([1.3 1.05], 'Within', RelativeTolerance(.00001))); 
            testCase.assertThat(vv(2,:), ...            
                 IsEqualTo([1.3 0.95], 'Within', RelativeTolerance(.00001))); 
            testCase.assertThat(vv(3,:), ...            
                 IsEqualTo([1.5 1.0], 'Within', RelativeTolerance(.00001))); 
%             testCase.assertThat(animal.x, ...            
%                  IsEqualTo(1.3, 'Within', RelativeTolerance(.00001))); 
%             testCase.assertEqual(vv(1,:), [1.3 1.05]);                         
%             testCase.assertEqual(vv(2,:), [1.3 0.95]);                         
%             testCase.assertEqual(vv(3,:), [1.5 1.0]);                         

        end
        
    end
end