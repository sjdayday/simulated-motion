%% Turn class:  
% invokes turn.xml PetriNet with speed, direction and distance parameters, and tracks distance turned  
classdef Turn <  Behavior  

    properties
         distanceTurned
         clockwiseness
         speed
%          distance 
    end
    methods        
        function obj = Turn(prefix, animal, clockwiseness, speed, distance, behaviorStatus, build)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal, behaviorStatus);
            obj.distanceTurned = 0; 
            obj.clockwiseness = clockwiseness; 
            obj.behaviorStatus.clockwiseness = clockwiseness; 
            obj.speed = speed;
            obj.behaviorStatus.speed = speed;            
            obj.behaviorStatus.distance = distance; 
            obj.behaviorStatus.behavior = obj; 
            if (build)
                obj.build(); 
            end            
        end
        function status = getStandaloneStatus(obj)
            status = TurnBehaviorStatusStandalone(obj.prefix, []);
        end
        function status = getIncludeStatus(obj)
            status = TurnBehaviorStatusInclude(obj.prefix, obj.runner); 
        end

        function done(obj) % , ~, ~
            obj.animal.turnDone(); 
        end
        function turned(obj) % , ~, ~ 
            obj.distanceTurned = obj.distanceTurned + 1;
             disp(['distanceTurned: ',num2str(obj.distanceTurned)]); 
            obj.animal.turn(obj.clockwiseness, obj.speed); 
            obj.acknowledge('Turned'); 
            disp('exiting turned'); 
        end
    end
end
