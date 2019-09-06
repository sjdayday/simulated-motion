%% LecSystem class:  simple model of Lateral Entorhinal Cortex (LEC)
% Detects angles to cues in the Environment
% Hard-coded expectation that there are three cues:  
%  Environment first cue (most salient)
%  Environment second cue
%  Environment nearest wall  
% Builds a canonical view of the cues, calculating as if current head
% direction was towards the most salient cue, and then calculating the
% angles to the second cue and the nearest wall from that angle.  
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
        end
        function build(obj)
            if obj.isEnvironmentPresentWithAtLeastTwoCues()
                if obj.environment.nCues == 2
                    obj.nFeatures = 3;     
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
        end
        function setEnvironment(obj, environment)
           obj.environment = environment;  
        end
        function cuedEnvironment = isEnvironmentPresentWithAtLeastTwoCues(obj)
            cuedEnvironment = (isa(obj.environment,'Environment') && ...
                (obj.environment.nCues >= 2)) ; 
        end
        % canonical view:  
        %   head direction when pointing at most salient cue: 1-60
        %   head direction offset from most salient cue head direction 61-120
        % if only 2 cues
        %   direction to closest wall from most salient cue head direction 121-180
        % else 
        %   head direction offset from most salient cue head direction 121-180
        function buildCanonicalView(obj, headDirection)
            obj.lecOutput = zeros(1, obj.nOutput);
            if obj.isEnvironmentPresentWithAtLeastTwoCues()
                obj.index = 0; 
                cueHeadDirection = obj.adjustHeadDirectionTowardSalientCue(headDirection); 
                obj.updateLecOutput(cueHeadDirection); 
                obj.updateLecOutput(obj.environment.cueHeadDirectionOffset(2));
                if obj.environment.nCues == 2 
                    wallDirection = obj.environment.closestWallDirection(); 
                    obj.updateLecOutput(obj.environment.headDirectionOffset(wallDirection));
                else
                    obj.updateLecOutput(obj.environment.cueHeadDirectionOffset(3));
                end
            end
        end
        function updateLecOutput(obj, direction)
            if direction > 0
                cueDirectionRatio = ceil(direction * (obj.nCueIntervals / obj.nHeadDirectionCells)); 
                obj.lecOutput(1,obj.index+cueDirectionRatio) = 1; 
            end
            obj.index = obj.index + obj.nCueIntervals;             
        end
        function cueHeadDirection=adjustHeadDirectionTowardSalientCue(obj, headDirection) 
            obj.environment.setHeadDirection(headDirection);
            offset = obj.environment.cueHeadDirectionOffset(1);  
            cueHeadDirection = headDirection - (obj.nHeadDirectionCells - offset) - 1; 
%             disp(['cueHeadDirection ',num2str(cueHeadDirection)]); 
            obj.environment.setHeadDirection(cueHeadDirection);
        end
        %% Single time step 
        function  step(obj)
            step@System(obj); 
        end
        function plot(obj)
        end  
    end
end
