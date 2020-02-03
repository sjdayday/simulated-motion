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
        function obj = NavigationStatusSettleReverseTurn(motorCortex, steps, clockwiseness, updateAll)
            obj = obj@NavigationStatus(motorCortex, updateAll);
            obj.steps = steps;
            obj.clockwiseness = clockwiseness; 
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
%             obj.steps = obj.motorCortex.randomSteps();
            obj.behavior = obj.motorCortex.reverseSimulatedTurnBehavior; 
            obj.motorCortex.turn(); 
            obj.motorCortex.updateSimulatedBehaviorHistory(obj.motorCortex.reverseSimulatedTurnBehavior, obj.steps);               
            if obj.motorCortex.pendingSimulationOff
                navigationStatus = ...
                   obj.immediateTransition(NavigationStatusPendingSimulationOff(obj.motorCortex, obj.updateAll));                                 
            else
                navigationStatus = NavigationStatusSimulatedRandom(obj.motorCortex, obj.updateAll); 
                obj.setStatus(navigationStatus, obj); 
            end
        end
    end
end

%                obj.clockwiseness = obj.clockwiseness * -1; 
%                obj.turn(); 
%                obj.simulatedBehaviorHistory = [obj.simulatedBehaviorHistory; [obj.reverseSimulatedTurnBehavior obj.turnDistance obj.clockwiseness]];
