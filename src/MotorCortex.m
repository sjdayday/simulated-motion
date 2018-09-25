%% MotorCortex class:  executes motor plans by running various Behaviors, implemented as PetriNets
classdef MotorCortex < System 

    properties
        animal
        distanceUnits
        nHeadDirectionCells
        nFeatures
        rewardUnits
        reward
        nOutput
        featureOutput
        moveDistance
        currentPlan
        turnPrefix
        turnSpeed
        clockwiseNess
        clockwise  % read-only 
        counterClockwise % read-only
        
    end
    methods
        function obj = MotorCortex(animal)
            obj = obj@System(); 
            obj.distanceUnits = 8;
            obj.nHeadDirectionCells = 60;
            obj.nFeatures = 3; 
            obj.rewardUnits = 5; 
            obj.build();
            obj.moveDistance = 0; 
            obj.animal = animal; 
            obj.turnPrefix = 'Move.Turn.'; 
            obj.clockwise = -1;
            obj.counterClockwise = 1; 
            obj.turnSpeed = 1;
            obj.clockwiseNess = obj.counterClockwise; 
        end
        function build(obj)
            featureLength = obj.distanceUnits + obj.nHeadDirectionCells; 
            obj.featureOutput = zeros(1, obj.nFeatures * featureLength); 
            obj.reward = zeros(1,obj.rewardUnits);  
            obj.nOutput = length(obj.featureOutput) + obj.rewardUnits; 

        end
        function counterClockwiseTurn(obj)
            obj.clockwiseNess = obj.counterClockwise; 
            obj.currentPlan = obj.turn(); 
        end
        function clockwiseTurn(obj)
            obj.clockwiseNess = obj.clockwise; 
            obj.currentPlan = obj.turn(); 
        end
        function aTurn = turn(obj)
            aTurn = Turn(obj.turnPrefix, obj.animal, obj.clockwiseNess, obj.turnSpeed, obj.moveDistance); 
        end
        %% Single time step 
        function  step(obj)
            step@System(obj); 
        end
        function plot(obj)
        end  
    end
end
