classdef GridChartNetworkTest < AbstractTest
    methods (Test)
        function testCreateNetwork(testCase)
            h = figure; 
            colsp = 3;
            rowsp = 3;  
            gh = gobjects(rowsp,colsp);
            rowOffset = 0; 
            for kk = 1:3
                for ll = 1:colsp
                    indPlot = ll+(rowOffset * colsp);
%                     disp([kk,ll,indPlot]); 
                    gh(kk,ll) = subplot(colsp,rowsp,indPlot); 
                end
                rowOffset = rowOffset + 1; 
            end
            network = GridChartNetwork(6,5);
            network.h = h; 
            network.gh = gh; 
            network2 = GridChartNetwork(6,5);
            network2.h = h; 
            network2.gh = gh;             
            network2.inputDirectionBias = pi/4; 
            network2.buildNetwork(); 
            network3 = GridChartNetwork(6,5);
            network3.h = h; 
            network3.gh = gh;             
            network3.inputGain = 50; 
            network3.buildNetwork(); 
            for ii = 1:100
                for jj = 1:10
                    network.step();
                    network2.step();
                    network3.step();
                    if jj == 10
                        figure(h);
                        network.plotAll(1); 
                        network2.plotAll(2); 
                        network3.plotAll(3);                         
%                         subplot(331);
%                         network.plotActivation();
%                         subplot(332);
%                         network.plotRateMap(); 
%                         subplot(333);
%                         network.plotTrajectory(); 
%                         subplot(334); 
%                         network2.plotActivation();
%                         subplot(335);
%                         network2.plotRateMap(); 
%                         subplot(336);
%                         network2.plotTrajectory(); 
%                         subplot(337); 
%                         network3.plotActivation();
%                         subplot(338);
%                         network3.plotRateMap(); 
%                         subplot(339);
%                         network3.plotTrajectory(); 
                        drawnow; 
                    end
                end
            end
        end
    end
end