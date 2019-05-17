%% Turn class:  
% invokes turn.xml PetriNet with speed, direction and distance parameters, and tracks distance turned  
classdef Run <  Behavior  

    properties
         distanceRun
         speed
         runPrefix
    end
    methods
        function obj = Run(prefix, animal, speed, distance)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal);
            obj.defaultPetriNet = 'include-move-turn-run.xml';
            obj.runPrefix = [prefix,'Run.'];
            obj.buildThreadedStandardSemantics();
%             obj.runner.setFiringDelay(50);
%             obj.listenPlace([prefix, 'Turned'], @obj.turned);      
            obj.markPlace([obj.prefix,'Run']);  
            obj.listenPlaceWithAcknowledgement([obj.runPrefix, 'Stepped'], @obj.stepped); 
            obj.markPlaceMultipleTokens([obj.runPrefix, 'Speed'], speed); 
            obj.markPlaceMultipleTokens([obj.runPrefix, 'Distance'], distance); 
            obj.distanceRun = 0; 
            obj.speed = speed; 
            obj.thread.start(); 
%             obj.run();
            while (~obj.isDone)
                pause(1); 
            end
            
           
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
