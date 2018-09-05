%% ExperimentController class:  controller for ExperimentView
% invokes classes as requested through the ExperimentView GUI 
classdef Turn <  Behavior  

    properties
         distanceTurned
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
        function obj = Turn(prefix, animal, direction, speed, distance)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal);
            obj.defaultPetriNet = 'include-move-turn.xml';
            obj.buildStandardSemantics();
            obj.listenPlace([prefix, 'Turned'], @obj.turned); 
            if (direction == 1)
                obj.markPlace([prefix, 'CounterClockwise']);
            end 
            if (direction == -1)
                obj.markPlace([prefix, 'Clockwise']);                
            end
            obj.markPlaceMultipleTokens([prefix, 'Speed'], speed); 
            obj.markPlaceMultipleTokens([prefix, 'Distance'], distance); 
            obj.distanceTurned = 0; 
            obj.run();
            pause(1); 
           
        end
        
%         Turn('Move.Turn.', Animal(), -1, 1, 3);
        function turned(obj, ~, ~) 
            obj.distanceTurned = obj.distanceTurned + 1; 
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
