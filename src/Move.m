%% Turn class:  
% invokes turn.xml PetriNet with speed, direction and distance parameters, and tracks distance turned  
classdef Move <  Behavior  

    properties
         distanceMoved
         speed
         clockwiseness
         turn
         behavior
    end
    methods                
        function obj = Move(prefix, animal, speed, distance, clockwiseness, turn, runner)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal, runner);
            if (obj.standalone)
                obj.defaultPetriNet = 'include-move-turn-run.xml';
%                 obj.buildThreadedStandardSemantics();                
                obj.buildThreadedRunner(); 
                obj.listenPlaces(); 
                obj.markPlaceMultipleTokens([obj.prefix, 'Speed'], speed); 
                obj.markPlaceMultipleTokens([obj.prefix, 'Distance'], distance); 
                obj.turn = turn; 
                if (turn)
                   obj.behaviorPrefix = [obj.prefix,'Turn.'];
                   obj.markPlace([obj.prefix,'Turn']);
                   if (clockwiseness == 1)
                        obj.markPlace([obj.prefix, 'CounterClockwise']);
                   end 
                   if (clockwiseness == -1)
                        obj.markPlace([obj.prefix, 'Clockwise']);                
                   end
                   obj.behavior = Turn(obj.behaviorPrefix, animal, clockwiseness, speed, distance, obj.runner); 
                   obj.behavior.acknowledging = true; 
                else     
                   obj.behaviorPrefix = [obj.prefix,'Run.']; 
                   obj.markPlace([obj.prefix,'Run']);  
                   obj.behavior = Run(obj.behaviorPrefix, animal, speed, distance, obj.runner);             
                   obj.behavior.acknowledging = true;                    
                end
            else
                % navigate here
            end


            obj.distanceMoved = 0; 
            obj.speed = speed; 
            obj.clockwiseness = clockwiseness; 
%            disp('move acknowledging: ');
%            disp(obj.acknowledging);           
%            disp('move standalone: ');
%            disp(obj.standalone);           

%             obj.execute(); 
           
        end
        function done(obj, ~, ~)
%             if (obj.standalone)
                disp(['prefix for move.done: ', obj.prefix]);
                done@Behavior(obj, 1, 1); 
%             end
            if (obj.turn)
                obj.distanceMoved = obj.behavior.distanceTurned; 
            else
                obj.distanceMoved = obj.behavior.distanceRun;
            end
        end        
    end
end
