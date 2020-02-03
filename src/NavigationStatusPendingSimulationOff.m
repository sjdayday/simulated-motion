% NavigationStatusRandom:  motor cortex state for random physical
% navigation
classdef NavigationStatusPendingSimulationOff < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusPendingSimulationOff(motorCortex, updateAll)
            obj = obj@NavigationStatus(motorCortex, updateAll);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.motorCortex.simulationOff();  
            obj.motorCortex.pendingSimulationOff = false; 
            navigationStatus = NavigationStatusRetraceSimulatedRun(obj.motorCortex, obj.updateAll); 
            obj.setStatus(navigationStatus, obj); 
        end
    end
end
