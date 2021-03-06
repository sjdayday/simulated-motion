%% BehaviorStatus class:  base class for behaviorStatus 
% BehaviorStatus handles the different possible life cycles for a Behavior 
% Standalone behaviors map one to one with a single Petri net, creating and destroying 
%  a single PetrinetRunner
% Include behaviors map to an IncludeHierarchy.  Only the top level
%  creates a PetrinetRunner; lower levels use the existing runner. 
% For included Petri nets that might execute multiple times, listeners may just be 
%  created once, while places that act as input parameters may be marked at each 
%  execution. 
classdef RunBehaviorStatusInclude < BehaviorStatus 

    properties
         speed
         distance 
         areListenersSetup
    end
    methods
         function obj = RunBehaviorStatusInclude(prefix, runner)
            obj = obj@BehaviorStatus(prefix, runner);
            obj.behaviorPrefix = [obj.prefix,'Run.'];
            obj.prefix = obj.behaviorPrefix; 
            obj.acknowledging = true; 
            obj.areListenersSetup = false; 
         end
         function runner = buildThreadedRunner(obj)
            runner = obj.runner;
         end
         function setupListeners(obj)
             if (~obj.areListenersSetup)
                setupListeners@BehaviorStatus(obj); 
                obj.listenPlaceWithAcknowledgement([obj.behaviorPrefix, 'Stepped'], @obj.stepped); 
                obj.areListenersSetup = true; 
            end
         end
         function execute(~)
           % included behaviors begin execution once, at the standalone level  
         end
         function markPlaces(~)
             % marked by Move
         end
        function done(obj, ~, ~)
            done@BehaviorStatus(obj, 1, 1);             
            obj.behavior.done(); 
        end 
        function cleanup(~)
            disp('RunBehaviorStatusInclude: no op cleanup'); 
%            obj.standaloneCleanup(); % cleanup done higher up  
        end
        function stepped(obj, ~, ~) 
            obj.behavior.stepped(); 
        end         
    end
end
