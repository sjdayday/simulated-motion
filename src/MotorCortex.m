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
        turnDistance
        runDistance
        runSpeed
        currentPlan
        movePrefix
        turnSpeed
        clockwiseNess
        clockwise  % read-only 
        counterClockwise % read-only
        markedPlaceReport
        
    end
    methods
        function obj = MotorCortex(animal)
            obj = obj@System(); 
            obj.distanceUnits = 8;
            obj.nHeadDirectionCells = 60;
            obj.nFeatures = 3; 
            obj.rewardUnits = 5; 
            obj.build();
            obj.turnDistance = 0; 
            obj.runDistance = 0; 
            obj.runSpeed = 1; 
            obj.animal = animal; 
            obj.movePrefix = 'Move.'; % Turn.
            obj.clockwise = -1;
            obj.counterClockwise = 1; 
            obj.turnSpeed = 1;
            obj.clockwiseNess = obj.counterClockwise; 
            obj.markedPlaceReport = '';
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
            aTurn = Turn(obj.movePrefix, obj.animal, obj.clockwiseNess, obj.turnSpeed, obj.turnDistance); 
            obj.markedPlaceReport = aTurn.placeReport; 
        end
        function aRun = run(obj)
            aRun = Run(obj.movePrefix, obj.animal, obj.runSpeed, obj.runDistance); 
            obj.markedPlaceReport = aRun.placeReport; 
        end
        
        %% Single time step 
        function  step(obj)
            step@System(obj); 
            obj.animal.step(); 
        end
        function plot(obj)
        end  
    end
end
