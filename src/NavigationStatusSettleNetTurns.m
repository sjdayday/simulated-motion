% NavigationStatusSettleNetTurns:  motor cortex state to calculate the 
% net distance and clockwiseness of all previously simulated turns, 
% as part of settling simulated position to previous physical position
classdef NavigationStatusSettleNetTurns < NavigationStatus 

    properties
        steps
        behavior
        clockwiseness
    end
    methods 
        function obj = NavigationStatusSettleNetTurns(motorCortex, updateAll, lastStatus)
            obj = obj@NavigationStatus(motorCortex, updateAll, lastStatus);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            turnNeeded = obj.motorCortex.calculateNetSimulatedTurnsReversed();
            obj.steps = obj.motorCortex.turnDistance; 
            obj.clockwiseness = obj.motorCortex.clockwiseness; 
            if (turnNeeded)
                obj.behavior = obj.motorCortex.reverseSimulatedTurnBehavior;                
                obj.moving = true; 
                obj.motorCortex.turn(); 
                obj.motorCortex.updateSimulatedBehaviorHistory(obj.motorCortex.reverseSimulatedTurnBehavior, obj.steps);               
                navigationStatus = NavigationStatusPendingSimulationOff(obj.motorCortex, obj.updateAll, obj); 
                obj.setStatus(navigationStatus);                 
            else
                obj.behavior = obj.motorCortex.noBehavior;                                
                obj.moving = false; 
                navigationStatus = ...
                    obj.immediateTransition(NavigationStatusPendingSimulationOff(obj.motorCortex, obj.updateAll, obj));                 
            end
        end
    end
end