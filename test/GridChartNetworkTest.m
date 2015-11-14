classdef GridChartNetworkTest < AbstractTest
    methods (Test)
        function testCreateNetwork(testCase)
            network = GridChartNetwork(6,5);
            for ii = 1:100
                for jj = 1:10
                    network.step()
                    if jj == 10
                        network.plot()
                    end
                end
            end
        end
    end
end