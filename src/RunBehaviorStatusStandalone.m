%% BehaviorStatus class:  base class for behaviorStatus 
% BehaviorStatus handles the different possible life cycles for a Behavior 
% Standalone behaviors map one to one with a single Petri net, creating and destroying 
%  a single PetrinetRunner
% Include behaviors map to an IncludeHierarchy.  Only the top level
%  creates a PetrinetRunner; lower levels use the existing runner. 
% For included Petri nets that might execute multiple times, listeners may just be 
%  created once, while places that act as input parameters may be marked at each 
%  execution. 
classdef RunBehaviorStatusStandalone < BehaviorStatus 

    properties
         speed
         distance 
    end
    methods
         function obj = RunBehaviorStatusStandalone(prefix, runner)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@BehaviorStatus(prefix, runner);
            obj.defaultPetriNet = 'run-SA.xml';
            obj.acknowledging = true; 
         end
         function setupListeners(obj)
            setupListeners@BehaviorStatus(obj); 
            obj.listenPlaceWithAcknowledgement([obj.prefix, 'Stepped'], @obj.stepped); 
         end
         function markPlaces(obj)
            obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Speed'], obj.speed); 
            obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Distance'], obj.distance); 
         end
        function done(obj, ~, ~)
            done@BehaviorStatus(obj, 1, 1);             
            obj.behavior.done(); 
        end         
        function stepped(obj, ~, ~) 
            obj.behavior.stepped(); 
        end         
        function cleanup(obj)
           obj.standaloneCleanup();  
        end
    end
end
