classdef EnvironmentTest < AbstractTest
    methods (Test)
        function testCalculatesAbsoluteDistanceToClosestWall(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            testCase.assertEqual(size(env.walls,1), 2);             
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build(); 
            testCase.assertEqual(size(env.walls,1), 4); 
            env.setPosition([0.5 0.25]); 
            testCase.assertEqual(env.closestWallDistance(), 0.25);             
            env.setPosition([0.15 0.25]); 
            testCase.assertEqual(env.closestWallDistance(), 0.15);             
            env.setPosition([0 0.25]); 
            testCase.assertEqual(env.closestWallDistance(), 0);             
            env.setPosition([1 -0.25]); 
            testCase.assertEqual(env.closestWallDistance(), 0.25);                       
        end
        function testCalculatesRelativeDistanceToCues(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.addCue([0 4]); 
            env.addCue([-2 0]); 
            env.distanceIntervals = 8;
            env.center = [1 1]; 
            env.build(); 
            testCase.assertEqual(size(env.cues,1), 2); 
            env.setPosition([0 0]); 
            testCase.assertEqual(env.cueDistance(1), 4);             
            testCase.assertEqual(env.cueDistance(2), 2);
            % worst case assumed to be twice distance from center to
            % farthest cue.
            testCase.assertThat(env.relativeDistanceInterval, ...            
                IsEqualTo(2*0.451753951452626, 'Within', RelativeTolerance(.00000000001))); 
            env.setPosition([2 -2]); 
            testCase.assertEqual(env.cueRelativeDistance(1), 8);
            env.setPosition([1 1]); 
            testCase.assertEqual(env.cueRelativeDistance(1), 4);
            env.setPosition([0 3.5]); 
            testCase.assertEqual(env.cueRelativeDistance(1), 1);
            env.setPosition([0 3]); 
            testCase.assertEqual(env.cueRelativeDistance(1), 2);
            env.setPosition([0 1]); 
            testCase.assertEqual(env.closestWallRelativeDistance(), 1);
            env.setPosition([0.5 0.25]); 
            testCase.assertEqual(env.closestWallRelativeDistance(), 1);
            env.setPosition([1 0.95]); 
            testCase.assertEqual(env.closestWallRelativeDistance(), 2);
        end
        function testCalculatesAngleFromDirectionToCue(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.addCue([0 4]); 
            env.addCue([-2 0]); 
            env.addCue([0.5 -0.5]); 
            env.distanceIntervals = 8;
            env.directionIntervals = 60;
            env.center = [1 1]; 
            env.build(); 
            env.setPosition([1 1]); 
            env.setDirection(pi/4); 
            testCase.assertThat(env.cueDirection(1), ...            
                IsEqualTo(1.107148717794091, 'Within', RelativeTolerance(.00000000001))); 
            testCase.assertThat(env.cueDirection(2), ...            
                IsEqualTo(2.677945044588987, 'Within', RelativeTolerance(.00000000001))); 
            env.setDirection(0); 
            % direction given in radians counter-clockwise in 0 - 2*pi
            testCase.assertThat(env.cueDirection(2), ...            
                IsEqualTo(3.463343207986435, 'Within', RelativeTolerance(.00000000001))); 
            testCase.assertThat(env.cueDirection(3), ...            
                IsEqualTo(4.390638425988048, 'Within', RelativeTolerance(.00000000001))); 
            env.setPosition([0 0]); 
            testCase.assertThat(env.cueDirection(3), ...            
                IsEqualTo(5.497787143782138, 'Within', RelativeTolerance(.00000000001))); 
        end
        function testCalculatesAngleFromDirectionToClosestWall(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.distanceIntervals = 8;
            env.directionIntervals = 60;
            env.center = [1 1]; 
            env.build(); 
            env.setPosition([0.5 1]); 
            env.setDirection(pi/4);
            % 3*pi/4
            testCase.assertThat(env.closestWallDirection(), ...            
                IsEqualTo(2.356194490192345, 'Within', RelativeTolerance(.00000000001))); 
            % pi/4
            env.setPosition([1 1.5]);             
            testCase.assertThat(env.closestWallDirection(), ...            
                IsEqualTo(0.785398163397448, 'Within', RelativeTolerance(.00000000001))); 
            % 7*pi/4
            env.setPosition([1.5 1]);             
            testCase.assertThat(env.closestWallDirection(), ...            
                IsEqualTo(5.497787143782138, 'Within', RelativeTolerance(.00000000001))); 
            % 5*pi/4
            env.setPosition([1 0.5]);             
            testCase.assertThat(env.closestWallDirection(), ...            
                IsEqualTo(3.926990816987241, 'Within', RelativeTolerance(.00000000001))); 
        end
        function testCalculatesHeadDirectionCellOffsetToCueFromCurrentDirection(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.distanceIntervals = 8;
            env.directionIntervals = 60;
            env.center = [1 1]; 
            env.build();  
            env.setPosition([1 1.5]);             
%             env.setPosition([0.5 1]); 
            env.setDirection(pi/4);
            % 60 9 8 7 6 5 4 3 2 1 0 9 8 7 6 45
            % 3*pi/4
            % pi/4            
%  next FIXME            testCase.assertEqual(env.relativeDirection(env.closestWallDirection()), 53);
% %             testCase.assertThat(env.closestWallDirection(), ...            
% %                 IsEqualTo(2.356194490192345, 'Within', RelativeTolerance(.00000000001))); 
% %             % pi/4
% %             env.setPosition([1 1.5]);             
% %             testCase.assertThat(env.closestWallDirection(), ...            
% %                 IsEqualTo(0.785398163397448, 'Within', RelativeTolerance(.00000000001))); 
% %             % 7*pi/4
% %             env.setPosition([1.5 1]);             
% %             testCase.assertThat(env.closestWallDirection(), ...            
% %                 IsEqualTo(5.497787143782138, 'Within', RelativeTolerance(.00000000001))); 
% %             % 5*pi/4
% %             env.setPosition([1 0.5]);             
% %             testCase.assertThat(env.closestWallDirection(), ...            
% %                 IsEqualTo(3.926990816987241, 'Within', RelativeTolerance(.00000000001))); 
        end
    end
end