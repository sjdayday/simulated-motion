%% Run class:  
% invokes run.xml PetriNet with speed, and distance parameters, and tracks distance turned  
classdef Run <  Behavior  

    properties
         distanceRun
         speed
    end
    methods
        function obj = Run(prefix, animal, speed, distance, runner)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal, runner);
            if (obj.standalone)
                obj.defaultPetriNet = 'run-SA.xml';                
                obj.behaviorPrefix = '';                
%             obj.buildThreadedStandardSemantics();            
                obj.buildThreadedRunner(); 
                obj.listenPlaces(); 
                obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Speed'], speed); 
                obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Distance'], distance); 
%                 obj.listenPlaceWithAcknowledgement([obj.behaviorPrefix, 'Stepped'], @obj.stepped);                 
            else
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
            end


%             obj.runner.setFiringDelay(50);
%             obj.listenPlace([prefix, 'Turned'], @obj.turned);      


            obj.distanceRun = 0; 
            obj.speed = speed; 
%             obj.execute(); 
           
        end
        function listenPlaces(obj)
           listenPlaces@Behavior(obj); 
           obj.listenPlaceWithAcknowledgement([obj.behaviorPrefix, 'Stepped'], @obj.stepped); 
        end
        
        function done(obj, ~, ~)
            done@Behavior(obj, 1, 1); 
            obj.animal.runDone(); 
        end
        
%         Turn('Move.Turn.', Animal(), -1, 1, 3);
        function stepped(obj, ~, ~) 
%             disp([datestr(now),': about to pause']);
%             T = timer('TimerFcn',@(~,~)disp('Fired.'),'StartDelay',5);
%             start(T);
%             wait(T);
%              pause(1); 
            obj.distanceRun = obj.distanceRun + 1;
             disp(['distanceRun: ',num2str(obj.distanceRun)]); 
            obj.animal.run(obj.speed); 
%             obj.animal.hippocampalFormation.headDirectionSystem.updateTurnVelocity(obj.clockwiseNess * obj.speed); 
%             obj.animal.hippocampalFormation.headDirectionSystem.step(); 
%             disp(obj.animal.hippocampalFormation.headDirectionSystem.time); 
            obj.acknowledge('Stepped'); 
            disp('exiting stepped'); 
        end
    end
end
