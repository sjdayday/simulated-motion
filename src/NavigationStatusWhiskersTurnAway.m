% NavigationStatusRandom:  motor cortex state for random physical
% navigation
classdef NavigationStatusWhiskersTurnAway < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusWhiskersTurnAway(motorCortex, updateAll, lastStatus)
            obj = obj@NavigationStatus(motorCortex, updateAll, lastStatus);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.moving = true; 
            obj.steps = obj.motorCortex.turnDistance; 
            obj.behavior = obj.motorCortex.turnBehavior;            
            obj.motorCortex.currentPlan = obj.motorCortex.turn();
            obj.motorCortex.updateBehaviorHistory(obj.behavior, obj.steps)
            navigationStatus = NavigationStatusRandom(obj.motorCortex, obj.updateAll, obj); 
            obj.setStatus(navigationStatus); 
        end
    end
end