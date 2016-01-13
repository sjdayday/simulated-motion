%% ChartSystem class:  models a chart, as in: 
% Samsonovich, A., & McNaughton, B. L. (1997). Path integration and cognitive mapping in
% a continuous attractor neural network model. The Journal of neuroscience, 17 (15),
% 5900{5920.
% This class is roughly an extension of HeadDirectionSystem, from 1D to 2D
classdef ChartSystem < System 

    properties
        nSingleDimensionCells
        maxAngularWeight
        sigmaAngularWeight
        angularWeightInputVector
        wHeadDirectionWeights
        featureWeights
        firstPlot
        h
        uActivation
        normalizedWeight
        currentActivationRatio
        positiveDirectionWeights
        negativeDirectionWeights
        directionWeightOffset
        featuresDetected
        featureLearningRate
        rate
        betaGain
        alphaOffset
        weightPattern
        sigmaWeightPattern
        CInhibitionOffset
        dx
        totalCells
        location
        xAxisValues
        xAxis
        Ahist

    end
    methods
        function obj = ChartSystem(nSingleDimensionCells)
            obj = obj@System();             
            obj.nSingleDimensionCells = nSingleDimensionCells; 
            obj.totalCells = nSingleDimensionCells * nSingleDimensionCells; 
            obj.maxAngularWeight = 1; 
            obj.sigmaAngularWeight = 5; 
            obj.angularWeightInputVector = obj.maxAngularWeight* ...
                (normpdf(0:obj.nSingleDimensionCells-1,0,obj.sigmaAngularWeight)+ ...
                normpdf(0:obj.nSingleDimensionCells-1,obj.nSingleDimensionCells,obj.sigmaAngularWeight));
            obj.firstPlot = 1; 
            obj.xAxisValues = 1:nSingleDimensionCells*2; 
            obj.uActivation = 2*rand(obj.nSingleDimensionCells,obj.nSingleDimensionCells);
            obj.Ahist = zeros(100,1);
            obj.normalizedWeight = 0.0;  % 0.8
            obj.directionWeightOffset = 8; 
            obj.featuresDetected = zeros(1,obj.nSingleDimensionCells);
            obj.featureWeights = zeros(obj.nSingleDimensionCells); 
            obj.featureLearningRate = 0.5; 
            % activation function parameters 
            obj.betaGain = 0.42; % was .75
            obj.alphaOffset = 0; 
            obj.sigmaWeightPattern = 0.7; %  2*pi/10
            obj.CInhibitionOffset = 0.02; 
            obj.dx = 1; % /obj.nSingleDimensionCells; 
        end
        function addEvent(obj, time, event)
            obj.eventMap(time) = event; 
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
                    for jj = 1:obj.nSingleDimensionCells;
                        distanceX = min(abs(ii-loc(1)),obj.nSingleDimensionCells-abs(ii-loc(1)));
                        distanceY = min(abs(jj-loc(2)),obj.nSingleDimensionCells-abs(jj-loc(2)));
                        distance = sqrt(distanceX.^2 + distanceY.^2);
                        t=exp(-(distance*obj.dx).^2/(2*obj.sigmaWeightPattern^2));
                        t = 4*(t-obj.CInhibitionOffset); % was 4
                        obj.wHeadDirectionWeights(ii,jj,kk) = t;
                    end
                end
            end

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
            activation = 1./(1+exp(-obj.uActivation.*10)) -0.65; 
            newWeights = (obj.featuresDetected' * activation) - obj.featureWeights;  
            % only update rows where features were detected
            for ii = 1:length(obj.featuresDetected)
                newWeights(ii,:) = obj.featuresDetected(1,ii).* newWeights(ii,:);
            end
            obj.featureWeights = obj.featureWeights + obj.featureLearningRate*(newWeights);
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
            step@System(obj); 
%             updateFeatureWeights(obj);                 
            obj.currentActivationRatio = min(obj.uActivation)/max(obj.uActivation);
            activationFunction(obj); 
            synapticInput = headDirectionInput(obj); 
            obj.uActivation = synapticInput; 
            obj.Ahist(obj.time) =  obj.currentActivationRatio ; 
        end
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
            surf(obj.uActivation); 
            view(45,45); 
            drawnow
        end        
    end
end
