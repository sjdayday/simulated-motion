% HeadDirectionSystem class:  models the head direction system, as
% described in: 
% Skaggs, W. E., Knierim, J. J., Kudrimoti, H. S., & McNaughton, B. L. (1995). A model
% of the neural basis of the rat's sense of direction. Advances in Neural Information
% Processing Systems 7 , 7 , 173.
% some code and parameters modeled on NavratilovaEtAl2011.m from eric zilli
% - 20110829 - v1.01:
% http://senselab.med.yale.edu/ModelDb/showModel.cshtml?model=144006&file=/grid%20models%20package%20v1.007/NavratilovaEtAl2011.m
% Zilli, E. A. (2012). Models of grid cell spatial firing published 2005?2011. 
% Frontiers in neural circuits, 6.
classdef HeadDirectionSystem < handle 

    properties
        nHeadDirectionCells
        maxHeadWeight
        sigmaHeadWeight
        maxAngularWeight
        sigmaAngularWeight
        weightInputVector
        angularWeightInputVector
        headDirectionWeights
        firstPlot
        h
        activation
        xAxisValues
        xAxis
        time
        Ahist
        normalizedWeight
        currentActivationRatio
        clockwiseVelocity
        counterClockwiseVelocity
        clockwiseWeights
        counterClockwiseWeights
        angularWeightOffset
    end
    methods
        function obj = HeadDirectionSystem(nHeadDirectionCells)
            obj.nHeadDirectionCells = nHeadDirectionCells; 
            obj.maxHeadWeight = 1; % 0.965 zilli; rationale? 
            obj.maxAngularWeight = 1; 
%             obj.maxHeadWeight = 0.229*3*1.4; % zilli; rationale? 
%             disp(obj.maxHeadWeight);
            obj.sigmaHeadWeight  = 10; % zilli uses 15 for 100 cells 
            obj.sigmaAngularWeight = 5; 
            % number of cells in Y direction; suggest 9*k 
            obj.weightInputVector = obj.maxHeadWeight* ... 
                (normpdf(0:obj.nHeadDirectionCells-1,0.5,obj.sigmaHeadWeight)+ ...
                normpdf(1:obj.nHeadDirectionCells,0.5+obj.nHeadDirectionCells,obj.sigmaHeadWeight));
            obj.angularWeightInputVector = obj.maxAngularWeight* ...
                (normpdf(0:obj.nHeadDirectionCells-1,0,obj.sigmaAngularWeight)+ ...
                normpdf(0:obj.nHeadDirectionCells-1,obj.nHeadDirectionCells,obj.sigmaAngularWeight));
            %             buildHeadDirectionWeights(obj);
            obj.firstPlot = 1; 
            obj.xAxisValues = 1:nHeadDirectionCells*2; 
            obj.activation = rand(1,obj.nHeadDirectionCells); % /sqrt(obj.nHeadDirectionCells); 
%             obj.activation = rand(1,obj.nHeadDirectionCells)/sqrt(obj.nHeadDirectionCells); 
            obj.time = 0; 
            obj.Ahist = zeros(100,1);
            obj.normalizedWeight = 0.8;
            obj.counterClockwiseVelocity = 0;
            obj.clockwiseVelocity = 0;
            obj.angularWeightOffset = 8; 
        end
        function buildWeights(obj)
            obj.headDirectionWeights = toeplitz(obj.weightInputVector); 
            obj.clockwiseWeights = toeplitz(obj.angularWeightInputVector); 
            obj.counterClockwiseWeights = obj.clockwiseWeights ; 
            obj.clockwiseWeights = ... 
                [obj.clockwiseWeights((1+obj.angularWeightOffset):end,:); ...
                obj.clockwiseWeights(1:obj.angularWeightOffset,:)];
            obj.counterClockwiseWeights = ... 
                [obj.counterClockwiseWeights((end-obj.angularWeightOffset+1):end,:); ...
                obj.counterClockwiseWeights(1:end-obj.angularWeightOffset,:)];

%             L = length(obj.weightInputVector); 
%             obj.headDirectionWeights = zeros(L); 
%             for ii = 1:L
%                 for jj = 1:(L-(ii-1))
%                    obj.headDirectionWeights(jj+(ii-1),ii) = ...
%                        obj.weightInputVector(1,jj); 
%                 end
%                 if ii > 1
%                     for kk = 1:(ii-1)
%                         obj.headDirectionWeights(kk,ii) = ... 
%                             obj.weightInputVector(1,(L-ii+1+kk));
%                     end
%                 end
%             end
        end
        function  step(obj)
            obj.time = obj.time+1;
              
              
%                             obj.weights = obj.peakSynapticStrength * ... 
%                   exp(-squaredPairwiseDists/obj.weightStdDev^2) - ... 
%                   obj.shiftInhibitoryTail;
            obj.currentActivationRatio = min(obj.activation)/max(obj.activation); 
            deltaActivation = max(obj.activation) - min(obj.activation); 
            keepAlive = zeros(1,obj.nHeadDirectionCells);
%               keepAlive = rand(1,obj.nHeadDirectionCells) * exp(-deltaActivation);
%               keepAlive = ones(1,obj.nHeadDirectionCells)/2 * exp(-deltaActivation);
            synapticInput = ((obj.activation+keepAlive))*obj.headDirectionWeights + ...
                obj.activation*(obj.clockwiseVelocity*obj.clockwiseWeights) + ...
                obj.activation*(obj.counterClockwiseVelocity*obj.counterClockwiseWeights); % /((1-obj.currentActivationRatio)*2)

              % Activity based on the synaptic input.
              % Notice synapticInput/sum(activation) is equivalent to 
              % (activation/sum(activation))*weights', so the second
              % term is normalizedWeight times the synaptic inputs that would occur if the total
              % activity were normalized to 1. The first term is (1-normalizedWeight) times
              % the full synaptic activity. normalizedWeight is between 0 and 1 and weights
              % whether the input is completely normalized (normalizedWeight=1) or completely
              % "raw" or unnormalized (normalizedWeight=0).
            obj.activation = (1-obj.normalizedWeight)*synapticInput + ... 
                  obj.normalizedWeight*(synapticInput/sum(obj.activation));

              
%               obj.activation =  obj.activation * obj.headDirectionWeights ;
%             obj.Ahist(obj.time) = find(obj.activation == max(obj.activation)); 
%               obj.Ahist(obj.time) = max(obj.activation) - min(obj.activation); 

            obj.Ahist(obj.time) =  obj.currentActivationRatio ; 
%                 obj.Ahist(obj.time) =  deltaActivation ; 
%                             synapticInput = obj.activation*obj.weights';
% 
%               % Activity based on the synaptic input.
%               % Notice synapticInput/sum(activation) is equivalent to 
%               % (activation/sum(activation))*weights', so the second
%               % term is normalizedWeight times the synaptic inputs that would occur if the total
%               % activity were normalized to 1. The first term is (1-normalizedWeight) times
%               % the full synaptic activity. normalizedWeight is between 0 and 1 and weights
%               % whether the input is completely normalized (normalizedWeight=1) or completely
%               % "raw" or unnormalized (normalizedWeight=0).
%               obj.activation = (1-obj.normalizedWeight)*synapticInput + ... 
%                   obj.normalizedWeight*(synapticInput/sum(obj.activation));
% 
%               % Save activity of one cell for nostalgia's sake
%               % Ahist(time) = obj.activation(1,1);
% 
%               % Zero out negative activities
%               obj.activation(obj.activation<0) = 0;
%               saveStatistics(obj); 
        end
% 
%         function saveStatistics(obj)
%           % Save firing field information
% %               if useRealTrajectory
%             if obj.activation(obj.watchCell)>0
%               if obj.spikeind==size(obj.spikeCoords,1)
%                 % allocate space for next 1000 spikes:
%                 obj.spikeCoords(obj.spikeind+1000,:) = [0 0];
%                 obj.spikeCoords(obj.spikeind+1,:) = ...
%                     [obj.position(1,obj.time) obj.position(2,obj.time)];
%               else
%                 obj.spikeCoords(obj.spikeind+1,:) = ... 
%                     [obj.position(1,obj.time) obj.position(2,obj.time)];
%               end
%               obj.spikeind = obj.spikeind+1;
%             end
%             xindex = round((obj.position(1,obj.time)-obj.minX) / ...
%                 (obj.maxX-obj.minX)*obj.nSpatialBins)+1;
%             yindex = round((obj.position(2,obj.time)-obj.minY) / ...
%                 (obj.maxY-obj.minY)*obj.nSpatialBins)+1;
%             obj.occupancy(yindex,xindex) = obj.occupancy(yindex,xindex) + obj.dt;
%             obj.spikes(yindex,xindex) = obj.spikes(yindex,xindex) + obj.activation(obj.watchCell);
%         end
        function plot(obj)
            if obj.firstPlot
                obj.h = figure('color','w');
                drawnow
                obj.firstPlot = 0;
            end
            figure(obj.h);
            plot(obj.xAxisValues, [obj.activation obj.activation]);
%             plot(obj.xAxisValues, repmat(obj.activation,[1 2]));
            obj.xAxis = gca; 
            % these values only work if nHeadDirectionCells is 60
            obj.xAxis.XTick = [0 15 30 45 60 75 90 105 120];
            obj.xAxis.XTickLabel = ... 
                {'-360', '-270', '-180', '-90', '0', '90', '180', '270', '360'};
%             subplot(131);
%             imagesc(reshape(obj.activation,obj.nY,obj.nX));
%             axis square
%             title('Population activity')
%             set(gca,'ydir','normal')
%             subplot(132);
%             imagesc(obj.spikes./obj.occupancy);
%             axis square
%             set(gca,'ydir','normal')
%             t = obj.time*obj.dt; 
%             title({sprintf('t = %.1f ms',t),'Rate map'})
%             subplot(133);
%             plot(obj.position(1,1:obj.time),obj.position(2,1:obj.time));
%             hold on;
%             if ~isempty(obj.spikeCoords)
%             plot(obj.spikeCoords(2:obj.spikeind,1), ... 
%             obj.spikeCoords(2:obj.spikeind,2),'r.')
%             end
%             title({'Trajectory (blue)','and spikes (red)'})
%             axis square
            drawnow
        end        
    end
end
