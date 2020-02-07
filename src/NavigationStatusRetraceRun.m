% NavigationStatusRetraceRun:  motor cortex state to retrace a single run.  
% Parameters set by NavigationStatusRetraceSimulatedMoves
classdef NavigationStatusRetraceRun < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusRetraceRun(motorCortex, updateAll, lastStatus)
            obj = obj@NavigationStatus(motorCortex, updateAll, lastStatus);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.moving = true; 
            obj.steps = obj.motorCortex.runDistance; 
            if (obj.turnAwayFromWhiskersTouching())
                obj.moving = false; 
                obj.motorCortex.turnDistance = obj.steps; % use steps set by retrace simulated moves
                obj.motorCortex.runDistance = 0; 
                obj.behavior = obj.motorCortex.turnBehavior;                            
                navigationStatus = obj.immediateTransition(NavigationStatusWhiskersTurnAway(obj.motorCortex, obj.updateAll, obj));                                 
            else        
                obj.behavior = obj.motorCortex.runBehavior;            
                obj.motorCortex.currentPlan = obj.motorCortex.run();
                obj.motorCortex.updateBehaviorHistory(obj.behavior, obj.steps)
                navigationStatus = NavigationStatusRandom(obj.motorCortex, obj.updateAll, obj); 
                obj.setStatus(navigationStatus); 
            end
            obj.motorCortex.navigateFirstSimulatedRun = false;            
        end
        function turnAway = turnAwayFromWhiskersTouching(obj)
            turnAway = true; 
            if (obj.motorCortex.animal.rightWhiskerTouching) 
               obj.motorCortex.clockwiseness = obj.motorCortex.counterClockwise; 
            elseif (obj.motorCortex.animal.leftWhiskerTouching) 
               obj.motorCortex.clockwiseness = obj.motorCortex.clockwise; 
            else
               turnAway = false; 
            end                             
        end
        
    end
end