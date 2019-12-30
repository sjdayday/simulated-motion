%% Run class:  
% invokes run.xml PetriNet with speed, and distance parameters, and tracks distance turned  
classdef Run <  Behavior  

    properties
         distanceRun
         distance
         speed
    end
    methods
        function obj = Run(prefix, animal, speed, distance, behaviorStatus)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal, behaviorStatus);
            obj.distanceRun = 0; 
            obj.behaviorStatus.speed = speed; 
            obj.speed = speed; 
            obj.distance = distance; 
            obj.behaviorStatus.distance = distance; 
            obj.behaviorStatus.behavior = obj; 
            obj.runner = obj.behaviorStatus.buildThreadedRunner(); 
            obj.behaviorStatus.setupListeners();
            obj.behaviorStatus.markPlaces(); 
            
%             if (obj.standalone)
%                 obj.defaultPetriNet = 'run-SA.xml';                
% %             obj.buildThreadedStandardSemantics();            
%                 obj.buildThreadedRunner(); 
%                 if (listenAndMark)                    
%                     obj.listenPlaces();
%                     obj.markPlaces(); 
% %                     obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Speed'], speed); 
% %                     obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Distance'], distance); 
%                 end
% %                 obj.listenPlaceWithAcknowledgement([obj.behaviorPrefix, 'Stepped'], @obj.stepped);                 
%             else
%                 if (listenAndMark)                    
%                     obj.listenLocalPlaces(); 
%                 end
% caller builds runner and listens to places 
%                 obj.defaultPetriNet = 'include-move-turn-run.xml';               
%                 obj.buildThreadedRunner();                 
% move marks these 
%                 obj.behaviorPrefix = [prefix,'Run.']; 
%                 obj.markPlace([obj.prefix,'Run']);  
%                 obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Speed'], speed); 
%                 obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Distance'], distance); 
% 
% move has to mark this, or delegate here 
%                obj.listenPlaceWithAcknowledgement([obj.behaviorPrefix, 'Stepped'], @obj.stepped);                                 
%             end
%             obj.runner.setFiringDelay(50);
%             obj.listenPlace([prefix, 'Turned'], @obj.turned);      
%             obj.execute();  
        end
        function status = getStandaloneStatus(obj)
            status = RunBehaviorStatusStandalone(obj.prefix, []);
        end
        function status = getIncludeStatus(obj)
            % so far, unused
            status = RunBehaviorStatusInclude(obj.prefix, obj.runner); 
        end        
%         function markPlaces(obj)
%             obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Speed'], obj.speed); 
%             obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Distance'], obj.distance); 
%         end
%         
%         function listenPlaces(obj)
%             listenPlaces@Behavior(obj); 
%             obj.listenLocalPlaces(); 
%         end        
%         function listenLocalPlaces(obj)
%            obj.listenPlaceWithAcknowledgement([obj.prefix, 'Stepped'], @obj.stepped); 
% %            obj.listenPlaceWithAcknowledgement([obj.prefix, 'Done'], @obj.done);             
%         end
        
        function done(obj) % , ~, ~
%             if (obj.standalone)
%                 done@Behavior(obj, 1, 1); 
%             end
            obj.animal.runDone(); 
        end
        
%         Turn('Move.Turn.', Animal(), -1, 1, 3);
        function stepped(obj)  % , ~, ~ 
%             disp([datestr(now),': about to pause']);
%             T = timer('TimerFcn',@(~,~)disp('Fired.'),'StartDelay',5);
%             start(T);
%             wait(T);
%              pause(1); 
            obj.distanceRun = obj.distanceRun + 1;
             disp(['distanceRun: ',num2str(obj.distanceRun)]); 
            obj.animal.run(obj.speed); 
%             obj.animal.hippocampalFormation.headDirectionSystem.updateTurnVelocity(obj.clockwiseness * obj.speed); 
%             obj.animal.hippocampalFormation.headDirectionSystem.step(); 
%             disp(obj.animal.hippocampalFormation.headDirectionSystem.time); 
            obj.acknowledge('Stepped'); 
            disp('exiting stepped'); 
        end
    end
end
