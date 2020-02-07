% NavigationStatusPendingSimulationOn:  motor cortex state to transition 
% to simulation
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
        end
    end
end
