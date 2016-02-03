classdef GridChartNetworkTest < AbstractTest
    methods (Test)
        function testCreateGridChartNetwork(testCase)
            gridNet = GridChartNetwork(6,5); 
            testCase.assertEqual(gridNet.nX, 6, '6 cols'); 
            testCase.assertEqual(gridNet.nY, 5, '5 rows'); 
        end
%         function testPositiveAndNegativeMotionWeights(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             gridNet = GridChartNetwork(6,5); 
%             gridNet.buildNetwork();
%             testCase.assertEqual(length(gridNet.horizonalWeightInputVector), 6, ...
%                 'weights operate row at a time, until/unless I figure out how to process 5X6 matrix in one pass');
%             testCase.assertEqual(length(gridNet.verticalWeightInputVector), 5);
%             testCase.assertEqual(size(gridNet.positiveHorizontalWeights), [6 6 ]);
%             testCase.assertEqual(size(gridNet.negativeHorizontalWeights), [6 6]);
%             testCase.assertEqual(size(gridNet.positiveVerticalWeights), [5 5]);
%             testCase.assertEqual(size(gridNet.negativeVerticalWeights), [5 5]);
%             % assumes row at a time processing
% %             horizontalPositive = [0.184796813628934   0.201687064406685 0.184796813628934 0.147980845516166 0.129517595665892];            
%             horizontalPositive = [0.184796813628934  0.201687064406685   0.184796813628934   0.147980845516166   0.129517595665892 0.147980845516166];            
%             testCase.assertThat(gridNet.positiveHorizontalWeights(1,:), ...
%                 IsEqualTo(horizontalPositive, 'Within', RelativeTolerance(.0000000001)));         
% %             horizontalNegative = [0.147980845516166 0.129517595665892, 0.147980845516166   0.184796813628934   0.201687064406685];
%             horizontalNegative = [0.184796813628934   0.147980845516166 0.129517595665892, 0.147980845516166   0.184796813628934   0.201687064406685];
%             testCase.assertThat(gridNet.negativeHorizontalWeights(1,:), ...
%                 IsEqualTo(horizontalNegative, 'Within', RelativeTolerance(.0000000001)));         
%             % vertical processing, after transposition, implies shift
%             % to the left to make numbers be more positive after transpose back 
% %             verticalPositive = [0.184796813628934   0.147980845516166 0.129517595665892, 0.147980845516166   0.184796813628934   0.201687064406685];
%             verticalPositive = [0.203028146638744   0.185744160092518   0.185744160092518   0.203028146638744   0.208235290447501];
% 
% %             verticalPositive = [0.184796813628934   0.201687064406685 0.184796813628934 0.147980845516166 0.129517595665892];
%             testCase.assertThat(gridNet.positiveVerticalWeights(1,:), ...
%                 IsEqualTo(verticalPositive, 'Within', RelativeTolerance(.00000001)));         
% %             verticalNegative = [0.184796813628934  0.201687064406685   0.184796813628934   0.147980845516166   0.129517595665892 0.147980845516166];            
%             verticalNegative = [0.203028146638744   0.208235290447501 0.203028146638744   0.185744160092518   0.185744160092518];
% %             verticalNegative = [0.147980845516166 0.129517595665892, 0.147980845516166   0.184796813628934   0.201687064406685];
%             testCase.assertThat(gridNet.negativeVerticalWeights(1,:), ...
%                 IsEqualTo(verticalNegative, 'Within', RelativeTolerance(.00000001)));         
%         end
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
%         function testBuildsHorizontalMotionSynapticInput(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             gridNet = GridChartNetwork(6,5); 
%             gridNet.motionInputWeights = 1; 
%             gridNet.buildNetwork();
%             gridNet.activation = ...
%                 [0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 2 1 0 0 0 1 0 0 0 0 0 0 0]; 
%             % looks like:
% %             0     0     0     0     0     0
% %             0     0     0     1     0     0
% %             0     0     1     2     1     0
% %             0     0     0     1     0     0
% %             0     0     0     0     0     0
%             gridNet.velocity = [ 0.3; 0.2]; 
%             % shifted right
%             horizontalInput = ...
%                    [0   0   0   0   0   0;
%                     0.044394253654850   0.038855278699768   0.044394253654850   0.055439044088680   0.060506119322006   0.055439044088680;
%                     0.183082830098147   0.166499064709234   0.183082830098147   0.215778461154216   0.231890326821372   0.215778461154216;
%                     0.044394253654850   0.038855278699768   0.044394253654850   0.055439044088680   0.060506119322006   0.055439044088680;
%                     0   0   0   0   0   0; ];
%             testCase.assertThat(gridNet.calculateHorizontalInput(), ...
%             IsEqualTo(horizontalInput, 'Within', RelativeTolerance(.00000001)));         
%         end
%         function testBuildsVerticalMotionSynapticInput(testCase)
%             import matlab.unittest.constraints.IsEqualTo
%             import matlab.unittest.constraints.RelativeTolerance
%             gridNet = GridChartNetwork(6,5); 
%             gridNet.motionInputWeights = 1; 
%             gridNet.buildNetwork();
%             gridNet.activation = ...
%                 [0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 2 1 0 0 0 1 0 0 0 0 0 0 0]; 
%                         % looks like:
% %             0     0     0     0     0     0
% %             0     0     0     1     0     0
% %             0     0     1     2     1     0
% %             0     0     0     1     0     0
% %             0     0     0     0     0     0
% 
%             gridNet.velocity = [ 0.3; 0.2]; 
%             % shifted up
%             verticalInput = ...
%               [0                   0   0.040605629327749   0.160007148763501   0.040605629327749                   0; 
%                0                   0   0.041647058089500   0.164505374834498   0.041647058089500                   0;
%                0                   0   0.040605629327749   0.160007148763501   0.040605629327749                   0;
%                0                   0   0.037148832018504   0.152052125383259   0.037148832018504                   0;
%                0                   0   0.037148832018504   0.152052125383259   0.037148832018504                   0];            
%            testCase.assertThat(gridNet.calculateVerticalInput(), ...
%                 IsEqualTo(verticalInput, 'Within', RelativeTolerance(.00000001)));
%             reshapeInput = reshape(verticalInput,1,gridNet.nCells);
%             verticalInputReshaped = reshape(reshapeInput,gridNet.nY,gridNet.nX); 
%             testCase.assertThat(verticalInputReshaped, ...
%                 IsEqualTo(verticalInput, 'Within', RelativeTolerance(.00000001)));
%             
%         end
%         function testWeightOffset(testCase)
%             
%         end
%         function testWeightOrientation(testCase)
%             
%         end
%         function testWeightGain(testCase)
%             
%         end
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

%         function testCreateNetwork(testCase)
%             h = figure; 
%             colsp = 3;
%             rowsp = 3;  
%             gh = gobjects(rowsp,colsp);
%             rowOffset = 0; 
%             for kk = 1:rowsp
%                 for ll = 1:colsp
%                     indPlot = ll+(rowOffset * colsp);
% %                     disp([kk,ll,indPlot]); 
%                     gh(kk,ll) = subplot(rowsp,colsp, indPlot); 
%                 end
%                 rowOffset = rowOffset + 1; 
%             end
%             network = GridChartNetwork(10,9);
%             network.h = h; 
%             network.gh = gh; 
%             network.inputGain = 30; 
%             network.buildNetwork();             
%             network2 = GridChartNetwork(10,9);
%             network2.h = h; 
%             network2.gh = gh;  
%             network2.motionInputWeights = 1;
%             network2.motionWeightOffset = 4; 
% %             network2.inputDirectionBias = pi/4; 
%             network2.buildNetwork(); 
%             network3 = GridChartNetwork(10,9);
%             network3.h = h; 
%             network3.gh = gh;  
%             network3.motionInputWeights = 1;
%             network3.inputGain = 2000; 
%             network3.motionWeightOffset = 4; 
% %             network3.inputDirectionBias = pi/4; 
%             network3.buildNetwork(); 
%             network4 = GridChartNetwork(10,9);
%             network4.h = h; 
%             network4.gh = gh;  
%             network4.motionInputWeights = 1;
%             network4.motionWeightOffset = 4; 
%             network4.inputDirectionBias = pi/4; 
%             network4.buildNetwork(); 
%             for ii = 1:1000
%                 for jj = 1:10
%                     network.step();
%                     network2.step();
% %                     network3.step();
% %                     network4.step();
%                     if jj == 10
%                         figure(h);
%                         network.plotAll(1); 
%                         network2.plotAll(2);
%                         network2.plotDetail(3); 
% %                         network3.plotAll(3);
% %                         network4.plotAll(5);
%                         drawnow; 
% %                         pause(0.2); 
%                     end
%                 end
%             end
%         end
    end
end