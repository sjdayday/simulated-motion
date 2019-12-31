%% TestingBehaviorStatusStandalone class:  testing BehaviorStatus for included PNs 
% (copied from TurnBehaviorStatusStandalone; otherwise unmodified) 
classdef TestingBehaviorStatusStandalone < BehaviorStatus 

    properties
         clockwiseness
         speed
         distance 
    end
    methods
         function obj = TestingBehaviorStatusStandalone(prefix, runner)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@BehaviorStatus(prefix, runner);
            obj.acknowledging = true; 
         end
         function setupListeners(obj)
            setupListeners@BehaviorStatus(obj); 
         end
         function markPlaces(obj)
         end
        function done(obj, ~, ~)
            done@BehaviorStatus(obj, 1, 1);             
%             obj.behavior.done(); 
        end         
        function turned(obj, ~, ~) 
            obj.behavior.turned(); 
        end         
        function cleanup(obj)
           obj.standaloneCleanup();  
        end
    end
end
