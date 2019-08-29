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
%             obj.runner.setFiringDelay(50);
%             obj.listenPlace([prefix, 'Turned'], @obj.turned);      
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
%             obj.execute(); 
        end
        function done(obj, ~, ~)
            done@Behavior(obj, 1, 1); 
            obj.animal.turnDone(); 
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
    end
end
