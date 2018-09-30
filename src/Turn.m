%% Turn class:  
% invokes turn.xml PetriNet with speed, direction and distance parameters, and tracks distance turned  
classdef Turn <  Behavior  

    properties
         distanceTurned
         clockwiseNess
         speed
    end
    methods
%         function obj = Turn(prefix, animal)
%             import uk.ac.imperial.pipe.runner.*;
%             obj = obj@Behavior(prefix, animal);
%             obj.defaultPetriNet = 'include-move-turn.xml';
%             obj.buildStandardSemantics();
%             obj.listenPlace('Move.Turn.Turned', @obj.turned); 
%             obj.distanceTurned = 0; 
% %             fired = step@AutoassociativeNetwork(obj, obj.ECOutput, obj.DGOutput); 
%                        
%         end
        function obj = Turn(prefix, animal, clockwiseNess, speed, distance)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal);
            obj.defaultPetriNet = 'include-move-turn.xml';
            obj.buildStandardSemantics();
            obj.listenPlace([prefix, 'Turned'], @obj.turned); 
            if (clockwiseNess == 1)
                obj.markPlace([prefix, 'CounterClockwise']);
            end 
            if (clockwiseNess == -1)
                obj.markPlace([prefix, 'Clockwise']);                
            end
            obj.markPlaceMultipleTokens([prefix, 'Speed'], speed); 
            obj.markPlaceMultipleTokens([prefix, 'Distance'], distance); 
            obj.distanceTurned = 0; 
            obj.clockwiseNess = clockwiseNess; 
            obj.speed = speed; 
            obj.run();
            pause(1); 
           
        end
        
%         Turn('Move.Turn.', Animal(), -1, 1, 3);
        function turned(obj, ~, ~) 
            obj.distanceTurned = obj.distanceTurned + 1;
            obj.animal.turn(obj.clockwiseNess, obj.speed); 
            obj.animal.hippocampalFormation.headDirectionSystem.updateTurnVelocity(obj.clockwiseNess * obj.speed); 
            obj.animal.hippocampalFormation.headDirectionSystem.step(); 
%             disp(obj.animal.hippocampalFormation.headDirectionSystem.time); 
        end
%         function visualize(obj, visual)
%             obj.visual = visual; 
%             if visual
%                 obj.h = figure; 
%                 obj.chartSystem.h = obj.h;
%                 obj.headDirectionSystem.h = obj.h; 
%                 obj.animal.h = obj.h; 
% %                 setupDisplay(obj);  % do later
%             else
%                 if isvalid(obj.h) 
%                     close(obj.h)
%                 end
%             end
%         end
    end
end
