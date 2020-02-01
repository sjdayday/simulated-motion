%% BehaviorHelper class:  builds and runs behaviors
% Encapsulates the creation and running of behaviors in MotorCortex, so that  
% testing is simplified.  See TestingBehaviorHelper 
classdef MoveHelper < handle 

    properties
        motorCortex
        
    end
    methods
         function obj = MoveHelper(motorCortex)
            obj.motorCortex = motorCortex; 

         end
         function aMove = move(obj, behavior, distance, speed, clockwiseness)
             build = false; 
%             aMove = behavior; 
             if (behavior == obj.motorCortex.turnBehavior)
                turn = true;  
             else
                turn = false;  
             end
             aMove = Move(obj.motorCortex.movePrefix, obj.motorCortex.animal, ... 
               speed, distance, clockwiseness, turn, obj.motorCortex.getMoveBehaviorStatus(), build);  
             obj.doMove(aMove); 
         end
         function doMove(obj, aMove)
             obj.motorCortex.doMove(aMove);  
         end
    end
end
