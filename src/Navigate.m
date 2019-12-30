%% Navigate class:  
% invokes navigate.xml PetriNet 
% ...with speed, direction and distance parameters, and tracks distance turned  
classdef Navigate <  Behavior  

    properties
         distanceTurned
         clockwiseness
         speed
         finish
         stopOnReadyForTesting
    end
    methods
        function obj = Navigate(prefix, animal)
            import uk.ac.imperial.pipe.runner.*;
            runner = []; 
            obj = obj@Behavior(prefix, animal, runner);
            obj.placeReportLimit = 100; % otherwise, will consume lots of memory
            obj.defaultPetriNet = 'include-navigate-move-turn-run.xml';
            obj.behaviorPrefix = [prefix,'Move.']; % Turn or Run...
            obj.finish = false;
            obj.stopOnReadyForTesting = false; 
        end
        function build(obj)
            obj.buildThreadedStandardSemantics(); 
%             obj.runner.setFiringDelay(50);
%             obj.listenPlace([prefix, 'Turned'], @obj.turned);      
%             obj.markPlace([obj.prefix,'Turn']); 
            obj.listenPlaceWithAcknowledgementBothEvents([obj.prefix,'Simulated'], @obj.simulateChanged); 
%             obj.listenPlaceWithAcknowledgement([obj.behaviorPrefix, 'Turned'], @obj.turned); 
% %             obj.listenPlaceWithAcknowledgementBothEvents
%             if (clockwiseness == 1)
%                 obj.markPlace([obj.behaviorPrefix, 'CounterClockwise']);
%             end 
%             if (clockwiseness == -1)
%                 obj.markPlace([obj.behaviorPrefix, 'Clockwise']);                
%             end
%             obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Speed'], speed); 
%             obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Distance'], distance); 
%             obj.distanceTurned = 0; 
%             obj.clockwiseness = clockwiseness; 
%             obj.speed = speed;
%             obj.execute();             
        end
        function ready(obj, ~, ~)
           ready@Behavior(obj, 1, 1); 
           if (obj.stopOnReadyForTesting)
              obj.doDone();  
           end

        end
        
        function done(obj, ~, ~)
            if (obj.finish)
                done@Behavior(obj, 1, 1);                 
            end
            obj.animal.motorCortex.nextRandomNavigation(); 
        end
        function simulateChanged(obj, source, event)
            disp(['source name: ', source.Name]); 
            disp(['event class: ', class(event)]); 
            disp(['event name: ', event.Name]); 
        end
%         Turn('Move.Turn.', Animal(), -1, 1, 3);
%         function turned(obj, ~, ~) 
% %             disp([datestr(now),': about to pause']);
% %             T = timer('TimerFcn',@(~,~)disp('Fired.'),'StartDelay',5);
% %             start(T);
% %             wait(T);
% %              pause(1); 
%             obj.distanceTurned = obj.distanceTurned + 1;
%              disp(['distanceTurned: ',num2str(obj.distanceTurned)]); 
%             obj.animal.turn(obj.clockwiseness, obj.speed); 
% %             obj.animal.hippocampalFormation.headDirectionSystem.updateTurnVelocity(obj.clockwiseness * obj.speed); 
% %             obj.animal.hippocampalFormation.headDirectionSystem.step(); 
% %             disp(obj.animal.hippocampalFormation.headDirectionSystem.time); 
%             obj.acknowledge('Turned'); 
%             disp('exiting turned'); 
%         end
        
    end
end
