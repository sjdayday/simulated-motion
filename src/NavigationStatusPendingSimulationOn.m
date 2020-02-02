% NavigationStatusRandom:  motor cortex state for random physical
% navigation
classdef NavigationStatusPendingSimulationOn < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusPendingSimulationOn(motorCortex)
            obj = obj@NavigationStatus(motorCortex);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.motorCortex.simulationOn();  
            obj.motorCortex.pendingSimulationOn = false; 
            navigationStatus = NavigationStatusSimulatedRandom(obj.motorCortex); 
            obj.setStatus(navigationStatus, obj); 
        end
    end
end
