% NavigationStatusSettle:  motor cortex state to settle internal representation 
% back to previous physical place following a simulated turn or run
% this only reverses a Run, and transitions immediately to a next status
classdef NavigationStatusSettle < NavigationStatus 

    properties
        steps
        clockwiseness
    end
    methods 
        function obj = NavigationStatusSettle(motorCortex, updateAll, lastStatus)
            obj = obj@NavigationStatus(motorCortex, updateAll, lastStatus);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.moving = false; 
            if obj.updateAll
                obj.motorCortex.settleBasic(); 
            end
            obj.steps = obj.motorCortex.turnDistance; 
            obj.clockwiseness = obj.motorCortex.clockwiseness * -1; 
            obj.motorCortex.clockwiseness = obj.clockwiseness; 
            if ((obj.steps > 0) && (obj.clockwiseness ~= 0))
                navigationStatus = ... 
                    obj.immediateTransition(NavigationStatusSettleReverseTurn(obj.motorCortex, obj.steps, obj.clockwiseness, obj.updateAll, obj)); 
            elseif obj.motorCortex.pendingSimulationOff 
                navigationStatus = ...
                    obj.immediateTransition(NavigationStatusPendingSimulationOff(obj.motorCortex, obj.updateAll, obj));                 
            else
                navigationStatus = ... 
                    obj.immediateTransition(NavigationStatusSimulatedRandom(obj.motorCortex, obj.updateAll, obj)); 
            end
        end
    end
end