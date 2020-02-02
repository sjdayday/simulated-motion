% NavigationStatusSimulatedRandom:  motor cortex state for simulated random
% navigation
classdef NavigationStatusSimulatedRandom < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusSimulatedRandom(motorCortex)
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
                navigationStatus = NavigationStatusRandom(obj.motorCortex); 
                obj.setStatus(navigationStatus, obj);                 
            end
 

        end
    end
end
