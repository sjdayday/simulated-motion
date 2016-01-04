%% ExperimentController class:  controller for ExperimentView
% invokes classes as requested through the ExperimentView GUI 
classdef ExperimentController < handle 

    properties
        chartSystem
        headDirectionSystem
        nChartSystemSingleDimensionCells
        nHeadDirectionCells
        hFigures
        totalSteps
        currentStep
    end
    methods
        function obj = ExperimentController()
%             obj.hFigures = figure; 
            obj.nChartSystemSingleDimensionCells = 10;  % default
            obj.nHeadDirectionCells = 60;  %default
            obj.currentStep = 1; 
            buildHeadDirectionSystem(obj, obj.nHeadDirectionCells);
            buildChartSystem(obj, obj.nChartSystemSingleDimensionCells);
        end
        function buildHeadDirectionSystem(obj, nHeadDirectionCells)
            obj.headDirectionSystem = HeadDirectionSystem(nHeadDirectionCells); 
        end
        function buildChartSystem(obj, nChartSystemSingleDimensionCells)
            obj.chartSystem = ChartSystem(nChartSystemSingleDimensionCells); 
        end
        function runHeadDirectionSystem(obj)
            obj.headDirectionSystem.buildWeights(); 
            for ii = obj.currentStep:obj.totalSteps
               obj.headDirectionSystem.step(); 
%                disp(ii);   % 1
               obj.currentStep = obj.currentStep + 1; 
%                disp(obj.currentStep); %2 
%                disp(obj.headDirectionSystem.time); %2 
            end
        end
        function runChartSystem(obj)
            obj.chartSystem.buildWeights(); 
            for ii = obj.currentStep:obj.totalSteps
               obj.chartSystem.step(); 
%                disp(ii); %21
               obj.currentStep = obj.currentStep + 1; 
%                disp(obj.currentStep);  %22 
%                disp(obj.chartSystem.time); %1 
            end
        end
        %% Single time step 
        function  step(obj)
%             obj.time = obj.time+1;
% %             updateFeatureWeights(obj);                 
%             obj.currentActivationRatio = min(obj.uActivation)/max(obj.uActivation);
%             activationFunction(obj); 
% %             rate = zeros(10)
%             synapticInput = headDirectionInput(obj); % obj.rate'*obj.wHeadDirectionWeights*
% %             synapticInput = obj.rate*obj.wHeadDirectionWeights*obj.dx; % obj.rate'*obj.wHeadDirectionWeights*
% %             flip = rot90(rot90(rot90(obj.rate))); 
% %             syn2 = flip*obj.wHeadDirectionWeights*obj.dx;
%             
% %             synapticInput = obj.rate*obj.wHeadDirectionWeights*obj.dx + ...
% %                 obj.uActivation*(obj.clockwiseVelocity*obj.positiveDirectionWeights) + ...
% %                 obj.uActivation*(obj.counterClockwiseVelocity*obj.negativeDirectionWeights) + ...
% %                 + obj.uActivation * obj.featureWeights; % .* obj.featuresDetected; % /((1-obj.currentActivationRatio)*2)
% 
%             obj.uActivation = synapticInput; 
% %             obj.uActivation = synapticInput+rot90(syn2); 
% %             obj.uActivation = (1-obj.normalizedWeight)*synapticInput + ... 
% %                   obj.normalizedWeight*(synapticInput/sum(obj.uActivation));
% 
%               
% %               obj.activation =  obj.activation * obj.headDirectionWeights ;
% %             obj.Ahist(obj.time) = find(obj.activation == max(obj.activation)); 
% %               obj.Ahist(obj.time) = max(obj.activation) - min(obj.activation); 
% 
% %                 obj.Ahist(obj.time) =  deltaActivation ; 
% %                             synapticInput = obj.activation*obj.weights';
% % 
% %               saveStatistics(obj); 
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
            % plot the smoothed activation before we stretch it
%             plot(obj.xAxisValues, [obj.activationBeforeStabilization obj.activationBeforeStabilization]);
            surf(obj.uActivation); 
            view(45,45); 
%             plot(obj.xAxisValues, [obj.uActivation obj.uActivation]); 
% %             plot(obj.xAxisValues, repmat(obj.activation,[1 2]));
%             obj.xAxis = gca; 
%             % these values only work if nSingleDimensionCells is 60
%             obj.xAxis.XTick = [0 15 30 45 60 75 90 105 120];
%             obj.xAxis.XTickLabel = ... 
%                 {'-2\pi', '-3\pi/2', '-\pi', '-\pi/2', '0', '\pi/2', '\pi', '3\pi/2', '2\pi'};
% %                 {'-360', '-270', '-180', '-90', '0', '90', '180', '270', '360'};
%             title({'Head direction',sprintf('time = %d ',obj.time)});
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
