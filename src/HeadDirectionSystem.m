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
        maxAngularWeight
        sigmaAngularWeight
        angularWeightInputVector
        angularWeightOffset
        angularWeightPercent
        wHeadDirectionWeights
        featureWeights
        featureGain
        featureOffset       
        firstPlot
        firstCirclePlot
        h
        uActivation
        normalizedWeight
        currentActivationRatio
        clockwiseVelocity
        counterClockwiseVelocity
        clockwiseWeights
        counterClockwiseWeights  
        featuresDetected
        nFeatureDetectors
        featureLearningRate
        includeFeatureInput
        rate
        betaGain
        alphaOffset
        weightPattern
        sigmaWeightPattern
        CInhibitionOffset
        dx
        marker
        % TODO:  don't pull from Animal; push instead
        animal
        xAxisValues
        xAxis
        Ahist
        readMode
        pullVelocity
        pullFeatures
        minimumVelocity
        animalVelocityCalibration
    end
    methods
        function obj = HeadDirectionSystem(nHeadDirectionCells)
            obj = obj@System();             
            obj.nHeadDirectionCells = nHeadDirectionCells; 
            obj.maxAngularWeight = 1; 
            obj.sigmaAngularWeight = 5; 
            obj.angularWeightInputVector = obj.maxAngularWeight* ...
                (normpdf(0:obj.nHeadDirectionCells-1,0,obj.sigmaAngularWeight)+ ...
                normpdf(0:obj.nHeadDirectionCells-1,obj.nHeadDirectionCells,obj.sigmaAngularWeight));
            obj.firstPlot = 1; 
            obj.firstCirclePlot = 1; 
            obj.xAxisValues = 1:nHeadDirectionCells; 
            initializeActivation(obj, true); 
            obj.Ahist = zeros(100,1);
            obj.normalizedWeight = 0.0;  % 0.8 was 0
            obj.minimumVelocity = pi/20; % radians per time step 
            obj.animalVelocityCalibration = 1.4; %might not be needed if updateTurnVelocity reconciled w updateVelocity
            obj.counterClockwiseVelocity = 0;
            obj.clockwiseVelocity = 0;
            obj.angularWeightPercent = 0.133; % 8/60
%             obj.angularWeightOffset = 8; % built later
            obj.nFeatureDetectors = 100;             
%             obj.featuresDetected = zeros(1,obj.nFeatureDetectors);
%             obj.featureWeights = zeros(length(obj.featuresDetected),obj.nHeadDirectionCells); 
            obj.featureLearningRate = 0.5; 
            obj.featureGain = 10;
            obj.featureOffset = 0.65; 
            
            % activation function parameters 
            obj.betaGain = 1; 
            obj.alphaOffset = 0; 
            obj.sigmaWeightPattern = 2*pi/10; 
            obj.CInhibitionOffset = 0.35; % was 0.5 
            obj.dx = 2*pi/obj.nHeadDirectionCells; 
            obj.readMode = 0;
            obj.pullVelocity = true;
            obj.pullFeatures = true; 
            obj.includeFeatureInput = true; 

        end
        function initializeActivation(obj, random)
           if random
               obj.uActivation = rand(1,obj.nHeadDirectionCells); 
%                disp('random uActivation:');
%                disp(obj.uActivation); 
           else
               obj.uActivation = zeros(1,obj.nHeadDirectionCells);
               obj.uActivation = obj.uActivation + 0.25;
               obj.uActivation(1,obj.nHeadDirectionCells) = 0.8; 
           end
        end
        function build(obj)
            for loc=1:obj.nHeadDirectionCells
                i = (1:obj.nHeadDirectionCells)'; 
                dis = min(abs(i-loc),obj.nHeadDirectionCells-abs(i-loc));
                obj.weightPattern(:,loc)=exp(-(dis*obj.dx).^2/(2*obj.sigmaWeightPattern^2));
            end
            % gaussian weights peaking on diagonal and wrapping
            obj.buildAngularWeightOffset(); 
            obj.wHeadDirectionWeights = obj.weightPattern*obj.weightPattern'; % weights in ca. [0, 18] 
            obj.wHeadDirectionWeights = obj.wHeadDirectionWeights/obj.wHeadDirectionWeights(1,1); % normalized by max value, so in [0,1]
            obj.wHeadDirectionWeights = 4*(obj.wHeadDirectionWeights-obj.CInhibitionOffset); % in [-2,2] 12: [-1.4, 2.6]
            obj.clockwiseWeights = toeplitz(obj.angularWeightInputVector); 
            obj.counterClockwiseWeights = toeplitz(obj.angularWeightInputVector); 
            obj.counterClockwiseWeights = ... 
                [obj.counterClockwiseWeights((1+obj.angularWeightOffset):end,:); ...
                obj.counterClockwiseWeights(1:obj.angularWeightOffset,:)];
            obj.clockwiseWeights = ... 
                [obj.clockwiseWeights((end-obj.angularWeightOffset+1):end,:); ...
                obj.clockwiseWeights(1:end-obj.angularWeightOffset,:)];
            obj.featuresDetected = zeros(1,obj.nFeatureDetectors);
            obj.featureWeights = zeros(length(obj.featuresDetected),obj.nHeadDirectionCells); 
%             disp('minimum velocity:'); 
%             disp(obj.minimumVelocity); 
            obj.setChildTimekeeper(obj); 
        end
        function buildAngularWeightOffset(obj)
            obj.angularWeightOffset = ceil(obj.angularWeightPercent * obj.nHeadDirectionCells); % 8 for 60, 2 for 12
        end
        % not necessary here, but consistent with pattern for higher-level
        % components, e.g. HippocampalFormation
        function setChildTimekeeper(obj, timekeeper) 
           obj.setTimekeeper(timekeeper);  
        end
        function setFeaturesDetected(obj, featuresDetected)
            obj.featuresDetected = featuresDetected; 
            obj.pullFeatures = false; 
        end
        function updateFeaturesDetected(obj)
           if obj.pullFeatures 
                if isempty(obj.animal.features)
                    % TODO:  why needed? 
                    obj.featuresDetected = zeros(1,obj.nFeatureDetectors);
                else
                    for ii = obj.animal.features
                        obj.featuresDetected(1,ii) = 1; 
                    end
                end               
           else
               % hippocampalFormation has pushed new obj.featuresDetected
           end
        end
        function updateFeatureWeights(obj)
            obj.updateFeaturesDetected(); 
            % approximation of Skaggs, figure 4, "f()".  
            % based on sigmoidal function, negative at small activation 
            % values, linear over most of the activation range, 
            % topping out about 0.35, which acts
            % as an implementation of "Wmax"

%             activation = zeros(1, obj.nHeadDirectionCells); 
%             activation(1,find(obj.uActivation == max(obj.uActivation))) = 0.3; 
%             newWeights = (obj.featuresDetected' * activation); 
            activation = 1./(1+exp(-obj.uActivation.*obj.featureGain)) ...
                - obj.featureOffset; 
            newWeights = (obj.featuresDetected' * activation) - obj.featureWeights;  
            % only update rows where features were detected
            for ii = 1:length(obj.featuresDetected)
                newWeights(ii,:) = obj.featuresDetected(1,ii).* newWeights(ii,:);
            end
            if obj.readMode
               newWeights = zeros(size(obj.featureWeights));  
%                newWeights = zeros(obj.nHeadDirectionCells);  
            end
            obj.featureWeights = obj.featureWeights + obj.featureLearningRate*(newWeights);
%             disp(['HDS feature detectors: ',mat2str(find(obj.featuresDetected == 1))]);
%             disp(['HDS feature weights: ',mat2str(find(obj.featureWeights > 0))]);
        end
        function signedAngularVelocity = updateTurnVelocity(obj, velocity)
            signedAngularVelocity = obj.minimumVelocity * velocity; 
            obj.updateAngularVelocity(signedAngularVelocity);
        end
        function updateAngularVelocity(obj, velocity)
           obj.pullVelocity = false; 
%            velocity = velocity * 5; 
           if velocity > 0 
               obj.counterClockwiseVelocity = velocity; 
               obj.clockwiseVelocity = 0; 
           elseif velocity < 0
               obj.clockwiseVelocity = -velocity; 
               obj.counterClockwiseVelocity = 0; 
           else
               obj.counterClockwiseVelocity = 0;
               obj.clockwiseVelocity = 0; 
           end
        end
        function  updateVelocity(obj)
            if obj.pullVelocity 
               obj.clockwiseVelocity = -obj.animal.clockwiseVelocity * obj.animalVelocityCalibration;  
               obj.counterClockwiseVelocity = obj.animal.counterClockwiseVelocity * obj.animalVelocityCalibration;             
            % else someone is calling updateAngularVelocity(obj, velocity)
            end
        end

        %% Trappenberg sigmoidal activation function (equation 7.2)
        function activationFunction(obj)
           obj.rate = 1 ./ (1 + exp(obj.betaGain * (-obj.uActivation - obj.alphaOffset)));  
        end
        function updateActivationWithMotionInputs(obj)
            obj.updateVelocity();             
            obj.currentActivationRatio = min(obj.uActivation)/max(obj.uActivation); % may not be needed
            obj.activationFunction(); 
            clockwiseInput = obj.uActivation*(obj.clockwiseVelocity*obj.clockwiseWeights); 
            counterClockwiseInput = obj.uActivation*(obj.counterClockwiseVelocity*obj.counterClockwiseWeights); 
%             synapticInput = obj.rate*obj.wHeadDirectionWeights*obj.dx + ...
            motionInput = clockwiseInput + counterClockwiseInput; % + featureInput; 
           % with normalizedWeight = 0, this is just synapticInput  
            obj.updateActivation(motionInput); 
%             obj.updateActivation(synapticInput); 
%             obj.uActivation = (1-obj.normalizedWeight)*synapticInput + ... 
%                   obj.normalizedWeight*(synapticInput/sum(obj.uActivation));
        end
        function updateActivationWithFeatureInputs(obj)
            obj.activationFunction();
            obj.updateFeatureWeights(); 
            featureInput = obj.featuresDetected * obj.featureWeights; 
%             if obj.includeFeatureInput
%                 synapticInput = synapticInput + featureInput; 
%             end
            obj.updateActivation(featureInput); 
        end
        function updateActivation(obj, input)
            synapticInput = obj.rate*obj.wHeadDirectionWeights*obj.dx + input;

            obj.uActivation = (1-obj.normalizedWeight)*synapticInput + ... 
                  obj.normalizedWeight*(synapticInput/sum(obj.uActivation));
        end
        
        %% Single time step
        function  step(obj)
            step@System(obj); 
%             obj.updateVelocity(); 
            obj.updateFeatureWeights(); % can this be independent?  
            if obj.readMode
                obj.updateActivationWithFeatureInputs();
            else
                obj.updateActivationWithMotionInputs(); 
            end
%             obj.currentActivationRatio = min(obj.uActivation)/max(obj.uActivation);
%             obj.activationFunction(); 
%             clockwiseInput = obj.uActivation*(obj.clockwiseVelocity*obj.clockwiseWeights); 
%             counterClockwiseInput = obj.uActivation*(obj.counterClockwiseVelocity*obj.counterClockwiseWeights); 
%             clockwiseInput = clockwiseInput * 5; % temp
%             counterClockwiseInput = counterClockwiseInput * 5;  % temp
%             featureInput = obj.featuresDetected * obj.featureWeights; 
%             synapticInput = obj.rate*obj.wHeadDirectionWeights*obj.dx + ...
%                 clockwiseInput + counterClockwiseInput; % + featureInput; 
%             if obj.includeFeatureInput
%                 synapticInput = synapticInput + featureInput; 
%             end
            % FIXME separate motion from feature input
                % obj.uActivation % .* obj.featuresDetected; % /((1-obj.currentActivationRatio)*2)
            
            % with normalizedWeight = 0, this is just synapticInput   
%             obj.updateActivation(synapticInput); 
%             obj.uActivation = (1-obj.normalizedWeight)*synapticInput + ... 
%                   obj.normalizedWeight*(synapticInput/sum(obj.uActivation));

            obj.Ahist(obj.getTime()) =  obj.currentActivationRatio ; 
            disp(['HeadDirectionSystem time: ',num2str(obj.getTime()),' activation: ',num2str(obj.getMaxActivationIndex())]); 
        end
        function maxIndex = getMaxActivationIndex(obj)
            maxIndex = find(obj.uActivation==max(obj.uActivation)); 
        end
        function plotCircle(obj)
            figure(obj.h)
            hold on; 
            axis manual;
            if not(isempty(obj.animal.features))   
                hold on
                plot(.9192,.9192, ...
                    'o','MarkerFaceColor','blue','MarkerSize',5,'MarkerEdgeColor','blue');
                plot(-1.3,0, ...
                    'o','MarkerFaceColor','blue','MarkerSize',5,'MarkerEdgeColor','blue');
            end                
            if obj.firstCirclePlot
                obj.marker = plot(1,0, ...
                    'o','MarkerFaceColor','black','MarkerSize',10,'MarkerEdgeColor','black');
                drawnow;
                pause(1);
                obj.firstCirclePlot = 0;
            else
                index = obj.getMaxActivationIndex(); 
%                 index = find(obj.uActivation==max(obj.uActivation)); 
%                radians = ((obj.nHeadDirectionCells-index)/obj.nHeadDirectionCells)*2*pi; 
              radians = (index/obj.nHeadDirectionCells)*2*pi; 
                obj.marker.XData = cos(radians); 
                obj.marker.YData = sin(radians); 
                drawnow;
                
            end            

        end
        function plotActivation(obj)
            % assumes nHeadDirectionCells is 60
            figure(obj.h)
            hold off; 
            plot(obj.xAxisValues, obj.uActivation); 
            obj.xAxis = gca; 
            obj.xAxis.XTick = [0 15 30 45 60];
            obj.xAxis.XTickLabel = ... 
                {'0', '\pi/2', '\pi', '3\pi/2', '2\pi'};
            title({'Head direction activation',sprintf('t = %d',obj.getTime()+1)})
        end
        function plot(obj)
            if obj.firstPlot
                obj.h = figure('color','w');
                drawnow
                obj.firstPlot = 0;
            end
            figure(obj.h);
            plot(obj.xAxisValues, obj.uActivation); 
            obj.xAxis = gca; 
            obj.xAxis.XTick = [0 15 30 45 60 75 90 105 120];
            obj.xAxis.XTickLabel = ... 
                {'-2\pi', '-3\pi/2', '-\pi', '-\pi/2', '0', '\pi/2', '\pi', '3\pi/2', '2\pi'};
            title({'Head direction',sprintf('time = %d ',obj.getTime())});
            drawnow
        end        
    end
end
