% NavigationStatusRandom:  motor cortex state for random physical
% navigation
classdef NavigationStatusPendingSimulationOn < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusPendingSimulationOn(motorCortex, updateAll)
            obj = obj@NavigationStatus(motorCortex, updateAll);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.motorCortex.simulationOn();  
            obj.motorCortex.pendingSimulationOn = false; 
            navigationStatus = NavigationStatusSimulatedRandom(obj.motorCortex, obj.updateAll); 
            obj.setStatus(navigationStatus, obj); 
        end
    end
end
