% NavigationStatusSettleReverseTurn:  motor cortex state to reverse a
% previously simulated turn, as part of settling simulated position 
% to previous physical position
classdef NavigationStatusSettleReverseTurn < NavigationStatus 

    properties
        steps
        behavior
        clockwiseness
    end
    methods 
        function obj = NavigationStatusSettleReverseTurn(motorCortex, steps, clockwiseness, updateAll, lastStatus)
            obj = obj@NavigationStatus(motorCortex, updateAll, lastStatus);
            obj.steps = steps;
            obj.clockwiseness = clockwiseness; 
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.moving = true; 
            obj.behavior = obj.motorCortex.reverseSimulatedTurnBehavior; 
            obj.motorCortex.turn(); 
            obj.motorCortex.updateSimulatedBehaviorHistory(obj.motorCortex.reverseSimulatedTurnBehavior, obj.steps);               
            if obj.motorCortex.pendingSimulationOff
                navigationStatus = NavigationStatusPendingSimulationOff(obj.motorCortex, obj.updateAll, obj); 
                obj.setStatus(navigationStatus);                 
            else
                navigationStatus = NavigationStatusSimulatedRandom(obj.motorCortex, obj.updateAll, obj); 
                obj.setStatus(navigationStatus); 
            end
        end
    end
end