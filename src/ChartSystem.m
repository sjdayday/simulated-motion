% ChartSystem class:  models the head direction system, as
% described in: 
% Skaggs, W. E., Knierim, J. J., Kudrimoti, H. S., & McNaughton, B. L. (1995). A model
% of the neural basis of the rat's sense of direction. Advances in Neural Information
% Processing Systems 7 , 7 , 173.
% some code and parameters modeled on NavratilovaEtAl2011.m from eric zilli
% - 20110829 - v1.01:
% http://senselab.med.yale.edu/ModelDb/showModel.cshtml?model=144006&file=/grid%20models%20package%20v1.007/NavratilovaEtAl2011.m
% Zilli, E. A. (2012). Models of grid cell spatial firing published 2005?2011. 
% Frontiers in neural circuits, 6.
classdef ChartSystem < System 

    properties
        nSingleDimensionCells
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
        positiveDirectionWeights
        negativeDirectionWeights
        directionWeightOffset
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
        totalCells
        location
    end
    methods
        function obj = ChartSystem(nSingleDimensionCells)
            obj.nSingleDimensionCells = nSingleDimensionCells; 
            obj.totalCells = nSingleDimensionCells * nSingleDimensionCells; 
            obj.maxHeadWeight = 1; % 0.965 zilli; rationale? 
            obj.maxAngularWeight = 1; 
%             obj.maxHeadWeight = 0.229*3*1.4; % zilli; rationale? 
%             disp(obj.maxHeadWeight);
            obj.sigmaHeadWeight  = 10; % zilli uses 15 for 100 cells 
            obj.sigmaAngularWeight = 5; 
%             obj.weightInputVector = obj.maxHeadWeight* ... 
%                 (normpdf(0:obj.nSingleDimensionCells-1,0.5,obj.sigmaHeadWeight)+ ...
%                 normpdf(1:obj.nSingleDimensionCells,0.5+obj.nSingleDimensionCells,obj.sigmaHeadWeight));
            obj.angularWeightInputVector = obj.maxAngularWeight* ...
                (normpdf(0:obj.nSingleDimensionCells-1,0,obj.sigmaAngularWeight)+ ...
                normpdf(0:obj.nSingleDimensionCells-1,obj.nSingleDimensionCells,obj.sigmaAngularWeight));
            obj.firstPlot = 1; 
            obj.xAxisValues = 1:nSingleDimensionCells*2; 
%             obj.uActivation = ones(obj.nSingleDimensionCells); % /sqrt(obj.nSingleDimensionCells); 
%             obj.uActivation(70,10) = 2; 
            obj.uActivation = 2*rand(obj.nSingleDimensionCells,obj.nSingleDimensionCells); % /sqrt(obj.nSingleDimensionCells); 
            obj.time = 0; 
            obj.Ahist = zeros(100,1);
            obj.normalizedWeight = 0.0;  % 0.8
            obj.counterClockwiseVelocity = 0;
            obj.clockwiseVelocity = 0;
            obj.directionWeightOffset = 8; 
            obj.featuresDetected = zeros(1,obj.nSingleDimensionCells);
            obj.featureWeights = zeros(obj.nSingleDimensionCells); 
            obj.featureLearningRate = 0.5; 
            obj.stabilized = 0; 
            % activation function parameters 
            obj.betaGain = 0.42; % was .75
            obj.alphaOffset = 0; 
            obj.sigmaWeightPattern = 0.7; %  2*pi/10
            obj.CInhibitionOffset = 0.02; 
            obj.dx = 1; % /obj.nSingleDimensionCells; 
%             obj.maxFeatureWeight = 0.35; % not needed as yet 
        end
        function buildWeights(obj)
            obj.location = zeros(obj.totalCells,2); 
            index = 1;
            for ii = 1:obj.nSingleDimensionCells
                for jj = 1:obj.nSingleDimensionCells
                    obj.location(index,:) = [ii jj]; 
                    index = index+1;
                end;
            end;
            obj.wHeadDirectionWeights = zeros(obj.nSingleDimensionCells,obj.nSingleDimensionCells,obj.totalCells); 
            for kk = 1:obj.totalCells
                loc = obj.location(kk,:); 
                for ii = 1:obj.nSingleDimensionCells; 
            %         weightPattern = zeros(nn); 
                    for jj = 1:obj.nSingleDimensionCells;
                        distanceX = min(abs(ii-loc(1)),obj.nSingleDimensionCells-abs(ii-loc(1)));
                        distanceY = min(abs(jj-loc(2)),obj.nSingleDimensionCells-abs(jj-loc(2)));
                        distance = sqrt(distanceX.^2 + distanceY.^2);
                        t=exp(-(distance*obj.dx).^2/(2*obj.sigmaWeightPattern^2));
                        t = 4*(t-obj.CInhibitionOffset); % was 4
                        obj.wHeadDirectionWeights(ii,jj,kk) = t;
                    end
            %         t = weightPattern*weightPattern'; 
            %         t = t/t(1,1); 
            %         kk = kk + 1;
                end
            end

            % nn = 100; dx=2*pi/nn; sigma = 2*pi/10; C=0.5;
%             for loc=1:obj.nSingleDimensionCells
%                 i = (1:obj.nSingleDimensionCells)'; 
%                 dis = min(abs(i-loc),obj.nSingleDimensionCells-abs(i-loc));
%                 obj.weightPattern(:,loc)=exp(-(dis*obj.dx).^2/(2*obj.sigmaWeightPattern^2));
%             end
%             % gaussian weights peaking on diagonal and wrapping
%             % pat in [0,1]
%             obj.wHeadDirectionWeights = obj.weightPattern*obj.weightPattern'; % weights in ca. [0, 18] 
%             obj.wHeadDirectionWeights = obj.wHeadDirectionWeights/obj.wHeadDirectionWeights(1,1); % normalized by max value, so in [0,1]
%             obj.wHeadDirectionWeights = 4*(obj.wHeadDirectionWeights-obj.CInhibitionOffset); % in [-2,2]
%             obj.headDirectionWeights = toeplitz(obj.weightInputVector); 
            obj.positiveDirectionWeights = toeplitz(obj.angularWeightInputVector); 
            obj.negativeDirectionWeights = obj.positiveDirectionWeights ; 
            obj.positiveDirectionWeights = ... 
                [obj.positiveDirectionWeights((1+obj.directionWeightOffset):end,:); ...
                obj.positiveDirectionWeights(1:obj.directionWeightOffset,:)];
            obj.negativeDirectionWeights = ... 
                [obj.negativeDirectionWeights((end-obj.directionWeightOffset+1):end,:); ...
                obj.negativeDirectionWeights(1:end-obj.directionWeightOffset,:)];
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
         %% Trappenberg sigmoidal activation function (equation 7.2)
        function activationFunction(obj)
           obj.rate = 1 ./ (1 + exp(obj.betaGain * (-obj.uActivation - obj.alphaOffset)));  
        end
        function input = headDirectionInput(obj)
           input = zeros(obj.nSingleDimensionCells); 
           for kk = 1:obj.totalCells
               cellActivation = obj.rate .* obj.wHeadDirectionWeights(:,:,kk);
               loc = obj.location(kk,:); 
               input(loc(1),loc(2)) = sum(sum(cellActivation))  * obj.dx; 
           end
        end
        %% Single time step 
        function  step(obj)
            obj.time = obj.time+1;
%             updateFeatureWeights(obj);                 
            obj.currentActivationRatio = min(obj.uActivation)/max(obj.uActivation);
            activationFunction(obj); 
%             rate = zeros(10)
% rate(1,:) = ones(1,10);
% rate
% tt(:,:,92) .* rate
% u = zeros(10)
% b = [1 1 1 ; 2 2 2 ; 3 3 3]
% sum(b)
% sum(sum(b))
% rr = tt(:,:,92) .* rate
% u(1,1) = sum(sum(rr)
% u(1,1) = sum(sum(rr))
% sum(tt(:,:,92))
% sum(tt(1,:,92))
            synapticInput = headDirectionInput(obj); % obj.rate'*obj.wHeadDirectionWeights*
%             synapticInput = obj.rate*obj.wHeadDirectionWeights*obj.dx; % obj.rate'*obj.wHeadDirectionWeights*
%             flip = rot90(rot90(rot90(obj.rate))); 
%             syn2 = flip*obj.wHeadDirectionWeights*obj.dx;
            
%             synapticInput = obj.rate*obj.wHeadDirectionWeights*obj.dx + ...
%                 obj.uActivation*(obj.clockwiseVelocity*obj.positiveDirectionWeights) + ...
%                 obj.uActivation*(obj.counterClockwiseVelocity*obj.negativeDirectionWeights) + ...
%                 + obj.uActivation * obj.featureWeights; % .* obj.featuresDetected; % /((1-obj.currentActivationRatio)*2)

              % Activity based on the synaptic input.
              % Notice synapticInput/sum(activation) is equivalent to 
              % (activation/sum(activation))*weights', so the second
              % term is normalizedWeight times the synaptic inputs that would occur if the total
              % activity were normalized to 1. The first term is (1-normalizedWeight) times
              % the full synaptic activity. normalizedWeight is between 0 and 1 and weights
              % whether the input is completely normalized (normalizedWeight=1) or completely
              % "raw" or unnormalized (normalizedWeight=0).
            obj.uActivation = synapticInput; 
%             obj.uActivation = synapticInput+rot90(syn2); 
%             obj.uActivation = (1-obj.normalizedWeight)*synapticInput + ... 
%                   obj.normalizedWeight*(synapticInput/sum(obj.uActivation));

              
%               obj.activation =  obj.activation * obj.headDirectionWeights ;
%             obj.Ahist(obj.time) = find(obj.activation == max(obj.activation)); 
%               obj.Ahist(obj.time) = max(obj.activation) - min(obj.activation); 

            obj.Ahist(obj.time) =  obj.currentActivationRatio ; 
%                 obj.Ahist(obj.time) =  deltaActivation ; 
%                             synapticInput = obj.activation*obj.weights';
% 
%               saveStatistics(obj); 
        end
%         function maxSlope = getMetrics(obj)
        function [numMax , maxSlope] = getMetrics(obj)
            act = obj.uActivation; 
            maxes = find(act==max(max(act))); 
            numMax = length(maxes); 
            mm = act(maxes(1)); 
            slopes = zeros(4,1); 
            if maxes(1) > 1
                slopes(1,1) = mm / act(maxes(1)-1); 
            end
            if maxes(1) < obj.totalCells
                slopes(2,1) = mm / act(maxes(1)+1); 
            end
            if maxes(1) > 10
                slopes(3,1) = mm / act(maxes(1)-10); 
            end
            if maxes(1) < obj.totalCells-10
                slopes(4,1) = mm / act(maxes(1)+10); 
            end
            maxSlope = max(slopes); 
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
