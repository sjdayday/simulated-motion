% NavigationStatusRandom:  motor cortex state for random physical
% navigation
classdef NavigationStatusPendingSimulationOn < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusPendingSimulationOn(motorCortex, updateAll, lastStatus)
            obj = obj@NavigationStatus(motorCortex, updateAll, lastStatus);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.moving = false; 
            obj.motorCortex.simulationOn();  
            obj.motorCortex.pendingSimulationOn = false; 
            navigationStatus = obj.immediateTransition(NavigationStatusSimulatedRandom(obj.motorCortex, obj.updateAll, obj)); 
%             navigationStatus = NavigationStatusSimulatedRandom(obj.motorCortex, obj.updateAll); 
%             obj.setStatus(navigationStatus, obj); 
        end
    end
end
