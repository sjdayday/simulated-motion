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
%             testCase.assertThat(env.relativeDistanceInterval, ...            
%                 IsEqualTo(0.395284707521047, 'Within', RelativeTolerance(.00000000001))); 
%             
%             testCase.assertEqual(env.cueRelativeDistance(1), 2);
        end
%         function testActivationFollowsPreviouslyActivatedFeatures(testCase)
%             gridNet = GridChartNetwork(6,5); 
%             gridNet.externalVelocity = true; 
%             gridNet.nFeatureDetectors = 5; 
%             gridNet.featureGain = 3;
%             gridNet.featureOffset = 0.15;             
%             gridNet.buildNetwork();
%             gridNet.step(); 
%             for ii = 1:7
%                 gridNet.step();            
%             end
%             testCase.assertEqual(gridNet.getMaxActivationIndex(), ...
%                 18, 'stable; now present features'); 
%             gridNet.featuresDetected = [0 0 1 0 0]; 
%             for ii = 1:5
%                 gridNet.step();            
%             end
%             w = gridNet.featureWeights; 
%             testCase.assertEqual(max(w(1,:)), 0); 
% %             % randomly "place" animal elsewhere
%         end

    end
end