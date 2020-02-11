% NavigationStatusSettle:  motor cortex state to settle internal representation 
% back to previous physical place following a simulated turn or run
% this only reverses a Run, and transitions immediately to a next status
% when about to exit simulation, transitions to settle the net turns 
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
            if obj.motorCortex.pendingSimulationOff 
                navigationStatus = ...
                    obj.immediateTransition(NavigationStatusSettleNetTurns(obj.motorCortex, obj.updateAll, obj));                 
            else
                navigationStatus = ... 
                    obj.immediateTransition(NavigationStatusSimulatedRandom(obj.motorCortex, obj.updateAll, obj)); 
            end
        end
    end
end