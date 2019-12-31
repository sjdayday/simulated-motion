%% Turn class:  
% invokes turn.xml PetriNet with speed, direction and distance parameters, and tracks distance turned  
classdef Move <  Behavior  

    properties
         distanceMoved
         speed
         distance
         clockwiseness
         turn
         includeBehavior % needs to be set by behaviorStatus
    end
    methods                
        function obj = Move(prefix, animal, speed, distance, clockwiseness, turn, behaviorStatus, build)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal, behaviorStatus);
            obj.distanceMoved = 0; 
            obj.behaviorStatus.speed = speed; 
            obj.behaviorStatus.clockwiseness = clockwiseness; 
            obj.behaviorStatus.distance = distance;
            obj.turn = turn; 
            obj.behaviorStatus.turn = turn; 
            obj.behaviorStatus.behavior = obj; 
            if (build)
                obj.build(); 
            end
        end
        function status = getStandaloneStatus(obj)
            status = MoveBehaviorStatusStandalone(obj.prefix, []);
        end
        function status = getIncludeStatus(obj)
            status = MoveBehaviorStatusInclude(obj.prefix, obj.runner); 
        end        
        function done(obj) 
                disp(['prefix for move.done: ', obj.behaviorStatus.prefix]);
            if (obj.turn)
                obj.distanceMoved = obj.includeBehavior.distanceTurned; 
            else
                obj.distanceMoved = obj.includeBehavior.distanceRun;
            end
        end        
    end
end
