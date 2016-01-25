classdef GridChartNetworkTest < AbstractTest
    methods (Test)
        function testMetricsVectorRerunsOriginalChartSystemScenario(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
%             controller = ExperimentController(); 
%             record = [1 5.077490624715358 4.30861806429603 0.000001 1 1.00000000181092 0 0.4 0.01 0.5 0 5 0.6]; 
%             controller.totalSteps = 20; 
%             controller.rerunChartSystem(record);
%             testCase.assertThat(controller.chartStatisticsDetail(1,:), ... 
%                 IsEqualTo(record, 'Within', RelativeTolerance(00000000000001)));         
%             testCase.assertEqual(controller.chartStatisticsHeader, ... 
%                 {'iteration', 'weightSum', 'maxActivation', ... 
%                 'deltaMaxMin', 'numMax', 'maxSlope', 'alphaOffset', ...
%                 'betaGain', 'CInhibitionOffset', 'featureLearningRate', ...
%                 'normalizedWeight', 'sigmaAngularWeight', ... 
%                 'sigmaWeightPattern'});             
        end
        function testPositiveAndNegativeMotionWeights(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            gridNet = GridChartNetwork(6,5); 
            gridNet.buildNetwork();
            testCase.assertEqual(length(gridNet.horizonalWeightInputVector), 5, ...
                'weights operate row at a time, until/unless I figure out how to process 6x5 matrix in one pass');
            testCase.assertEqual(length(gridNet.verticalWeightInputVector), 6);
            testCase.assertEqual(size(gridNet.positiveHorizontalWeights), [5 5]);
            testCase.assertEqual(size(gridNet.negativeHorizontalWeights), [5 5]);
            testCase.assertEqual(size(gridNet.positiveVerticalWeights), [6 6]);
            testCase.assertEqual(size(gridNet.negativeVerticalWeights), [6 6]);
            % assumes row at a time processing
            horizontalPositive = [0.184796813628934   0.201687064406685 0.184796813628934 0.147980845516166 0.129517595665892];            
            testCase.assertThat(gridNet.positiveHorizontalWeights(1,:), ...
                IsEqualTo(horizontalPositive, 'Within', RelativeTolerance(.0000000001)));         
            horizontalNegative = [0.147980845516166 0.129517595665892, 0.147980845516166   0.184796813628934   0.201687064406685];
            testCase.assertThat(gridNet.negativeHorizontalWeights(1,:), ...
                IsEqualTo(horizontalNegative, 'Within', RelativeTolerance(.0000000001)));         
            % vertical processing, after transposition, implies shift
            % to the left to make numbers be more positive after transpose back 
            verticalPositive = [0.184796813628934   0.147980845516166 0.129517595665892, 0.147980845516166   0.184796813628934   0.201687064406685];
            testCase.assertThat(gridNet.positiveVerticalWeights(1,:), ...
                IsEqualTo(verticalPositive, 'Within', RelativeTolerance(.00000001)));         
            verticalNegative = [0.184796813628934  0.201687064406685   0.184796813628934   0.147980845516166   0.129517595665892 0.147980845516166];            
            testCase.assertThat(gridNet.negativeVerticalWeights(1,:), ...
                IsEqualTo(verticalNegative, 'Within', RelativeTolerance(.00000001)));         
        end
        function testMotionInputsLeavePairwiseDistancesConstant(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            gridNet = GridChartNetwork(6,5); 
            gridNet.motionInputWeights = 1; 
            gridNet.buildNetwork();
            gridNet.step();             
            squaredPairwiseDists = gridNet.squaredPairwiseDists; 
            gridNet.step(); 
            testCase.assertThat(gridNet.squaredPairwiseDists, ...
                IsEqualTo(squaredPairwiseDists, 'Within', RelativeTolerance(.00000001)));         
        end
        function testBuildsHorizontalMotionSynapticInput(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            gridNet = GridChartNetwork(6,5); 
            gridNet.motionInputWeights = 1; 
            gridNet.buildNetwork();
            gridNet.activation = ...
                [0 0 0 0 0 0 0 0 1 0 0 0 0 1 2 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0]; 
            % looks like:
%                  0     0     0     0     0
%                  0     0     1     0     0
%                  0     1     2     1     0
%                  0     0     1     0     0
%                  0     0     0     0     0
%                  0     0     0     0     0
            gridNet.velocity = [ 0.3; 0.2]; 
            % shifted right
            horizontalInput = ...
                   [ 0   0   0   0   0;
                    0.038855278699768   0.044394253654850   0.055439044088680   0.060506119322006   0.055439044088680;
                    0.166499064709234   0.183082830098147   0.215778461154216   0.231890326821372   0.215778461154216;
                    0.038855278699768   0.044394253654850   0.055439044088680   0.060506119322006   0.055439044088680;                  
                    0   0   0   0   0;
                    0   0   0   0   0; ];
            testCase.assertThat(gridNet.calculateHorizontalInput(), ...
            IsEqualTo(horizontalInput, 'Within', RelativeTolerance(.00000001)));         
        end
        function testBuildsVerticalMotionSynapticInput(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            gridNet = GridChartNetwork(6,5); 
            gridNet.motionInputWeights = 1; 
            gridNet.buildNetwork();
            gridNet.activation = ...
                [0 0 0 0 0 0 0 0 1 0 0 0 0 1 2 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0]; 
                        % looks like:
%                  0     0     0     0     0
%                  0     0     1     0     0
%                  0     1     2     1     0
%                  0     0     1     0     0
%                  0     0     0     0     0
%                  0     0     0     0     0

            gridNet.velocity = [ 0.3; 0.2]; 
            % shifted up
            verticalInput = ...
              [ 0   0.036959362725787   0.143852307436144   0.036959362725787                   0;
               0   0.040337412881337   0.154593551214248   0.040337412881337                   0;
               0   0.036959362725787   0.143852307436144   0.036959362725787                   0;
               0   0.029596169103233   0.122055220065431   0.029596169103233                   0;
               0   0.025903519133178   0.110999376472823   0.025903519133178                   0;
               0   0.029596169103233   0.122055220065431   0.029596169103233                   0];
            testCase.assertThat(gridNet.calculateVerticalInput(), ...
                IsEqualTo(verticalInput, 'Within', RelativeTolerance(.00000001)));         
        end
        function testWeightOffset(testCase)
            
        end
        function testWeightOrientation(testCase)
            
        end
        function testWeightGain(testCase)
            
        end
%         function testSingle(testCase)
%             gridNet = GridChartNetwork(6,5);
%             gridNet.motionInputWeights = 1;
%             gridNet.buildNetwork();
%             gridNet.step();
%             gridNet.plot();
%             gridNet.step();
%             gridNet.plot();
%             for ii = 1:100
%                 for jj = 1:10
%                     gridNet.step();
%                     if jj == 10
%                         gridNet.plot();
%                         drawnow;
%                     end
%                 end
%             end
%         end
%         function testCreateNetwork(testCase)
%             h = figure; 
%             colsp = 3;
%             rowsp = 3;  
%             gh = gobjects(rowsp,colsp);
%             rowOffset = 0; 
%             for kk = 1:3
%                 for ll = 1:colsp
%                     indPlot = ll+(rowOffset * colsp);
% %                     disp([kk,ll,indPlot]); 
%                     gh(kk,ll) = subplot(colsp,rowsp,indPlot); 
%                 end
%                 rowOffset = rowOffset + 1; 
%             end
%             network = GridChartNetwork(6,5);
%             network.h = h; 
%             network.gh = gh; 
%             network2 = GridChartNetwork(6,5);
%             network2.h = h; 
%             network2.gh = gh;             
%             network2.inputDirectionBias = pi/4; 
%             network2.buildNetwork(); 
%             network3 = GridChartNetwork(6,5);
%             network3.h = h; 
%             network3.gh = gh;             
%             network3.inputGain = 50; 
%             network3.buildNetwork(); 
%             for ii = 1:100
%                 for jj = 1:10
%                     network.step();
%                     network2.step();
%                     network3.step();
%                     if jj == 10
%                         figure(h);
%                         network.plotAll(1); 
%                         network2.plotAll(2); 
%                         network3.plotAll(3);                         
% %                         subplot(331);
% %                         network.plotActivation();
% %                         subplot(332);
% %                         network.plotRateMap(); 
% %                         subplot(333);
% %                         network.plotTrajectory(); 
% %                         subplot(334); 
% %                         network2.plotActivation();
% %                         subplot(335);
% %                         network2.plotRateMap(); 
% %                         subplot(336);
% %                         network2.plotTrajectory(); 
% %                         subplot(337); 
% %                         network3.plotActivation();
% %                         subplot(338);
% %                         network3.plotRateMap(); 
% %                         subplot(339);
% %                         network3.plotTrajectory(); 
%                         drawnow; 
%                     end
%                 end
%             end
%         end
    end
end