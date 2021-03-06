% NavigationStatusRandom:  motor cortex state for random physical
% navigation
classdef NavigationStatusRandom < NavigationStatus 

    properties
        steps
        behavior
        turnOffNavigateFirstSimulatedRun
    end
    methods 
        function obj = NavigationStatusRandom(motorCortex, updateAll, lastStatus)
            obj = obj@NavigationStatus(motorCortex, updateAll, lastStatus);
            obj.turnOffNavigateFirstSimulatedRun = false; % default; overridden by NSRetraceRun
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.checkFlagFromPossibleFirstSimulatedRun();  
            obj.steps = obj.motorCortex.randomSteps();
            if (obj.steps == 0)
                obj.moving = false; 
                navigationStatus = obj.immediateTransition(NavigationStatusFinal(obj.motorCortex, obj.updateAll, obj)); 
            elseif (obj.motorCortex.pendingSimulationOn) 
                obj.moving = false; 
                navigationStatus = obj.immediateTransition(NavigationStatusPendingSimulationOn(obj.motorCortex, obj.updateAll, obj));                 
            elseif (obj.turnAwayFromWhiskersTouching())
                obj.moving = false; 
                obj.motorCortex.turnDistance = obj.steps;
                navigationStatus = obj.immediateTransition(NavigationStatusWhiskersTurnAway(obj.motorCortex, obj.updateAll, obj));                                 
            else
                obj.moving = true; 
                obj.behavior = obj.motorCortex.turnOrRun(obj.steps);
                obj.motorCortex.updateBehaviorHistory(obj.behavior, obj.steps)
                navigationStatus = NavigationStatusRandom(obj.motorCortex, obj.updateAll, obj); 
                obj.setStatus(navigationStatus); 
            end
        end
        function checkFlagFromPossibleFirstSimulatedRun(obj)
            % If we got here from NavigationStatusRetraceRun then update
            % the flag to indicate we've finished navigating the first
            % simulated run.  This is for reporting only.  
            if (obj.turnOffNavigateFirstSimulatedRun)
               obj.motorCortex.navigateFirstSimulatedRun = false; 
               obj.motorCortex.successfulRetrace = false; % reset so no false positives  
            end
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
