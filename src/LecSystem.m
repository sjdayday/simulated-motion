%% LecSystem class:  simple model of Lateral Entorhinal Cortex (LEC)
% Detects angles to cues in the Environment
% Hard-coded expectation that there are three cues:  
%  Environment first cue (most salient)
%  Environment second cue
%  Environment nearest wall or a third cue 
% Builds a canonical view of the cues, calculating as if current head
% direction was towards the most salient cue, and then calculating the
% angles to the second cue and the nearest wall / third cue from that angle.  
% For a given position in the arena, this means that there is one canonical
% view of the cues, rather than one for each possible head direction at
% that position.  
classdef LecSystem < System 

    properties
%         distanceUnits
        nHeadDirectionCells
        nCueIntervals
        nFeatures
%         rewardUnits
        reward
        nOutput
        lecOutput
        environment
        index
        headDirectionSystem
        cueActivation
        cueHeadDirection
        featureWeights
%         featureGain
%         featureOffset       
        featureLearningRate
        featuresDetected
        nFeatureDetectors
        readMode
        twoCuesOnly
%         offset 
    end
    methods
        function obj = LecSystem()
            obj = obj@System(); 
%             obj.distanceUnits = 8;
            obj.nHeadDirectionCells = 60;
            % cue intervals should divide nHeadDirectionCells evenly 
            obj.nCueIntervals = obj.nHeadDirectionCells; 
            % set default number of features as if environment was present
            % because animal doesn't know its environment until it is
            % placed, and LecSystem is created (through
            % HippocampalFormation) before that, we need to hard-code the
            % number of features rather than deriving it.  
            obj.nFeatures = 3; 
%             obj.rewardUnits = 5; 
            % default a head direction system, but expect to be overridden
%             obj.headDirectionSystem = HeadDirectionSystem(obj.nHeadDirectionCells); 
%             obj.headDirectionSystem.build(); 
            obj.cueHeadDirection = 1; % default
            obj.featureLearningRate = 0.5; 
            obj.nFeatureDetectors = 10; % default
            obj.readMode = 0; 
%             obj.featureGain = 10;
%             obj.featureOffset = 0.65; 
%             obj.offset = 0; 
            obj.twoCuesOnly = false; 
        end
        function build(obj)
            if obj.isEnvironmentPresentWithAtLeastTwoCues()
                if obj.environment.nCues == 2
                    if obj.twoCuesOnly
                        obj.nFeatures = 1; 
                    else
                        obj.nFeatures = 3;     
                    end
                else
                    obj.nFeatures = obj.environment.nCues;  
                end
               % obj.nFeatures defaults or is set externally
            end
%             featureLength = obj.distanceUnits + obj.nHeadDirectionCells; 
            obj.lecOutput = zeros(1, obj.nFeatures * obj.nCueIntervals); 
%             obj.reward = zeros(1,obj.rewardUnits);  
            obj.nOutput = length(obj.lecOutput); % + obj.rewardUnits; 
            obj.index = 0; 
            obj.cueActivation = zeros(1,obj.nHeadDirectionCells);
            obj.featuresDetected = zeros(1,obj.nFeatureDetectors);
            obj.featureWeights = zeros(length(obj.featuresDetected),obj.nCueIntervals); 
        end
        function setEnvironment(obj, environment)
           obj.environment = environment;  
        end
        function cuedEnvironment = isEnvironmentPresentWithAtLeastTwoCues(obj)
            cuedEnvironment = (isa(obj.environment,'Environment') && ...
                (obj.environment.nCues >= 2)) ; 
        end
        % canonical view:  
        %   head direction when pointing at most salient cue:
        %    1 to cueIntervals (e.g., 1-60)
        %   head direction offset from most salient cue head direction: 
        %    cueIntervals+1 to 2*cueIntervals (e.g., 61-120)
        % if only 2 cues
        %   direction to closest wall from most salient cue head direction: 
        %    2*cueIntervals+1 to 3*cueIntervals (e.g., 121-180)
        % else 
        %   head direction offset from most salient cue head direction: 
        %    2*cueIntervals+1 to 3*cueIntervals (e.g., 121-180)
        function buildCanonicalView(obj, headDirection)
            obj.lecOutput = zeros(1, obj.nOutput);
            if obj.isEnvironmentPresentWithAtLeastTwoCues()
                obj.index = 0; 
                obj.cueHeadDirection = obj.adjustHeadDirectionTowardSalientCue(headDirection); 
                if obj.twoCuesOnly
                    % nothing needed
                else
                    obj.updateLecOutput(obj.cueHeadDirection); 
                end
                obj.updateLecOutput(obj.environment.cueHeadDirectionOffset(2));
                if obj.environment.nCues == 2 
                    if obj.twoCuesOnly
                        % nothing needed
                    else
                        wallDirection = obj.environment.closestWallDirection(); 
                        obj.updateLecOutput(obj.environment.headDirectionOffset(wallDirection));                        
                    end
                else
                    obj.updateLecOutput(obj.environment.cueHeadDirectionOffset(3));
                end
            end
        end
%  Canonical head direction is the internal head direction when the animal
%  is pointing physically at the primary cue.  This allows us to "remember"
%  what the discrepancy is between physical and internal head direction
%  across placements in the environment. 

%   for debugging: 
%         function [radianPhysicalCueOffset, headDirectionRadians, radianHeadDirectionCueOffset, radianHeadDirectionOffset, canonicalHeadDirection] = ...
%           calculateCanonicalHeadDirectionForAnimalDirection(obj, physicalDirection)
        function canonicalHeadDirection = calculateCanonicalHeadDirection(obj, physicalDirection)
            saveDirection = obj.environment.getDirection(); 
            obj.environment.setDirection(physicalDirection);
            radianPhysicalCueOffset = obj.environment.cueDirectionOffset(1); 
            headDirectionRadians = obj.headDirectionSystem.angleForCurrentHeadDirection(); 
            obj.environment.setDirection(headDirectionRadians);
            radianHeadDirectionCueOffset = obj.environment.cueDirectionOffset(1); 
            cueDirection = obj.environment.cueDirection(1); 
            obj.environment.setDirection(saveDirection);
            radianHeadDirectionOffset = radianPhysicalCueOffset - radianHeadDirectionCueOffset ;
            radianCanonicalHeadDirection = radianHeadDirectionOffset + cueDirection; % +/- .00000001; rounding  
            canonicalHeadDirection = obj.environment.headDirectionOffset(radianCanonicalHeadDirection) ; 
            if canonicalHeadDirection < 0
                canonicalHeadDirection = canonicalHeadDirection + obj.nHeadDirectionCells;
            end
        end
        
        function buildCanonicalCueActivationForAnimalDirection(obj, physicalDirection)
            canonicalHeadDirection = obj.calculateCanonicalHeadDirection(physicalDirection);
            headDirection = obj.headDirectionSystem.getMaxActivationIndex(); 
            obj.buildCanonicalView(canonicalHeadDirection); 
            headActivation = obj.headDirectionSystem.uActivation; 
            positions = canonicalHeadDirection - headDirection; 
            obj.cueActivation = circshift(headActivation, positions); 
        end
        function maxIndex = getCueMaxActivationIndex(obj)
            maxIndex = find(obj.cueActivation==max(obj.cueActivation)); 
        end
        function updateLecOutput(obj, direction)
            if direction > 0
                cueDirectionRatio = ceil(direction * (obj.nCueIntervals / obj.nHeadDirectionCells)); 
                obj.lecOutput(1,obj.index+cueDirectionRatio) = 1; 
            end
            obj.index = obj.index + obj.nCueIntervals;             
        end
        function cueHeadDirection = adjustHeadDirectionTowardSalientCue(obj, headDirection) 
            obj.environment.setHeadDirection(headDirection);
            grossOffset = obj.environment.cueHeadDirectionOffset(1);  
            offset = obj.nHeadDirectionCells - grossOffset + 1;
            cueHeadDirection = headDirection - offset; 
            obj.environment.setHeadDirection(cueHeadDirection);
        end
        function updateFeatureWeights(obj)
%             obj.updateFeaturesDetected();
%             taken from HeadDirectionSystem

%             activation = zeros(1, obj.nHeadDirectionCells); 
%             activation(1,find(obj.uActivation == max(obj.uActivation))) = 0.3; 
%             newWeights = (obj.featuresDetected' * activation); 
%             activation = 1./(1+exp(-obj.uActivation.*obj.featureGain)) ...
%                 - obj.featureOffset; 
            newWeights = (obj.featuresDetected' * obj.cueActivation) - obj.featureWeights;  
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
        function featureInput = getFeatureInput(obj)
           featureInput = obj.featuresDetected * obj.featureWeights;  
        end
        
        function indices = outputIndices(obj)
           indices = find(obj.lecOutput == 1);    
        end
        function print = printOutputIndices(obj)
           print = mat2str(obj.outputIndices());   
        end       
        
        %% Single time step 
         function  step(obj)
            step@System(obj); 
% TODO: incorporate...
%             obj.updateFeatureWeights(); % can this be independent?  
%             if obj.readMode
%                 obj.updateActivationWithFeatureInputs();
%             else
%                 obj.updateActivationWithMotionInputs(); 
%             end
        end
        function plot(obj)
        end  
    end
end
