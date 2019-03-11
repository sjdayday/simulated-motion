%% Turn class:  
% invokes turn.xml PetriNet with speed, direction and distance parameters, and tracks distance turned  
classdef Turn <  Behavior  

    properties
         distanceTurned
         clockwiseNess
         speed
         turnPrefix
    end
    methods
        function obj = Turn(prefix, animal, clockwiseNess, speed, distance)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal);
            obj.defaultPetriNet = 'include-move-turn.xml';
            obj.turnPrefix = [prefix,'Turn.'];
            obj.buildThreadedStandardSemantics();
%             obj.runner.setFiringDelay(50);
%             obj.listenPlace([prefix, 'Turned'], @obj.turned);      
            obj.markPlace([obj.prefix,'Turn']);  
            obj.listenPlaceWithAcknowledgement([obj.turnPrefix, 'Turned'], @obj.turned); 
            if (clockwiseNess == 1)
                obj.markPlace([obj.turnPrefix, 'CounterClockwise']);
            end 
            if (clockwiseNess == -1)
                obj.markPlace([obj.turnPrefix, 'Clockwise']);                
            end
            obj.markPlaceMultipleTokens([obj.turnPrefix, 'Speed'], speed); 
            obj.markPlaceMultipleTokens([obj.turnPrefix, 'Distance'], distance); 
            obj.distanceTurned = 0; 
            obj.clockwiseNess = clockwiseNess; 
            obj.speed = speed; 
            obj.thread.start(); 
%             obj.run();
            while (~obj.isDone)
                pause(1); 
            end
            
           
        end
        
%         Turn('Move.Turn.', Animal(), -1, 1, 3);
        function turned(obj, ~, ~) 
%             disp([datestr(now),': about to pause']);
%             T = timer('TimerFcn',@(~,~)disp('Fired.'),'StartDelay',5);
%             start(T);
%             wait(T);
%              pause(1); 
            obj.distanceTurned = obj.distanceTurned + 1;
             disp(['distanceTurned: ',num2str(obj.distanceTurned)]); 
            obj.animal.turn(obj.clockwiseNess, obj.speed); 
%             obj.animal.hippocampalFormation.headDirectionSystem.updateTurnVelocity(obj.clockwiseNess * obj.speed); 
%             obj.animal.hippocampalFormation.headDirectionSystem.step(); 
%             disp(obj.animal.hippocampalFormation.headDirectionSystem.time); 
            obj.acknowledge('Turned'); 
            disp('exiting turned'); 
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
