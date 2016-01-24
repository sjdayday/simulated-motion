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
            testCase.assertEqual(length(gridNet.horizonalWeightInputVector), 6, ...
                'weights operate row at a time, until/unless I figure out how to process 6x5 matrix in one pass');
            testCase.assertEqual(length(gridNet.verticalWeightInputVector), 5);
            testCase.assertEqual(size(gridNet.positiveHorizontalWeights), [6 6]);
            testCase.assertEqual(size(gridNet.negativeHorizontalWeights), [6 6]);
            testCase.assertEqual(size(gridNet.positiveVerticalWeights), [5 5]);
            testCase.assertEqual(size(gridNet.negativeVerticalWeights), [5 5]);
            % assumes row at a time processing
            horizontalPositive = [0.184796813628934  0.201687064406685   0.184796813628934   0.147980845516166   0.129517595665892 0.147980845516166];
            testCase.assertThat(gridNet.positiveHorizontalWeights(1,:), ...
                IsEqualTo(horizontalPositive, 'Within', RelativeTolerance(.0000000001)));         
            horizontalNegative = [0.184796813628934   0.147980845516166 0.129517595665892, 0.147980845516166   0.184796813628934   0.201687064406685];
            testCase.assertThat(gridNet.negativeHorizontalWeights(1,:), ...
                IsEqualTo(horizontalNegative, 'Within', RelativeTolerance(.0000000001)));         
            % vertical processing, after transposition, implies shift
            % to the left to make numbers be more positive after transpose back 
            verticalPositive = [0.147980845516166 0.129517595665892, 0.147980845516166   0.184796813628934   0.201687064406685];
            testCase.assertThat(gridNet.positiveVerticalWeights(1,:), ...
                IsEqualTo(verticalPositive, 'Within', RelativeTolerance(.00000001)));         
            verticalNegative = [0.184796813628934   0.201687064406685 0.184796813628934 0.147980845516166 0.129517595665892];
            testCase.assertThat(gridNet.negativeVerticalWeights(1,:), ...
                IsEqualTo(verticalNegative, 'Within', RelativeTolerance(.00000001)));         
        end
        function testWeightInputCallsHorizontalAndVerticalWeights(testCase)
           % assert base weights are same after subsequent calls  
        end
        function testWeightOffset(testCase)
            
        end
        function testWeightOrientation(testCase)
            
        end
        function testWeightGain(testCase)
            
        end
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