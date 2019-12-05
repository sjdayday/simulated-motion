%% Turn class:  
% invokes turn.xml PetriNet with speed, direction and distance parameters, and tracks distance turned  
classdef Turn <  Behavior  

    properties
         distanceTurned
         clockwiseNess
         speed
    end
    methods
        function obj = Turn(prefix, animal, clockwiseNess, speed, distance)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal);
            obj.defaultPetriNet = 'include-move-turn-run.xml';
            obj.behaviorPrefix = [prefix,'Turn.'];
            obj.buildThreadedStandardSemantics();
            obj.markPlace([obj.prefix,'Turn']);  
            obj.listenPlaceWithAcknowledgement([obj.behaviorPrefix, 'Turned'], @obj.turned); 
            if (clockwiseNess == 1)
                obj.markPlace([obj.behaviorPrefix, 'CounterClockwise']);
            end 
            if (clockwiseNess == -1)
                obj.markPlace([obj.behaviorPrefix, 'Clockwise']);                
            end
            obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Speed'], speed); 
            obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Distance'], distance); 
            obj.distanceTurned = 0; 
            obj.clockwiseNess = clockwiseNess; 
            obj.speed = speed;
        end
        function done(obj, ~, ~)
            done@Behavior(obj, 1, 1); 
            obj.animal.turnDone(); 
        end
        function turned(obj, ~, ~) 
            obj.distanceTurned = obj.distanceTurned + 1;
             disp(['distanceTurned: ',num2str(obj.distanceTurned)]); 
            obj.animal.turn(obj.clockwiseNess, obj.speed); 
            obj.acknowledge('Turned'); 
            disp('exiting turned'); 
        end
    end
end
