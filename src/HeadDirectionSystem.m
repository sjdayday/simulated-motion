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
classdef HeadDirectionSystem < System 

    properties
        nHeadDirectionCells
        maxHeadWeight
        sigmaHeadWeight
        maxAngularWeight
        sigmaAngularWeight
        weightInputVector
        angularWeightInputVector
        wHeadDirectionWeights
        featureWeights
        maxFeatureWeight
        firstPlot
        firstCirclePlot
        h
        uActivation
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
        featuresDetected
        featureLearningRate
        stabilized
        lastDeltaMin
        lastMax
        activationBeforeStabilization
        rate
        betaGain
        alphaOffset
        weightPattern
        sigmaWeightPattern
        CInhibitionOffset
        dx
        marker
        animal
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
%             obj.weightInputVector = obj.maxHeadWeight* ... 
%                 (normpdf(0:obj.nHeadDirectionCells-1,0.5,obj.sigmaHeadWeight)+ ...
%                 normpdf(1:obj.nHeadDirectionCells,0.5+obj.nHeadDirectionCells,obj.sigmaHeadWeight));
            obj.angularWeightInputVector = obj.maxAngularWeight* ...
                (normpdf(0:obj.nHeadDirectionCells-1,0,obj.sigmaAngularWeight)+ ...
                normpdf(0:obj.nHeadDirectionCells-1,obj.nHeadDirectionCells,obj.sigmaAngularWeight));
            obj.firstPlot = 1; 
            obj.firstCirclePlot = 1; 
            obj.xAxisValues = 1:nHeadDirectionCells; 
            obj.uActivation = rand(1,obj.nHeadDirectionCells); % /sqrt(obj.nHeadDirectionCells); 
            obj.time = 0; 
            obj.Ahist = zeros(100,1);
            obj.normalizedWeight = 0.0;  % 0.8
            obj.counterClockwiseVelocity = 0;
            obj.clockwiseVelocity = 0;
            obj.angularWeightOffset = 8; 
            obj.featuresDetected = zeros(1,obj.nHeadDirectionCells);
            obj.featureWeights = zeros(obj.nHeadDirectionCells); 
            obj.featureLearningRate = 0.5; 
            obj.stabilized = 0; 
            % activation function parameters 
            obj.betaGain = 1; 
            obj.alphaOffset = 0; 
            obj.sigmaWeightPattern = 2*pi/10; 
            obj.CInhibitionOffset = 0.5; 
            obj.dx = 2*pi/obj.nHeadDirectionCells; 
%             obj.maxFeatureWeight = 0.35; % not needed as yet 
        end
        function buildWeights(obj)
            % nn = 100; dx=2*pi/nn; sigma = 2*pi/10; C=0.5;
            for loc=1:obj.nHeadDirectionCells
                i = (1:obj.nHeadDirectionCells)'; 
                dis = min(abs(i-loc),obj.nHeadDirectionCells-abs(i-loc));
                obj.weightPattern(:,loc)=exp(-(dis*obj.dx).^2/(2*obj.sigmaWeightPattern^2));
            end
            % gaussian weights peaking on diagonal and wrapping
            % pat in [0,1]
            obj.wHeadDirectionWeights = obj.weightPattern*obj.weightPattern'; % weights in ca. [0, 18] 
            obj.wHeadDirectionWeights = obj.wHeadDirectionWeights/obj.wHeadDirectionWeights(1,1); % normalized by max value, so in [0,1]
            obj.wHeadDirectionWeights = 4*(obj.wHeadDirectionWeights-obj.CInhibitionOffset); % in [-2,2]
%             obj.headDirectionWeights = toeplitz(obj.weightInputVector); 
            obj.clockwiseWeights = toeplitz(obj.angularWeightInputVector); 
            obj.counterClockwiseWeights = obj.clockwiseWeights ; 
            obj.clockwiseWeights = ... 
                [obj.clockwiseWeights((1+obj.angularWeightOffset):end,:); ...
                obj.clockwiseWeights(1:obj.angularWeightOffset,:)];
            obj.counterClockwiseWeights = ... 
                [obj.counterClockwiseWeights((end-obj.angularWeightOffset+1):end,:); ...
                obj.counterClockwiseWeights(1:end-obj.angularWeightOffset,:)];
        end
        function updateFeatureWeights(obj)
            % sigmoidal, negative at small activation values, linear over 
            % most of the activation range, tops out about 0.35, which acts
            % as an implementation of "Wmax"
            % see Skaggs, figure 4, "f()".  
            postActivation = 1./(1+exp(-obj.uActivation.*10)) -0.65; 
%             newWeights = (postActivation' * obj.featuresDetected) - obj.featureWeights;  
            newWeights = (obj.featuresDetected' * postActivation) - obj.featureWeights;  
            % only update rows where features were detected
            for ii = 1:length(obj.featuresDetected)
%                 newWeights(:,ii) = obj.featuresDetected(1,ii).* newWeights(:,ii);
                newWeights(ii,:) = obj.featuresDetected(1,ii).* newWeights(ii,:);
            end
            obj.featureWeights = obj.featureWeights + obj.featureLearningRate*(newWeights);
%             obj.featureWeights = obj.featureLearningRate*(postActivation - obj.featureWeights)*obj.featuresDetected;            
        end
        function  updateVelocity(obj)
           obj.clockwiseVelocity = obj.animal.clockwiseVelocity;  
           obj.counterClockwiseVelocity = obj.animal.counterClockwiseVelocity;             
        end

        %% Trappenberg sigmoidal activation function (equation 7.2)
        function activationFunction(obj)
           obj.rate = 1 ./ (1 + exp(obj.betaGain * (-obj.uActivation - obj.alphaOffset)));  
        end
        %% Single time step 
        function  step(obj)
            obj.time = obj.time+1;
            updateVelocity(obj); 
            updateFeatureWeights(obj);                 
            obj.currentActivationRatio = min(obj.uActivation)/max(obj.uActivation);
            activationFunction(obj); 
            synapticInput = obj.rate*obj.wHeadDirectionWeights*obj.dx + ...
                obj.uActivation*(obj.clockwiseVelocity*obj.clockwiseWeights) + ...
                obj.uActivation*(obj.counterClockwiseVelocity*obj.counterClockwiseWeights) + ...
                + obj.uActivation * obj.featureWeights; % .* obj.featuresDetected; % /((1-obj.currentActivationRatio)*2)

              % Activity based on the synaptic input.
              % Notice synapticInput/sum(activation) is equivalent to 
              % (activation/sum(activation))*weights', so the second
              % term is normalizedWeight times the synaptic inputs that would occur if the total
              % activity were normalized to 1. The first term is (1-normalizedWeight) times
              % the full synaptic activity. normalizedWeight is between 0 and 1 and weights
              % whether the input is completely normalized (normalizedWeight=1) or completely
              % "raw" or unnormalized (normalizedWeight=0).
            obj.uActivation = (1-obj.normalizedWeight)*synapticInput + ... 
                  obj.normalizedWeight*(synapticInput/sum(obj.uActivation));

              
%               obj.activation =  obj.activation * obj.headDirectionWeights ;
%             obj.Ahist(obj.time) = find(obj.activation == max(obj.activation)); 
%               obj.Ahist(obj.time) = max(obj.activation) - min(obj.activation); 

            obj.Ahist(obj.time) =  obj.currentActivationRatio ; 
%                 obj.Ahist(obj.time) =  deltaActivation ; 
%                             synapticInput = obj.activation*obj.weights';
% 
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
        function plotCircle(obj)
            figure(obj.h)
            hold on; 
            axis manual;
            if obj.firstCirclePlot
%                 hold on;
%                 maxActivation = max(obj.uActivation); 
                obj.marker = plot(1,0, ...
                    'o','MarkerFaceColor','black','MarkerSize',10,'MarkerEdgeColor','black');
                drawnow;
                pause(1);
                obj.firstCirclePlot = 0;
            else
                index = find(obj.uActivation==max(obj.uActivation)); 
                radians = ((obj.nHeadDirectionCells-index)/obj.nHeadDirectionCells)*2*pi; 
                obj.marker.XData = cos(radians); 
                obj.marker.YData = sin(radians); 
                drawnow;
                
            end            

        end
        function plotActivation(obj)
            figure(obj.h)
            hold off; 
            plot(obj.xAxisValues, obj.uActivation); 
%             plot(obj.xAxisValues, repmat(obj.activation,[1 2]));
            obj.xAxis = gca; 
            % these values only work if nHeadDirectionCells is 60
            obj.xAxis.XTick = [0 15 30 45 60];
            obj.xAxis.XTickLabel = ... 
                {'2\pi', '3\pi/2', '\pi', '\pi/2', '0'};
%                 {'-2\pi', '-3\pi/2', '-\pi', '-\pi/2', '0', '\pi/2', '\pi', '3\pi/2', '2\pi'};
%                 {'-360', '-270', '-180', '-90', '0', '90', '180', '270', '360'};
%             title({'Head direction',sprintf('time = %d ',obj.time)});


        end
        function plot(obj)
            if obj.firstPlot
                obj.h = figure('color','w');
                drawnow
                obj.firstPlot = 0;
            end
            figure(obj.h);
            % plot the smoothed activation before we stretch it
%             plot(obj.xAxisValues, [obj.activationBeforeStabilization obj.activationBeforeStabilization]);
            plot(obj.xAxisValues, obj.uActivation); 
%             plot(obj.xAxisValues, repmat(obj.activation,[1 2]));
            obj.xAxis = gca; 
            % these values only work if nHeadDirectionCells is 60
            obj.xAxis.XTick = [0 15 30 45 60 75 90 105 120];
            obj.xAxis.XTickLabel = ... 
                {'-2\pi', '-3\pi/2', '-\pi', '-\pi/2', '0', '\pi/2', '\pi', '3\pi/2', '2\pi'};
%                 {'-360', '-270', '-180', '-90', '0', '90', '180', '270', '360'};
            title({'Head direction',sprintf('time = %d ',obj.time)});
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
