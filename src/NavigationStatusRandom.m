% NavigationStatusRandom:  motor cortex state for random physical
% navigation
classdef NavigationStatusRandom < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusRandom(motorCortex, updateAll)
            obj = obj@NavigationStatus(motorCortex, updateAll);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.steps = obj.motorCortex.randomSteps();
            if (obj.steps == 0)
                navigationStatus = obj.immediateTransition(NavigationStatusFinal(obj.motorCortex, obj.updateAll)); 
            elseif (obj.motorCortex.pendingSimulationOn) 
                navigationStatus = obj.immediateTransition(NavigationStatusPendingSimulationOn(obj.motorCortex, obj.updateAll));                 
            else
                obj.behavior = obj.motorCortex.turnOrRun(obj.steps);
                obj.motorCortex.updateBehaviorHistory(obj.behavior, obj.steps)
                navigationStatus = NavigationStatusRandom(obj.motorCortex, obj.updateAll); 
                obj.setStatus(navigationStatus, obj); 
            end
        end
    end
end