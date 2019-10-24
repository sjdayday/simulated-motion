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
        function testCalculatesAngleToCue(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.addCue([2 1]); % 0 
            env.addCue([0 1]); % pi
            env.addCue([1 2]); % pi/2
            env.addCue([2 2]); % pi/4
            env.addCue([0 0]); % pi*5/4
            env.build(); 
            env.setPosition([1 1]); 
%             env.setDirection(pi/4); 
            testCase.assertThat(env.cueDirection(1), ...            
                IsEqualTo(0, 'Within', RelativeTolerance(.00000000001))); 
            testCase.assertThat(env.cueDirection(2), ...            
                IsEqualTo(pi, 'Within', RelativeTolerance(.00000000001))); 
            testCase.assertThat(env.cueDirection(3), ...            
                IsEqualTo(pi/2, 'Within', RelativeTolerance(.00000000001))); 
            testCase.assertThat(env.cueDirection(4), ...            
                IsEqualTo(pi/4, 'Within', RelativeTolerance(.00000000001))); 
            testCase.assertThat(env.cueDirection(5), ...            
                IsEqualTo(pi*5/4, 'Within', RelativeTolerance(.00000000001))); 
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
            % direction interpreted as direction when pointed at most
            % salient cue.  Then, calculate angle to various other cues.
            env.setDirection(pi/4); 
            testCase.assertThat(env.cueDirectionOffset(1), ...            
                IsEqualTo(1.107148717794091, 'Within', RelativeTolerance(.00000000001))); 
            testCase.assertThat(env.cueDirectionOffset(2), ...            
                IsEqualTo(2.677945044588987, 'Within', RelativeTolerance(.00000000001))); 
            env.setDirection(0); 
            % direction given in radians counter-clockwise in 0 - 2*pi
            testCase.assertThat(env.cueDirectionOffset(2), ...            
                IsEqualTo(3.463343207986435, 'Within', RelativeTolerance(.00000000001))); 
            testCase.assertThat(env.cueDirectionOffset(3), ...            
                IsEqualTo(4.390638425988048, 'Within', RelativeTolerance(.00000000001))); 
            env.setPosition([0 0]); 
            % 7*pi/4
            testCase.assertThat(env.cueDirectionOffset(3), ...            
                IsEqualTo(5.497787143782138, 'Within', RelativeTolerance(.00000000001))); 
        end
        function testCalculatesAngleAndHeadDirectionFromDirectionToClosestWall(testCase)
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
            wallDirection = env.closestWallDirection(); 
            testCase.assertThat(wallDirection, ...            
                IsEqualTo(2.356194490192345, 'Within', RelativeTolerance(.00000000001))); 
            testCase.assertEqual(env.headDirectionOffset(wallDirection), 22);
            % pi/4
            env.setPosition([1 1.5]);             
            wallDirection = env.closestWallDirection(); 
            testCase.assertThat(wallDirection, ...            
                IsEqualTo(0.785398163397448, 'Within', RelativeTolerance(.00000000001))); 
            testCase.assertEqual(env.headDirectionOffset(wallDirection), 7);
            % 7*pi/4
            env.setPosition([1.5 1]);             
            wallDirection = env.closestWallDirection(); 
            testCase.assertThat(wallDirection, ...                        
                IsEqualTo(5.497787143782138, 'Within', RelativeTolerance(.00000000001))); 
            testCase.assertEqual(env.headDirectionOffset(wallDirection), 52);
            % 5*pi/4
            env.setPosition([1 0.5]);             
            wallDirection = env.closestWallDirection(); 
            testCase.assertThat(wallDirection, ...            
                IsEqualTo(3.926990816987241, 'Within', RelativeTolerance(.00000000001))); 
            testCase.assertEqual(env.headDirectionOffset(wallDirection), 37);
        end
        function testBoundaryAt2PiOrGreaterOffsetFromCurrentDirection(testCase) 
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.directionIntervals = 60;

            testCase.assertEqual(env.headDirectionOffset(2*pi), 0, ...
                '2*pi = 0, so no offset');
            testCase.assertEqual(env.headDirectionOffset(3*pi), 0, ...
                '3*pi exceeds possible, so no offset');

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
            env.setPosition([1 1]);             
%             env.setPosition([0.5 1]); 
            env.addCue([2 1]); %  x   ------------- cue (at 0)
           
            env.setDirection(pi/2);
            testCase.assertEqual(env.cueHeadDirectionOffset(1), 45);
            env.setDirection(3*pi/2);
            testCase.assertEqual(env.cueHeadDirectionOffset(1), 15);
            env.setDirection(0);
            testCase.assertEqual(env.cueHeadDirectionOffset(1), 0);
            env.setDirection(0.0001);
            testCase.assertEqual(env.cueHeadDirectionOffset(1), 59);
            env.setDirection((2*pi)*0.99);
            testCase.assertEqual(env.cueHeadDirectionOffset(1), 0);
            env.setDirection((2*pi));
            testCase.assertEqual(env.cueHeadDirectionOffset(1), 0);

%             env.setDirection(5*pi/3);
%             disp(['5*pi/3 ', num2str(env.cueHeadDirectionOffset(1))]); 
%             env.setDirection(pi/2*1.15);
%             disp(['pi/2*1.15 ', num2str(env.cueHeadDirectionOffset(1))]); 
%             env.setDirection(pi/2*1.1);
%             disp(['pi/2*1.1 ', num2str(env.cueHeadDirectionOffset(1))]); 
%             env.setDirection(pi/2*1.05);
%             disp(['pi/2*1.05 ', num2str(env.cueHeadDirectionOffset(1))]); 
%             env.setDirection(pi/2*1.02);
%             disp(['pi/2*1.02 ', num2str(env.cueHeadDirectionOffset(1))]); 
        end

        function testCalculatesHeadDirectionCellOffsetFromCurrentHeadDirection(testCase)
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
            env.setPosition([1 1]);             
%             env.setPosition([0.5 1]); 
            env.addCue([2 1]);  %  x   ------------- cue (at 0)
            env.setHeadDirection(16);
            testCase.assertEqual(env.cueHeadDirectionOffset(1), 45);
            env.setHeadDirection(46);
            testCase.assertEqual(env.cueHeadDirectionOffset(1), 15);
            env.setHeadDirection(1);
            testCase.assertEqual(env.cueHeadDirectionOffset(1), 0);
            env.setHeadDirection(2);
            testCase.assertEqual(env.cueHeadDirectionOffset(1), 59);
            env.setHeadDirection(60);
            testCase.assertEqual(env.cueHeadDirectionOffset(1), 1);
            env.setHeadDirection(59);
            testCase.assertEqual(env.cueHeadDirectionOffset(1), 2);
%             env.setDirection((2*pi));
%             testCase.assertEqual(env.cueHeadDirectionOffset(1), 2);
        end
%         function testCalculatesHeadDirectionCellOffsetFromAnotherDirection(testCase)
% %             import matlab.unittest.constraints.IsEqualTo
% %             import matlab.unittest.constraints.RelativeTolerance
%             env = Environment();
%             env.addWall([0 0],[0 2]); 
%             env.addWall([0 2],[2 2]); 
%             env.addWall([0 0],[2 0]); 
%             env.addWall([2 0],[2 2]);
%             env.distanceIntervals = 8;
%             env.directionIntervals = 60;
%             env.center = [1 1]; 
%             env.build();  
%             env.setPosition([1 1]);             
%             
%             % animal:  obj.currentDirection (radians) 
%             % env.setHeadDirection(16);
%             % shared position
% %             env.setPosition([0.5 1]); 
%             env.addCue([2 1]);  %  x   ------------- cue (at 0)
%             env.setHeadDirection(16);
%             testCase.assertEqual(env.cueHeadDirectionOffset(1), 45);
%             env.setHeadDirection(46);
%             testCase.assertEqual(env.cueHeadDirectionOffset(1), 15);
%             env.setHeadDirection(1);
%             testCase.assertEqual(env.cueHeadDirectionOffset(1), 0);
%             env.setHeadDirection(2);
%             testCase.assertEqual(env.cueHeadDirectionOffset(1), 59);
%             env.setHeadDirection(60);
%             testCase.assertEqual(env.cueHeadDirectionOffset(1), 1);
%             env.setHeadDirection(59);
%             testCase.assertEqual(env.cueHeadDirectionOffset(1), 2);
% %             env.setDirection((2*pi));
% %             testCase.assertEqual(env.cueHeadDirectionOffset(1), 2);
%         end
        function testCalculatesHeadDirectionCellOffsetFromVariousPositions(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.distanceIntervals = 8;
            env.directionIntervals = 60;
            env.center = [1 1]; 
            env.build();  
            env.setPosition([1 1]);             
%             env.setPosition([0.5 1]); 
            env.addCue([2 1]);  %  x   ------------- cue (at 0)
            env.setHeadDirection(16);
            testCase.assertEqual(env.cueHeadDirectionOffset(1), 45);
            % same cue and head direction, new position
            env.setPosition([1 1.5]);             
            testCase.assertEqual(env.cueHeadDirectionOffset(1), 40);
        end
    end
end