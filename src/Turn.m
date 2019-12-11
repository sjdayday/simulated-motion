%% Turn class:  
% invokes turn.xml PetriNet with speed, direction and distance parameters, and tracks distance turned  
classdef Turn <  Behavior  

    properties
         distanceTurned
         clockwiseNess
         speed
    end
    methods        
        function obj = Turn(prefix, animal, clockwiseNess, speed, distance, runner)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal, runner);
             if (obj.standalone)
                obj.defaultPetriNet = 'turn-SA.xml';
                obj.behaviorPrefix = '';                
%                 obj.buildThreadedStandardSemantics();   
                obj.buildThreadedRunner(); 
                obj.listenPlaces(); 
                if (clockwiseNess == 1)
                    obj.markPlace([obj.behaviorPrefix, 'CounterClockwise']);
                end 
                if (clockwiseNess == -1)
                    obj.markPlace([obj.behaviorPrefix, 'Clockwise']);                
                end
                obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Speed'], speed); 
                obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Distance'], distance); 

            else
% do we still neeed behaviorPrefix?               
                obj.behaviorPrefix = obj.prefix;
                obj.listenLocalPlaces(); 
%                 obj.defaultPetriNet = 'include-move-turn-run.xml';
%                 obj.markPlace([obj.prefix,'Turn']);  
            end 
            obj.distanceTurned = 0; 
            obj.clockwiseNess = clockwiseNess; 
            obj.speed = speed;
        end
        function listenPlaces(obj)
            listenPlaces@Behavior(obj); 
            obj.listenLocalPlaces(); 
        end
        function listenLocalPlaces(obj)
            obj.listenPlaceWithAcknowledgement([obj.behaviorPrefix, 'Turned'], @obj.turned); 
        end

        function done(obj, ~, ~)
            if (obj.standalone)
                done@Behavior(obj, 1, 1); 
            end
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
