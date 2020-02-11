% NavigationStatusSimulatedRandom:  motor cortex state for simulated random
% navigation
classdef NavigationStatusSimulatedRandom < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusSimulatedRandom(motorCortex, updateAll, lastStatus)
            obj = obj@NavigationStatus(motorCortex, updateAll, lastStatus);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.steps = obj.motorCortex.randomSteps();
            if (obj.steps == 0)
                obj.moving = false; 
                navigationStatus = obj.immediateTransition(NavigationStatusFinal(obj.motorCortex, obj.updateAll, obj)); 
            elseif (obj.motorCortex.pendingSimulationOff) 
                obj.moving = false; 
                navigationStatus = ...
                    obj.immediateTransition(NavigationStatusSettle(obj.motorCortex, obj.updateAll, obj));
            else
                obj.moving = true; 
                obj.buildBehavior(obj.steps); 
                obj.motorCortex.updateSimulatedBehaviorHistory(obj.behavior, obj.steps);               
                navigationStatus = NavigationStatusSettle(obj.motorCortex, obj.updateAll, obj); 
                obj.setStatus(navigationStatus);                 
            end 
        end
        function buildBehavior(obj, steps)
            if (isempty(obj.behavior)) % default, else overridden for testing
               obj.behavior = obj.motorCortex.turnOrRun(steps);
            end
        end
    end
end