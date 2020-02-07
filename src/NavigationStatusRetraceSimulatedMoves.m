% NavigationStatusRetraceSimulatedMoves:  motor cortex state to retrace the
% first simulated run from simulated behavior history, upon exiting
% simulation mode
classdef NavigationStatusRetraceSimulatedMoves < NavigationStatus 

    properties
        steps
        behavior
        clockwiseness
    end
    methods 
        function obj = NavigationStatusRetraceSimulatedMoves(motorCortex, updateAll, lastStatus)
            obj = obj@NavigationStatus(motorCortex, updateAll, lastStatus);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.moving = false; 
            nextBehavior = obj.motorCortex.popNextSimulatedBehavior(); 
            obj.behavior = nextBehavior(1); 
            obj.steps = nextBehavior(2); 
            obj.clockwiseness = nextBehavior(3); 
            if (obj.behavior == obj.motorCortex.reverseSimulatedTurnBehavior)
                navigationStatus = ...
                    obj.immediateTransition(NavigationStatusRetraceSimulatedMoves(obj.motorCortex, obj.updateAll, obj)); 
            elseif (obj.behavior == obj.motorCortex.turnBehavior)
                obj.motorCortex.turnDistance = obj.steps; 
                obj.motorCortex.runDistance = 0; 
                obj.motorCortex.clockwiseness = obj.clockwiseness; 
                navigationStatus = ...
                    obj.immediateTransition(NavigationStatusRetraceTurn(obj.motorCortex, obj.updateAll, obj)); 
            elseif (obj.behavior == obj.motorCortex.runBehavior)
                obj.motorCortex.turnDistance = 0; 
                obj.motorCortex.runDistance = obj.steps; 
                obj.motorCortex.clockwiseness = 0; 
                navigationStatus = ...
                    obj.immediateTransition(NavigationStatusRetraceRun(obj.motorCortex, obj.updateAll, obj)); 
            elseif (obj.behavior == obj.motorCortex.noBehavior)
                obj.motorCortex.navigateFirstSimulatedRun = false;                  
                navigationStatus = ...
                    obj.immediateTransition(NavigationStatusRandom(obj.motorCortex, obj.updateAll, obj)); 
            end
        end
    end
end