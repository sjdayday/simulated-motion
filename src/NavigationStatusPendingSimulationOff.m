% NavigationStatusRandom:  motor cortex state for random physical
% navigation
classdef NavigationStatusPendingSimulationOff < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusPendingSimulationOff(motorCortex, updateAll, lastStatus)
            obj = obj@NavigationStatus(motorCortex, updateAll, lastStatus);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.moving = false; 
            obj.motorCortex.simulationOff();  
            obj.motorCortex.pendingSimulationOff = false;  
            navigationStatus = ...
                obj.immediateTransition(NavigationStatusRetraceSimulatedMoves(obj.motorCortex, obj.updateAll, obj));                 
        end
    end
end
