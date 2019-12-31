%% BehaviorStatus class:  base class for behaviorStatus 
% BehaviorStatus handles the different possible life cycles for a Behavior 
% Standalone behaviors map one to one with a single Petri net, creating and destroying 
%  a single PetrinetRunner
% Include behaviors map to an IncludeHierarchy.  Only the top level
%  creates a PetrinetRunner; lower levels use the existing runner. 
% For included Petri nets that might execute multiple times, listeners may just be 
%  created once, while places that act as input parameters may be marked at each 
%  execution. 
classdef MoveBehaviorStatusStandalone < BehaviorStatus 

    properties
         clockwiseness
         speed
         distance 
         turn  
         turnBehaviorStatus
         runBehaviorStatus
    end
    methods
         function obj = MoveBehaviorStatusStandalone(prefix, runner)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@BehaviorStatus(prefix, runner);
            obj.defaultPetriNet = 'include-move-turn-run.xml';            
            obj.acknowledging = true; 
         end
         function setupListeners(obj)
            setupListeners@BehaviorStatus(obj); 
            obj.turnBehaviorStatus = TurnBehaviorStatusInclude(obj.prefix, obj.runner); 
            obj.turnBehaviorStatus.setupListeners(); 
            obj.runBehaviorStatus = RunBehaviorStatusInclude(obj.prefix, obj.runner);
            obj.runBehaviorStatus.setupListeners(); 
         end
        function markPlaces(obj) 
            obj.markPlaceMultipleTokens([obj.prefix, 'Speed'], obj.speed); 
            obj.markPlaceMultipleTokens([obj.prefix, 'Distance'], obj.distance); 
            build = true; 
            if (obj.turn)
               obj.behaviorPrefix = [obj.prefix,'Turn.'];
               obj.markPlace([obj.prefix,'Turn']);
               if (obj.clockwiseness == 1)
                    obj.markPlace([obj.prefix, 'CounterClockwise']);
               end 
               if (obj.clockwiseness == -1)
                    obj.markPlace([obj.prefix, 'Clockwise']);                
               end
               obj.behavior.includeBehavior = Turn(obj.behaviorPrefix, obj.behavior.animal, obj.clockwiseness, obj.speed, obj.distance, obj.turnBehaviorStatus, build); 
               obj.behavior.acknowledging = true; 
            else     
               obj.behaviorPrefix = [obj.prefix,'Run.']; 
               obj.markPlace([obj.prefix,'Run']);  
               obj.behavior.includeBehavior = Run(obj.behaviorPrefix, obj.behavior.animal, obj.speed, obj.distance, obj.runBehaviorStatus, build);                            
               obj.behavior.acknowledging = true;                    
            end
 
        end
        function cleanup(obj)
           obj.standaloneCleanup(); 
        end
        function done(obj, ~, ~)
            done@BehaviorStatus(obj, 1, 1);             
            obj.behavior.done(); 
        end
    end
end
