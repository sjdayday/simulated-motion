%% BehaviorStatus class:  base class for behaviorStatus 
% BehaviorStatus handles the different possible life cycles for a Behavior 
% Standalone behaviors map one to one with a single Petri net, creating and destroying 
%  a single PetrinetRunner
% Include behaviors map to an IncludeHierarchy.  Only the top level
%  creates a PetrinetRunner; lower levels use the existing runner. 
% For included Petri nets that might execute multiple times, listeners may just be 
%  created once, while places that act as input parameters may be marked at each 
%  execution. 
classdef TurnBehaviorStatusStandalone < BehaviorStatus 

    properties
         clockwiseness
         speed
         distance 
    end
    methods
         function obj = TurnBehaviorStatusStandalone(prefix, runner)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@BehaviorStatus(prefix, runner);
            obj.defaultPetriNet = 'turn-SA.xml';
            obj.acknowledging = true; 
         end
         function setupListeners(obj)
            setupListeners@BehaviorStatus(obj); 
            obj.listenPlaceWithAcknowledgement([obj.prefix, 'Turned'], @obj.turned); 
         end
         function markPlaces(obj)
            if (obj.clockwiseness == 1)
                obj.markPlace([obj.behaviorPrefix, 'CounterClockwise']);
            end 
            if (obj.clockwiseness == -1)
                obj.markPlace([obj.behaviorPrefix, 'Clockwise']);                
            end
            obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Speed'], obj.speed); 
            obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Distance'], obj.distance); 
         end
        function done(obj, ~, ~)
            done@BehaviorStatus(obj, 1, 1);             
            obj.behavior.done(); 
        end         
        function turned(obj, ~, ~) 
            obj.behavior.turned(); 
        end         
        function cleanup(obj)
           obj.standaloneCleanup();  
        end
    end
end
