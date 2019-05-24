%% LecSystem class:  simple model of Lateral Entorhinal Cortex (LEC)
classdef LecSystem < System 

    properties
%         distanceUnits
        nHeadDirectionCells
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
            obj.nFeatures = 3; 
%             obj.rewardUnits = 5; 
            obj.build();            
        end
        function build(obj)
%             featureLength = obj.distanceUnits + obj.nHeadDirectionCells; 
            obj.lecOutput = zeros(1, obj.nFeatures * obj.nHeadDirectionCells); 
%             obj.reward = zeros(1,obj.rewardUnits);  
            obj.nOutput = length(obj.lecOutput); % + obj.rewardUnits; 

        end
        function setEnvironment(obj, environment)
           obj.environment = environment;  
        end
        % canonical view:  
        %   head direction when pointing at most salient cue: 1-60
        %   head direction offset from most salient cue head direction 61-120
        %   direction to closest wall from most salient cue head direction 121-180
        function buildCanonicalView(obj, headDirection)
            obj.lecOutput = zeros(1, obj.nFeatures * obj.nHeadDirectionCells);
            if (isa(obj.environment,'Environment')) 
                obj.index = 0; 
                cueHeadDirection = obj.adjustHeadDirectionTowardSalientCue(headDirection); 
                obj.updateLecOutput(cueHeadDirection); 
                obj.updateLecOutput(obj.environment.cueHeadDirectionOffset(2));
                wallDirection = obj.environment.closestWallDirection(); 
                obj.updateLecOutput(obj.environment.headDirectionOffset(wallDirection));
            end
        end
        function updateLecOutput(obj, direction)
            obj.lecOutput(1,obj.index+direction) = 1; 
            obj.index = obj.index + obj.nHeadDirectionCells;             
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
