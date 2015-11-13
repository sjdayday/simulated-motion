classdef GridChartNetworkTest < AbstractTest
    methods (Test)
        function testCreateNetwork(testCase)
            network = GridChartNetwork(10,9);
%             for ii = 1:200
%                 for jj = 1:10
%                     network.step()
%                     if jj == 10
%                         network.plot()
%                     end
%                 end
%             end
        end
    end
end
function network = createAutoassociativeNetwork(dimension)
    network = AutoassociativeNetwork(dimension);    
    network.weightType = 'binary'; %weights are binary
    network.buildNetwork(); 
end