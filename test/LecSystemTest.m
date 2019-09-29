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
        function testCreateLecSystemWithSmallerCueIntervals(testCase)
            lec = LecSystem();
%             lec.distanceUnits = 8;
            lec.nHeadDirectionCells = 60;
            lec.nCueIntervals = 12; 
            lec.nFeatures = 3; 
%             lec.rewardUnits = 5; 
            lec.build(); 
%             testCase.assertEqual(lec.nOutput, 209); 
            testCase.assertEqual(lec.nOutput, 36, '3 features * 12 cue intervals'); 
        end
        function testLecOutputAllocatesCueDirectionIntoCueIntervals(testCase)
            lec = LecSystem();
%             lec.distanceUnits = 8;
            lec.nHeadDirectionCells = 60;
            lec.nCueIntervals = 6; 
            lec.nFeatures = 3; 
%             lec.rewardUnits = 5; 
            lec.build(); 
%             testCase.assertEqual(lec.nOutput, 209); 
            testCase.assertEqual(lec.lecOutput, zeros(1,18)); 
            testCase.assertEqual(lec.index, 0);
            lec.updateLecOutput(1);
            testCase.assertEqual(lec.lecOutput, [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ]); 
            testCase.assertEqual(lec.index, 6, 'offset by cue intervals'); 
            lec.index = 0; % reset
            lec.updateLecOutput(3);
            testCase.assertEqual(lec.lecOutput, [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ], ...
                'still in the first cue interval'); 
            lec.index = 0; % reset
            lec.updateLecOutput(10);
            testCase.assertEqual(lec.lecOutput, [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ], ...
                'still in the first cue interval'); 
            lec.index = 0; % reset
            lec.lecOutput = zeros(1,18);
            lec.updateLecOutput(11);
            testCase.assertEqual(lec.lecOutput, [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ], ...
                'second cue interval'); 
            lec.updateLecOutput(20);
            testCase.assertEqual(lec.lecOutput, [0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 ], ...
                'second cue interval, in second index offset'); 
            lec.updateLecOutput(31);
            testCase.assertEqual(lec.lecOutput, [0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 ], ...
                'fourth cue interval, in third index offset'); 
            lec.index = 0; % reset
            lec.lecOutput = zeros(1,18);
            lec.updateLecOutput(59);
            testCase.assertEqual(lec.lecOutput, [0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 ], ...
                'sixth cue interval, in first index offset'); 
            lec.index = 0; % reset
            lec.lecOutput = zeros(1,18);
            lec.updateLecOutput(60);
            testCase.assertEqual(lec.lecOutput, [0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 ], ...
                'sixth cue interval, in first index offset');  
        end        
        function testEnvironmentTwoCuesPresenceForcesFeaturesToThree(testCase)
            lec = LecSystem();
%             lec.distanceUnits = 8;
            lec.nFeatures = 1; 
            lec.nHeadDirectionCells = 60;
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
            lec.setEnvironment(env); 

%             lec.rewardUnits = 5; 
            lec.build(); 
%             testCase.assertEqual(lec.nOutput, 209); 
            testCase.assertEqual(lec.nFeatures, 3, 'overrides previous setting');     
            testCase.assertEqual(lec.nOutput, 180); 
        end
        function testEnvironmentThreeCuesPresenceHandledNormally(testCase)
            lec = LecSystem();
%             lec.distanceUnits = 8;
            lec.nFeatures = 1; 
            lec.nHeadDirectionCells = 60;
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
            env.addCue([0 2]);
            lec.setEnvironment(env); 

%             lec.rewardUnits = 5; 
            lec.build(); 
%             testCase.assertEqual(lec.nOutput, 209); 
            testCase.assertEqual(lec.nFeatures, 3);     
            testCase.assertEqual(lec.nOutput, 180); 
        end
        function testDefaultsCreateOutputConsistentWithCalculatedLength(testCase)
            lec = LecSystem();
            lec.nHeadDirectionCells = 60;
            lec.nFeatures = 1; 
            lec.build(); 
            currentHeadDirection = 10;
            lec.buildCanonicalView(currentHeadDirection); 
            testCase.assertEqual(length(lec.lecOutput), lec.nOutput);

            currentHeadDirection = 0;
            lec.buildCanonicalView(currentHeadDirection); 
            testCase.assertEqual(length(lec.lecOutput), lec.nOutput);
            
            % environment without cues 
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
%             env.addCue([2 1]);  %  x   ------------- cue (at 0)
%             env.addCue([0 0]);            
%             env.setHeadDirection(1); % 0
%             disp(['1: ', num2str(env.cueHeadDirectionOffset(1))]); 
%             disp(['2: ', num2str(env.cueHeadDirectionOffset(2))]); 
%             wallDirection = env.closestWallDirection(); 
%             disp(['wall: ', num2str(env.headDirectionOffset(wallDirection))]); 
            lec.setEnvironment(env); 
            currentHeadDirection = 0;
            lec.buildCanonicalView(currentHeadDirection); 
            testCase.assertEqual(length(lec.lecOutput), lec.nOutput);

            %             disp(lec.lecOutput); 
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
%         function testRemembersHeadDirectionAssociatedWithCanonicalCueDirection(testCase)
%         end        
        function testAssociatesCurrentHeadDirectionWithCanonicalCueDirection(testCase)
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
            env.addCue([1 2]);  % cue at pi/2                        
% perhaps we don't need a HDS, we just assert a current head direction
% and an angle from current head direction to canonical cue head direction
% adjust the angle, get the head direction pointing at the canonical cue
% then remember the place output that comes back, and associate that with
% the head direction, 
% 2nd test?  then verify we can recover that 
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