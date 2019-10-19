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
                [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 ...                  
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  ]); 
            currentHeadDirection = 50;
            lec.buildCanonicalView(currentHeadDirection); 
            testCase.assertEqual(lec.lecOutput, ...
                [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 ...                  
                  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                  ], ...
              'same output; canonical view does not depend on current head direction '); 
            
        end

        function testCopyAndShiftHdsActivationToLecAtCanonicalCueDirection(testCase)
            headDirectionSystem = HeadDirectionSystem(60); 
            randomHeadDirection = true; 
            headDirectionSystem.initializeActivation(randomHeadDirection);            
            headDirectionSystem.pullVelocity = false;  
            headDirectionSystem.pullFeatures = false; 
            headDirectionSystem.nFeatureDetectors = 5; 
            headDirectionSystem.build();
            for ii = 1:7
                headDirectionSystem.step();            
            end
            currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
            testCase.assertEqual(currentHeadDirection, ...
                10, 'stable'); 
            

            lec = LecSystem();
            lec.nHeadDirectionCells = 60;
            lec.nCueIntervals = 12; 
            lec.nFeatures = 3; 
            lec.build(); 
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

            lec.setEnvironment(env); 
            lec.headDirectionSystem = headDirectionSystem; 
            
            lec.buildCanonicalCueActivation(); 
            testCase.assertEqual(lec.getCueMaxActivationIndex(), 60); 
            testCase.assertEqual(lec.cueActivation(1,60), ...
                headDirectionSystem.uActivation(1,10), ...
                'head direction activation copied and shifted to canonical view'); 
            testCase.assertEqual(lec.cueActivation(1,1:9), ...
                headDirectionSystem.uActivation(1,11:19), ...
                'head direction activation copied and shifted to canonical view'); 

%             testCase.assertEqual(lec.cueActivation(1,1:10), ...
%                 headDirectionSystem.uActivation(1,10:19), ...
%                 'head direction activation copied and shifted to canonical view'); 
            headDirectionSystem.updateAngularVelocity(pi/10); 
            headDirectionSystem.step(); 
            currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
            testCase.assertEqual(currentHeadDirection, 11); 
            lec.buildCanonicalCueActivation(); 
            testCase.assertEqual(lec.getCueMaxActivationIndex(), 60); 
            testCase.assertEqual(lec.cueActivation(1,60), ...
                headDirectionSystem.uActivation(1,11), ...
                'head direction activation copied and shifted to canonical view'); 
            testCase.assertEqual(lec.cueActivation(1,1:9), ...
                headDirectionSystem.uActivation(1,12:20), ...
                'head direction activation copied and shifted to canonical view'); 
%             testCase.assertEqual(lec.cueActivation(1,1:10), ...
%                 headDirectionSystem.uActivation(1,11:20), ...
%                 'head direction activation copied and shifted to canonical view'); 
            headDirectionSystem.step(); 
            currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
            testCase.assertEqual(currentHeadDirection, 12); 
            lec.buildCanonicalCueActivation(); 
            testCase.assertEqual(lec.cueActivation(1,60), ...
                headDirectionSystem.uActivation(1,12), ...
                'head direction activation copied and shifted to canonical view'); 
            testCase.assertEqual(lec.cueActivation(1,1:9), ...
                headDirectionSystem.uActivation(1,13:21), ...
                'head direction activation copied and shifted to canonical view'); 
%             testCase.assertEqual(lec.getCueMaxActivationIndex(), 1); 
%             testCase.assertEqual(lec.cueActivation(1,1:10), ...
%                 headDirectionSystem.uActivation(1,12:21), ...
%                 'head direction activation copied and shifted to canonical view'); 
        end

%         function testCopyAndShiftHdsActivationToLecAtCanonicalCueDirectionOffset(testCase)
%             % fix 
%             headDirectionSystem = HeadDirectionSystem(60); 
%             randomHeadDirection = true; 
%             headDirectionSystem.initializeActivation(randomHeadDirection);            
%             headDirectionSystem.pullVelocity = false;  
%             headDirectionSystem.pullFeatures = false; 
%             headDirectionSystem.nFeatureDetectors = 5; 
%             headDirectionSystem.build();
%             for ii = 1:7
%                 headDirectionSystem.step();            
%             end
%             currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
%             testCase.assertEqual(currentHeadDirection, ...
%                 10, 'stable'); 
%             
% 
%             lec = LecSystem();
%             lec.nHeadDirectionCells = 60;
%             lec.nCueIntervals = 12; 
%             lec.nFeatures = 3; 
%             lec.build(); 
%             env = Environment();
%             env.addWall([0 0],[0 2]); 
%             env.addWall([0 2],[2 2]); 
%             env.addWall([0 0],[2 0]); 
%             env.addWall([2 0],[2 2]);
%             env.distanceIntervals = 8;
%             env.directionIntervals = 60;
%             env.center = [1 1]; 
%             env.build();  
%             env.setPosition([1 0]);             
% %             env.setPosition([0.5 1]); 
%             env.addCue([2 1]);  % cue (at pi/4 from position)
%             env.addCue([0 0]);            
%             env.addCue([1 2]);  % cue at pi/2                        
% 
%             lec.setEnvironment(env); 
%             lec.headDirectionSystem = headDirectionSystem; 
% %             lec.buildCanonicalCueActivation(); 
%             env.setDirection(0);
%             currentHeadDirection = headDirectionSystem.getMaxActivationIndex();              
%             testCase.assertEqual(currentHeadDirection, ...
%                 10, 'stable'); 
%             testCase.assertEqual(env.cueHeadDirectionOffset(1), 8);
%             lec.buildCanonicalCueOffsetActivation(); 
%             testCase.assertEqual(lec.offset, 2); 
%             % current HD = 20, cueHD = 5
%             % associate features with 5
%             % reinitialize HD, stable at 40
%             % orient, turning 15 until pointing at cue, currently HD = 25
%             % readMode
%             % HD attracted to 5 (shift of 20)
%             % previous was correct; need to associate cueHD with features; 
%             % don't need to explicitly save offset 
%             %
%             % do we want the activation to be at the offset or at the cue +
%             % offset?  maybe the latter because HDS will pull to that....
%             
%             % finish this, then return to 
%             % testAssociatesHeadDirectionOffsetWithCanonicalCueDirection
%             % testing that the max of the feature weights is where we want
%             
%             
% %             testCase.assertEqual(lec.getCueMaxActivationIndex(), 1); 
% %             testCase.assertEqual(lec.cueActivation(1,1:10), ...
% %                 headDirectionSystem.uActivation(1,10:19), ...
% %                 'head direction activation copied and shifted to canonical view'); 
% 
% %             testCase.assertEqual(lec.getCueMaxActivationIndex(), 8); 
% %             testCase.assertEqual(lec.getCueMaxActivationIndex(), 8); 
% %             testCase.assertEqual(lec.cueActivation(1,1:10), ...
% %                 headDirectionSystem.uActivation(1,10:19), ...
% %                 'head direction activation copied and shifted to canonical view'); 
% %             headDirectionSystem.updateAngularVelocity(pi/10); 
% %             headDirectionSystem.step(); 
% %             currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
% %             testCase.assertEqual(currentHeadDirection, 11); 
% %             lec.buildCanonicalCueActivation(); 
% %             testCase.assertEqual(lec.getCueMaxActivationIndex(), 1); 
% %             testCase.assertEqual(lec.cueActivation(1,1:10), ...
% %                 headDirectionSystem.uActivation(1,11:20), ...
% %                 'head direction activation copied and shifted to canonical view'); 
% %             headDirectionSystem.step(); 
% %             currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
% %             testCase.assertEqual(currentHeadDirection, 12); 
% %             lec.buildCanonicalCueActivation(); 
% %             testCase.assertEqual(lec.getCueMaxActivationIndex(), 1); 
% %             testCase.assertEqual(lec.cueActivation(1,1:10), ...
% %                 headDirectionSystem.uActivation(1,12:21), ...
% %                 'head direction activation copied and shifted to canonical view'); 
%         end






%         function testRetrievesHeadDirectionOffsetFromCanonicalCueDirection(testCase)
%             %                             
%             headDirectionSystem = HeadDirectionSystem(60); 
%             randomHeadDirection = true; 
%             headDirectionSystem.initializeActivation(randomHeadDirection);            
%             headDirectionSystem.pullVelocity = false;  
%             headDirectionSystem.pullFeatures = false; 
%             headDirectionSystem.nFeatureDetectors = 5; 
%             headDirectionSystem.build();
%             for ii = 1:7
%                 headDirectionSystem.step();            
%             end
%             currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
%             testCase.assertEqual(currentHeadDirection, ...
%                 10, 'stable'); 
% 
%             lec = LecSystem();
%             lec.nHeadDirectionCells = 60;
%             lec.nCueIntervals = 12; 
%             lec.nFeatures = 3; 
%             lec.build(); 
%             env = Environment();
%             env.addWall([0 0],[0 2]); 
%             env.addWall([0 2],[2 2]); 
%             env.addWall([0 0],[2 0]); 
%             env.addWall([2 0],[2 2]);
%             env.distanceIntervals = 8;
%             env.directionIntervals = 60;
%             env.center = [1 1]; 
%             env.build();  
%             env.setPosition([0.5 1]);             
% %             env.setPosition([0.5 1]); 
%             env.addCue([2 1]);  %  x   ------------- cue (at 0)
%             env.addCue([0 0]);            
%             env.addCue([1 2]);  % cue at pi/2                        
%             lec.setEnvironment(env); 
%             lec.headDirectionSystem = headDirectionSystem; 
%             lec.buildCanonicalCueActivation(); 
%             disp(lec.printOutputIndices()); 
%             testCase.assertEqual(lec.offset, 9); 
%             testCase.assertEqual(lec.getCueMaxActivationIndex(), 1); 
%             testCase.assertEqual(lec.cueActivation(1,1:10), ...
%                 headDirectionSystem.uActivation(1,10:19), ...
%                 'head direction activation copied and shifted to canonical view'); 
%             headDirectionSystem.initializeActivation(randomHeadDirection);            
%             for ii = 1:7
%                 headDirectionSystem.step();            
%             end
%             currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
%             testCase.assertEqual(currentHeadDirection, ...
%                 4, 'stable'); 
%             lec.buildCanonicalCueActivation();
%             disp(lec.printOutputIndices()); 
%             testCase.assertEqual(lec.offset, 3);             
%         
%             headDirectionSystem.initializeActivation(randomHeadDirection);            
%             for ii = 1:7
%                 headDirectionSystem.step();            
%             end
%             currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
%             testCase.assertEqual(currentHeadDirection, ...
%                 20, 'stable'); 
%             lec.buildCanonicalCueActivation(); 
%             disp(lec.printOutputIndices()); 
%             testCase.assertEqual(lec.offset, 19);
%             % now move to different position
%             env.setPosition([2 2]); % primary cue now at 3pi/2             
%             currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
%             testCase.assertEqual(currentHeadDirection, ...
%                 20, 'stable'); 
%             lec.buildCanonicalCueActivation(); 
%             disp(lec.printOutputIndices()); 
%             testCase.assertEqual(lec.offset, 34, ...
%                 ['cueHeadDirectionOffset is 46 - relative head direction is 19 =', ...
%                 '27 from head direction to cue; 60-27+1 from cue to head direction']);
%             headDirectionSystem.initializeActivation(randomHeadDirection);
% %             headDirectionSystem.initializeActivation(randomHeadDirection);            
%             for ii = 1:7
%                 headDirectionSystem.step();            
%             end
%             currentHeadDirection = headDirectionSystem.getMaxActivationIndex();              
%             testCase.assertEqual(currentHeadDirection, ...
%                 36, 'next stable'); 
%             lec.buildCanonicalCueActivation(); 
%             disp(lec.printOutputIndices()); 
%             testCase.assertEqual(lec.offset, 50, ...
%                 ['cueHeadDirectionOffset is 46 - relative head direction is 35 =', ...
%                 '11 from head direction to cue; 60-11+1 from cue to head direction']); 
%         end
    function testHdsActivationFollowsPreviouslyActivatedLecFeatures(testCase)
%             % [when] do we need to do this? 
%             % orient, turning 19? 9? until pointing at cue, currently HD
%             = 11? 1?        
        import matlab.unittest.constraints.IsEqualTo
        import matlab.unittest.constraints.RelativeTolerance
        lec = LecSystem();
        lec.nHeadDirectionCells = 60;
        lec.nCueIntervals = 60; 
%         lec.nCueIntervals = 12;         
        lec.nFeatures = 3; 
        lec.nFeatureDetectors = 5;        
        lec.build(); 
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
        headDirectionSystem = HeadDirectionSystem(60); 
        randomHeadDirection = true; 
        headDirectionSystem.initializeActivation(randomHeadDirection)            
        headDirectionSystem.pullVelocity = false;  
        headDirectionSystem.pullFeatures = false; 
        headDirectionSystem.nFeatureDetectors = 5;
        headDirectionSystem.build();

        lec.headDirectionSystem = headDirectionSystem; 
        headDirectionSystem.lec = lec; 
        lec.setEnvironment(env);         
        
        disp(['LEC: ', lec.printOutputIndices() ]); 
        for ii = 1:7
            headDirectionSystem.step();            
        end
%             % current HD = 10, cueHD = 1        
        testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), ...
            10, 'stable; now present features'); 
        lec.buildCanonicalCueActivation();         
        testCase.assertEqual(lec.cueHeadDirection, ...
            0, 'stable; now present features'); 
%             % associate features with 1        
        headDirectionSystem.featuresDetected = [0 0 1 0 1]; 
        lec.featuresDetected = [0 0 1 0 1];         
        headDirectionSystem.step(); 
        lec.buildCanonicalCueActivation(); 
        testCase.assertEqual(lec.cueHeadDirection, ...
            0, '1: lec cue direction unchanged');                 
        disp(['LEC2 : ', lec.printOutputIndices() ]); 
        lec.updateFeatureWeights(); 
        w = headDirectionSystem.featureWeights; 
        lw = lec.featureWeights; 
        testCase.assertEqual(max(w(1,:)), 0); 
        testCase.assertThat(max(w(3,:)), ...            
            IsEqualTo(0.174664933360754, 'Within', RelativeTolerance(.00000000001))); 
        testCase.assertEqual(find(w(3,:) == max(w(3,:))), 10); 
        % randomly "place" animal elsewhere
        testCase.assertEqual(max(lw(1,:)), 0); 
        testCase.assertThat(max(lw(3,:)), ...            
            IsEqualTo(0.519338891167941, 'Within', RelativeTolerance(.00000000001))); 
        testCase.assertEqual(find(lw(3,:) == max(lw(3,:))), 60, ...
            'max has been shifted from 10 in hds to 60 in LDS'); 
        lec.buildCanonicalCueActivation(); 
        testCase.assertEqual(lec.cueHeadDirection, ...
            0, '2: lec cue direction unchanged');                 
%             % reinitialize HD, stable at 20        
        headDirectionSystem.pullFeatureWeightsFromLec = true; 
        headDirectionSystem.initializeActivation(true);
        headDirectionSystem.initializeActivation(true); 
        lec.featuresDetected = [0 0 0 0 0]; 
        headDirectionSystem.step();            
        testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), ...
            20, 'stable activation at new random orientation');
%             % readMode        
        lec.featuresDetected = [0 0 1 0 1]; 
        headDirectionSystem.readMode = 1;
        lec.readMode = 1;
        % features now drive us back to the canonical view at which they 
        % were perceived: 60
%             headDirectionSystem.step(); 
        headDirectionSystem.updateActivationWithFeatureInputs();
        testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 1, ....
            'pulled immediately'); 
        headDirectionSystem.updateActivationWithFeatureInputs();
        testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 1, ....
            'pulled immediately'); 
        headDirectionSystem.updateActivationWithFeatureInputs();
        testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 60, ....
            'pulled immediately'); 
        lec.buildCanonicalCueActivation(); 
        testCase.assertEqual(lec.cueHeadDirection, ...
            0, '3: lec cue direction unchanged');         
        disp(['LEC3 : ', lec.printOutputIndices() ]); 

    end

%             % previous was correct; need to associate cueHD with features; 
%             % don't need to explicitly save offset 

        
%         function testRemembersHeadDirectionAssociatedWithCanonicalCueDirection(testCase)
%             headDirectionSystem = HeadDirectionSystem(60); 
%             randomHeadDirection = true; 
%             headDirectionSystem.initializeActivation(randomHeadDirection);            
%             headDirectionSystem.pullVelocity = false;  
%             headDirectionSystem.pullFeatures = false; 
%             headDirectionSystem.nFeatureDetectors = 5; 
%             headDirectionSystem.build();
%             for ii = 1:7
%                 headDirectionSystem.step();            
%             end
%             currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
%             testCase.assertEqual(currentHeadDirection, ...
%                 10, 'stable'); 
%             
% 
%             lec = LecSystem();
%             lec.nHeadDirectionCells = 60;
%             lec.nCueIntervals = 12; 
%             lec.nFeatures = 3; 
%             lec.build(); 
%             env = Environment();
%             env.addWall([0 0],[0 2]); 
%             env.addWall([0 2],[2 2]); 
%             env.addWall([0 0],[2 0]); 
%             env.addWall([2 0],[2 2]);
%             env.distanceIntervals = 8;
%             env.directionIntervals = 60;
%             env.center = [1 1]; 
%             env.build();  
%             env.setPosition([0.5 1]);             
% %             env.setPosition([0.5 1]); 
%             env.addCue([2 1]);  %  x   ------------- cue (at 0)
%             env.addCue([0 0]);            
%             env.addCue([1 2]);  % cue at pi/2                        
% 
%             lec.setEnvironment(env); 
%             lec.headDirectionSystem = headDirectionSystem; 
%             lec.buildCanonicalCueActivation(); 
%             testCase.assertEqual(lec.getCueMaxActivationIndex(), 1); 
%             testCase.assertEqual(lec.cueActivation(1,1:10), ...
%                 headDirectionSystem.uActivation(1,10:19), ...
%                 'head direction activation copied and shifted to canonical view'); 
%             headDirectionSystem.updateAngularVelocity(pi/10); 
%             headDirectionSystem.step(); 
%             currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
%             testCase.assertEqual(currentHeadDirection, 11); 
%             lec.buildCanonicalCueActivation(); 
%             testCase.assertEqual(lec.getCueMaxActivationIndex(), 1); 
%             testCase.assertEqual(lec.cueActivation(1,1:10), ...
%                 headDirectionSystem.uActivation(1,11:20), ...
%                 'head direction activation copied and shifted to canonical view'); 
%             headDirectionSystem.step(); 
%             currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
%             testCase.assertEqual(currentHeadDirection, 12); 
%             lec.buildCanonicalCueActivation(); 
%             testCase.assertEqual(lec.getCueMaxActivationIndex(), 1); 
%             testCase.assertEqual(lec.cueActivation(1,1:10), ...
%                 headDirectionSystem.uActivation(1,12:21), ...
%                 'head direction activation copied and shifted to canonical view'); 
%         end        
%  init head direction
%  force animal direction
%    


    function testCopyShiftHdsActivationToLecAtHeadDirectionCanonicalOffset(testCase)
        import matlab.unittest.constraints.IsEqualTo
        import matlab.unittest.constraints.RelativeTolerance
        headDirectionSystem = HeadDirectionSystem(60); 
        randomHeadDirection = true; 
        headDirectionSystem.initializeActivation(randomHeadDirection);            
        headDirectionSystem.pullVelocity = false;  
        headDirectionSystem.pullFeatures = false; 
        headDirectionSystem.nFeatureDetectors = 5; 
        headDirectionSystem.build();
        for ii = 1:7
            headDirectionSystem.step();            
        end
        currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
        testCase.assertEqual(currentHeadDirection, ...
            10, 'stable'); 
        animalDirection = pi/2; 

        lec = LecSystem();
        lec.nHeadDirectionCells = 60;
        lec.nCueIntervals = 60; 
%             lec.nCueIntervals = 12; 
        lec.nFeatures = 3; 
        lec.build(); 
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
        env.addCue([2 1]);  %  x   ------------- 6cue (at 0)
        env.addCue([0 0]);            
        env.addCue([1 2]);  % cue at pi/2                        

        lec.setEnvironment(env); 
        lec.headDirectionSystem = headDirectionSystem; 

%         [radianPhysicalCueOffset, headDirectionRadians, radianHeadDirectionCueOffset, radianHeadDirectionOffset, canonicalHeadDirection] = ...
%             lec.buildCanonicalCueActivationForAnimalDirection(animalDirection); 

%         testCase.assertEqual(radianPhysicalCueOffset, 3*pi/2);  % 0 - pi/2           
%         testCase.assertEqual(headDirectionRadians, pi/3); % 10 
%         testCase.assertEqual(radianHeadDirectionCueOffset, 5*pi/3); % 10 
%         testCase.assertThat(radianHeadDirectionOffset, ...            
%             IsEqualTo((-1/6)*pi, 'Within', RelativeTolerance(.00000000001))); 

%         testCase.assertEqual(radianHeadDirectionOffset, (-1/6)*pi);  
        testCase.assertEqual(lec.calculateCanonicalHeadDirection(animalDirection), 55);  
        lec.buildCanonicalCueActivationForAnimalDirection(animalDirection); 
        testCase.assertEqual(lec.getCueMaxActivationIndex(), 55); 
        env.cues(1,:) = [0 1];
%         [radianPhysicalCueOffset, headDirectionRadians, radianHeadDirectionCueOffset, radianHeadDirectionOffset, canonicalHeadDirection] = ...
%             lec.buildCanonicalCueActivationForAnimalDirection(animalDirection); 
%         testCase.assertThat(radianPhysicalCueOffset, ...            
%             IsEqualTo(pi/2, 'Within', RelativeTolerance(.00000000001))); 
% 
%         testCase.assertEqual(headDirectionRadians, pi/3); % 10 
%         testCase.assertThat(radianHeadDirectionCueOffset, ...            
%             IsEqualTo(2*pi/3, 'Within', RelativeTolerance(.00000000001))); 
%         testCase.assertThat(radianHeadDirectionOffset, ...            
%             IsEqualTo((-1/6)*pi, 'Within', RelativeTolerance(.00000000001))); 
%         testCase.assertEqual(canonicalHeadDirection, 24);   % 25 by hand; likely rounding  
        testCase.assertEqual(lec.calculateCanonicalHeadDirection(animalDirection), 24);  
        lec.buildCanonicalCueActivationForAnimalDirection(animalDirection); 
        testCase.assertEqual(lec.getCueMaxActivationIndex(), 24); 
       
        env.cues(1,:) = [2 1];
        headDirectionSystem.initializeActivation(randomHeadDirection); 
        for ii = 1:7
            headDirectionSystem.step();            
        end
        currentHeadDirection = headDirectionSystem.getMaxActivationIndex();  
        testCase.assertEqual(currentHeadDirection, ...
            4, 'stable'); 
        animalDirection = -pi/3; 
%         [radianPhysicalCueOffset, headDirectionRadians, radianHeadDirectionCueOffset, radianHeadDirectionOffset, canonicalHeadDirection] = ...
%             lec.buildCanonicalCueActivationForAnimalDirection(animalDirection); 
%         testCase.assertEqual(radianPhysicalCueOffset, pi/3); % 0 - -pi/3 ...5/15 * pi             
% %             testCase.assertEqual(radianPhysicalCueOffset, pi/3); % 5/15 * pi                         
%         testCase.assertEqual(headDirectionRadians, 2*pi/15);                         
%         testCase.assertEqual(radianHeadDirectionCueOffset, 28*pi/15); % 10             
%         testCase.assertThat(radianHeadDirectionOffset, ...            
%             IsEqualTo((-23/15)*pi, 'Within', RelativeTolerance(.00000000001))); 
%         testCase.assertEqual(canonicalHeadDirection, 14);  
        testCase.assertEqual(lec.calculateCanonicalHeadDirection(animalDirection), 14);  
        lec.buildCanonicalCueActivationForAnimalDirection(animalDirection); 
        testCase.assertEqual(lec.getCueMaxActivationIndex(), 14); 
%   
        disp(mat2str(env.cues(1,:)));
        env.cues(1,:) = [0 1];
        disp(mat2str(env.cues(1,:)));  % cue at pi
%         [radianPhysicalCueOffset, headDirectionRadians, radianHeadDirectionCueOffset, radianHeadDirectionOffset, canonicalHeadDirection] = ...
%             lec.buildCanonicalCueActivationForAnimalDirection(animalDirection); 
%         testCase.assertEqual(radianPhysicalCueOffset, pi*4/3); % 0 - -pi/3 ...5/15 * pi             
%         testCase.assertEqual(headDirectionRadians, 2*pi/15);                         
%         testCase.assertEqual(radianHeadDirectionCueOffset, 13*pi/15); % 10             
%         testCase.assertThat(radianHeadDirectionOffset, ...            
%             IsEqualTo((7/15)*pi, 'Within', RelativeTolerance(.00000000001))); 
% 
%         testCase.assertEqual(canonicalHeadDirection, 44);   % 14 -6  
        testCase.assertEqual(lec.calculateCanonicalHeadDirection(animalDirection), 44);          
        lec.buildCanonicalCueActivationForAnimalDirection(animalDirection); 
        testCase.assertEqual(lec.getCueMaxActivationIndex(), 44); 
        testCase.assertEqual(lec.cueActivation(1,44:54), ...
            headDirectionSystem.uActivation(1,4:14), ...
            'head direction activation copied and shifted to canonical view'); 
    end 
    % TODO use buildCanonicalCueActivationForAnimalDirection in remembering
    % and returning to previous HD
    
    
    %     function testAssociatesHeadDirectionOffsetWithCanonicalCueDirection(testCase)
%             % establish random head direction
%             % get offset
%             % present features 
%             % associate offset with features
%             % random init HDS
%             % readmode, modeled on HDS
%             % present features
%             % HDS driven by features back to previous offset 
%             % [copy HDS feature test]  
%         import matlab.unittest.constraints.IsEqualTo
%         import matlab.unittest.constraints.RelativeTolerance
%         lec = LecSystem();
%         lec.nHeadDirectionCells = 60;
%         lec.nCueIntervals = 60; 
% %         lec.nCueIntervals = 12;         
%         lec.nFeatures = 3; 
%         lec.nFeatureDetectors = 5;        
%         lec.build(); 
%         
%             
% %             testCase.assertEqual(lec.offset, 9); 
% %             testCase.assertEqual(lec.getCueMaxActivationIndex(), 1); 
% %             testCase.assertEqual(lec.cueActivation(1,1:10), ...
% %                 headDirectionSystem.uActivation(1,10:19), ...        
% %         
% %         
%         
%         
%         env = Environment();
%         env.addWall([0 0],[0 2]); 
%         env.addWall([0 2],[2 2]); 
%         env.addWall([0 0],[2 0]); 
%         env.addWall([2 0],[2 2]);
%         env.distanceIntervals = 8;
%         env.directionIntervals = 60;
%         env.center = [1 1]; 
%         env.build();          
%         env.setPosition([0.5 1]);             
%         env.addCue([2 1]);  %  x   ------------- cue (at 0)
%         env.addCue([0 0]);            
%         env.addCue([1 2]);  % cue at pi/2  
%         lec.setEnvironment(env); 
%         headDirectionSystem = HeadDirectionSystem(60); 
%         randomHeadDirection = true; 
%         headDirectionSystem.initializeActivation(randomHeadDirection)            
%         headDirectionSystem.pullVelocity = false;  
%         headDirectionSystem.pullFeatures = false; 
%         headDirectionSystem.nFeatureDetectors = 5;
%         headDirectionSystem.build();
% 
%         lec.headDirectionSystem = headDirectionSystem; 
%         headDirectionSystem.lec = lec; 
%         disp(['LEC: ', lec.printOutputIndices()]); 
%         for ii = 1:7
%             headDirectionSystem.step();            
%         end
%         lec.buildCanonicalCueActivation(); 
%         testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), ...
%             10, 'stable; now present features'); 
%         testCase.assertEqual(lec.getCueMaxActivationIndex(), 1); 
%         testCase.assertEqual(lec.offset, 9, 'offset 10 - 1'); 
%         headDirectionSystem.featuresDetected = [0 0 1 0 1]; 
%         lec.featuresDetected = [0 0 1 0 1];         
%         headDirectionSystem.step(); 
%         lec.buildCanonicalCueActivation(); 
%         disp(['LEC2 : ', lec.printOutputIndices() ]); 
%         lec.updateFeatureWeights(); 
%         w = headDirectionSystem.featureWeights; 
%         lw = lec.featureWeights; 
%         testCase.assertEqual(max(w(1,:)), 0); 
%         testCase.assertThat(max(w(3,:)), ...            
%             IsEqualTo(0.174664933360754, 'Within', RelativeTolerance(.00000000001))); 
%         testCase.assertEqual(find(w(3,:) == max(w(3,:))), 10); 
%         % randomly "place" animal elsewhere
%         testCase.assertEqual(max(lw(1,:)), 0); 
%         testCase.assertThat(max(lw(3,:)), ...            
%             IsEqualTo(0.519338891167941, 'Within', RelativeTolerance(.00000000001))); 
%         testCase.assertEqual(find(lw(3,:) == max(lw(3,:))), 1); 
%         headDirectionSystem.pullFeatureWeightsFromLec = true; 
%         headDirectionSystem.initializeActivation(true);
%         headDirectionSystem.initializeActivation(true); 
%         lec.featuresDetected = [0 0 0 0 0]; 
%         headDirectionSystem.step();            
%         testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), ...
%             20, 'stable activation at new random orientation');
%         
%         lec.featuresDetected = [0 0 1 0 1]; 
%         headDirectionSystem.readMode = 1;
%         lec.readMode = 1;
%         % features now drive us back to the canonical view at which they 
%         % were perceived: 1
% %             headDirectionSystem.step(); 
%         headDirectionSystem.updateActivationWithFeatureInputs();
%         testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 2, ....
%             'pulled immediately'); 
%         headDirectionSystem.updateActivationWithFeatureInputs();
%         testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 2, ....
%             'pulled immediately'); 
%         headDirectionSystem.updateActivationWithFeatureInputs();
%         testCase.assertEqual(headDirectionSystem.getMaxActivationIndex(), 1, ....
%             'pulled immediately'); 
%         lec.buildCanonicalCueActivation(); 
%         disp(['LEC3 : ',lec.printOutputIndices()]); 
% 
%     end
        % testCueActivationAdjustedWhenRunning
    end
end