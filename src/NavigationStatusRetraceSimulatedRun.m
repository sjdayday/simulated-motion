% NavigationStatusRetraceSimulatedRun:  motor cortex state to retrace the
% first simulated run from simulated behavior history, upon exiting
% simulation mode
classdef NavigationStatusRetraceSimulatedRun < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusRetraceSimulatedRun(motorCortex, updateAll)
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