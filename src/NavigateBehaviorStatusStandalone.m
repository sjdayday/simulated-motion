%% NavigateBehaviorStatusStandalone class:  behaviorStatus for Navigate Petri net running standalone 
% Navigate is currently the top-level PN, so always runs standalone.
classdef NavigateBehaviorStatusStandalone < BehaviorStatus 

    properties
         clockwiseness
         speed
         distance 
         turn  
         moveBehaviorStatus
         finish
    end
    methods
         function obj = NavigateBehaviorStatusStandalone(prefix, runner)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@BehaviorStatus(prefix, runner);
            obj.defaultPetriNet = 'include-navigate-move-turn-run.xml';            
            obj.acknowledging = true; 
            obj.speed = 0; 
            obj.distance = 0; 
            obj.clockwiseness = 0; 
            obj.turn = false; 
         end
         function setupListeners(obj)
            setupListeners@BehaviorStatus(obj); 
            obj.moveBehaviorStatus = MoveBehaviorStatusInclude(obj.prefix, obj.runner);
            % premature?  behavior is Navigate; no Move exists yet
            obj.moveBehaviorStatus.behavior = obj.behavior; 
            obj.moveBehaviorStatus.setupListeners(); 
         end
        function markPlaces(obj)
            obj.moveBehaviorStatus.speed = obj.speed; 
            obj.moveBehaviorStatus.distance = obj.distance; 
            obj.moveBehaviorStatus.clockwiseness = obj.clockwiseness; 
            obj.moveBehaviorStatus.turn = obj.turn; 
            obj.moveBehaviorStatus.markPlaces(); 
        end
        function cleanup(obj)
%            disp('NavigateBehaviorStatusInclude: about to cleanup');  
           obj.standaloneCleanup(); 
        end
        function ready(obj, ~, ~)
%            obj.behavior.ready(); 
           ready@BehaviorStatus(obj, 1, 1); 
           if (obj.behavior.stopOnReadyForTesting)
              obj.doDone();  
           end
        end
        function done(obj, ~, ~)
            if (obj.finish)
                done@BehaviorStatus(obj, 1, 1); 
            else
                obj.acknowledgeDone();   
            end
            obj.behavior.done(); 
        end
    end
end
