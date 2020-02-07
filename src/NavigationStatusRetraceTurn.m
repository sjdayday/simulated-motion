% NavigationStatusRetraceTurn:  motor cortex state to retrace a single
% turn.  Parameters set by NavigationStatusRetraceSimulatedMoves
classdef NavigationStatusRetraceTurn < NavigationStatus 

    properties
        steps 
        behavior
    end
    methods 
        function obj = NavigationStatusRetraceTurn(motorCortex, updateAll, lastStatus)
            obj = obj@NavigationStatus(motorCortex, updateAll, lastStatus);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.moving = true; 
            obj.steps = obj.motorCortex.turnDistance; 
            obj.behavior = obj.motorCortex.turnBehavior;            
            obj.motorCortex.currentPlan = obj.motorCortex.turn();
            obj.motorCortex.updateBehaviorHistory(obj.behavior, obj.steps)
            navigationStatus = NavigationStatusRetraceSimulatedMoves(obj.motorCortex, obj.updateAll, obj); 
            obj.setStatus(navigationStatus); 
        end
    end
end