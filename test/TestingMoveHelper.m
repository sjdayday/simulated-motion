%% TestingBehavior class:  class for unit testing Behavior
classdef TestingMoveHelper < MoveHelper 

    properties
    end
    methods
         function obj = TestingMoveHelper(motorCortex)
            obj = obj@MoveHelper(motorCortex);
         end
         function doMove(obj, aMove)
            obj.motorCortex.currentPlan = aMove;             
            obj.motorCortex.navigationStatus.nextStatus();  
         end
    end

end
