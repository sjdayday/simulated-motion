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
%             obj.steps = obj.motorCortex.randomSteps();
            obj.behavior = obj.motorCortex.reverseSimulatedTurnBehavior; 
            obj.motorCortex.turn(); 
            obj.motorCortex.updateSimulatedBehaviorHistory(obj.motorCortex.reverseSimulatedTurnBehavior, obj.steps);               
            if obj.motorCortex.pendingSimulationOff
                % FIXME already moving, should tell pending simulation off
                % to do its own immediate transition?
                navigationStatus = ...
                   obj.immediateTransition(NavigationStatusPendingSimulationOff(obj.motorCortex, obj.updateAll, obj));                                 
            else
                navigationStatus = NavigationStatusSimulatedRandom(obj.motorCortex, obj.updateAll, obj); 
                obj.setStatus(navigationStatus); 
            end
        end
    end
end

%                obj.clockwiseness = obj.clockwiseness * -1; 
%                obj.turn(); 
%                obj.simulatedBehaviorHistory = [obj.simulatedBehaviorHistory; [obj.reverseSimulatedTurnBehavior obj.turnDistance obj.clockwiseness]];
