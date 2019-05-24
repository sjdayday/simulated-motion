classdef LecSystemTest < AbstractTest
    methods (Test)
        function testCreateLecSystem(testCase)
            lec = LecSystem();
%             lec.distanceUnits = 8;
            lec.nHeadDirectionCells = 60;
            lec.nFeatures = 3; 
%             lec.rewardUnits = 5; 
            lec.build(); 
%             testCase.assertEqual(lec.nOutput, 209); 
            testCase.assertEqual(lec.nOutput, 180); 
        end
        function testBuildsCanonicalRepresentationInvaryingWithHeadDirection(testCase)
            lec = LecSystem();
%             lec.distanceUnits = 8;
            lec.nHeadDirectionCells = 60;
            lec.nFeatures = 3; 
%             lec.rewardUnits = 5; 
            lec.build(); 
            
%             testCase.assertEqual(lec.nOutput, 209); 
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
%             env.setPosition([0.5 1]); 
            env.addCue([2 1]);  %  x   ------------- cue (at 0)
            env.addCue([0 0]);            
%             env.setHeadDirection(1); % 0
%             disp(['1: ', num2str(env.cueHeadDirectionOffset(1))]); 
%             disp(['2: ', num2str(env.cueHeadDirectionOffset(2))]); 
%             wallDirection = env.closestWallDirection(); 
%             disp(['wall: ', num2str(env.headDirectionOffset(wallDirection))]); 
            lec.setEnvironment(env); 
            currentHeadDirection = 10;
            lec.buildCanonicalView(currentHeadDirection); 
%             env.setHeadDirection(11); % pi/3
% canonical view:  
%   head direction when pointing at most salient cue: 1-60
%   head direction offset from most salient cue head direction 61-120
%   direction to closest wall from most salient cue head direction 121-180
            testCase.assertEqual(lec.lecOutput, ...
                [ 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...                  
                  1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  ]); 
            currentHeadDirection = 50;
            lec.buildCanonicalView(currentHeadDirection); 
            testCase.assertEqual(lec.lecOutput, ...
                [ 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...                  
                  1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  ], ...
              'same output; canonical view does not depend on current head direction '); 
            
        end
    end
end