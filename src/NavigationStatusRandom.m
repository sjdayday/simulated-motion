% NavigationStatusRandom:  motor cortex state for random physical
% navigation
classdef NavigationStatusRandom < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusRandom(motorCortex)
            obj = obj@NavigationStatus(motorCortex);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.steps = obj.motorCortex.randomSteps();
            if (obj.steps == 0)
                navigationStatus = obj.immediateTransition(NavigationStatusFinal(obj.motorCortex)); 
            elseif (obj.motorCortex.pendingSimulationOn) 
                navigationStatus = obj.immediateTransition(NavigationStatusPendingSimulationOn(obj.motorCortex));                 
            else
                obj.behavior = obj.motorCortex.turnOrRun(obj.steps);
                obj.motorCortex.updateBehaviorHistory(obj.behavior, obj.steps)
                navigationStatus = NavigationStatusRandom(obj.motorCortex); 
                obj.setStatus(navigationStatus, obj); 
            end
        end
    end
end