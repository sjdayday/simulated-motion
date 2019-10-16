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
        remainingDistance
        maxBehaviorSteps
        behaviorHistory
        keepRunnerForReporting
    end
    methods
        function obj = MotorCortex(animal)
            obj = obj@System(); 
            obj.distanceUnits = 8;
            obj.nHeadDirectionCells = 60;
            obj.nFeatures = 3; 
            obj.rewardUnits = 5; 
            obj.keepRunnerForReporting = false; 
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
            obj.remainingDistance = 0; 
            obj.maxBehaviorSteps = 5; 
            obj.behaviorHistory = [];
            
        end
        function build(obj)
            featureLength = obj.distanceUnits + obj.nHeadDirectionCells; 
            obj.featureOutput = zeros(1, obj.nFeatures * featureLength); 
            obj.reward = zeros(1,obj.rewardUnits);  
            obj.nOutput = length(obj.featureOutput) + obj.rewardUnits; 
        end
        function randomNavigation(obj, steps)
            obj.behaviorHistory = [];
            obj.remainingDistance = steps; 
            while (obj.remainingDistance > 0)
                obj.nextRandomNavigation(); 
            end
        end
        function nextRandomNavigation(obj)
           steps = obj.randomSteps(); 
           if obj.turnAwayFromWhiskersTouching(steps)
               disp('turning away from whiskers touching'); 
               behavior = 1; 
           else
               behavior = obj.turnOrRun(steps); 
           end
           obj.behaviorHistory = [obj.behaviorHistory; [behavior steps obj.clockwiseNess]];                
        end
      function turnAway = turnAwayFromWhiskersTouching(obj, steps)
            obj.turnDistance = steps; 
            turnAway = true; 
            if (obj.animal.rightWhiskerTouching) 
               obj.counterClockwiseTurn();
            elseif (obj.animal.leftWhiskerTouching) 
               obj.clockwiseTurn();
            else
               turnAway = false; 
            end                 
        end
        function behavior = turnOrRun(obj, steps)
           behavior = randi(2); 
           if (behavior == 1) 
               obj.turnDistance = steps; 
               direction = randi([0,1]);
               if direction 
                  obj.counterClockwiseTurn(); 
               else
                  obj.clockwiseTurn(); 
               end
           elseif (behavior == 2)
              obj.runDistance = steps;   
              obj.currentPlan = obj.run();
              obj.clockwiseNess = 0; 
           end
        end
        function steps = randomSteps(obj)
           if (obj.remainingDistance < obj.maxBehaviorSteps)
                limit = obj.remainingDistance; 
           else  
                limit = obj.maxBehaviorSteps; 
           end
           if (limit > 0)
               steps = randi(limit); 
               obj.remainingDistance = obj.remainingDistance - steps;                    
           else 
               steps = 0; 
           end
           
        end
        function counterClockwiseTurn(obj)
            obj.clockwiseNess = obj.counterClockwise; 
            obj.turn(); 
        end
        function clockwiseTurn(obj)
            obj.clockwiseNess = obj.clockwise; 
            obj.turn(); 
        end
        function aTurn = turn(obj)
            aTurn = Turn(obj.movePrefix, obj.animal, obj.clockwiseNess, obj.turnSpeed, obj.turnDistance); 
            aTurn.keepRunnerForReporting = obj.keepRunnerForReporting; 
            obj.currentPlan = aTurn;             
            aTurn.execute(); 
            obj.markedPlaceReport = aTurn.placeReport; 
        end
        function aRun = run(obj)
            aRun = Run(obj.movePrefix, obj.animal, obj.runSpeed, obj.runDistance); 
            aRun.keepRunnerForReporting = obj.keepRunnerForReporting;             
            obj.currentPlan = aRun; 
            aRun.execute(); 
            obj.markedPlaceReport = aRun.placeReport; 
        end
        function offset = cuePhysicalHeadDirectionOffset(obj)
            environment = obj.animal.environment; 
            currentDirection = obj.animal.currentDirection; 
            % environment direction alternates between animal direction and
            % head direction, so use animal's direction
            environment.setDirection(currentDirection); 
            offset = environment.cueHeadDirectionOffset(1); % 1 is primary cue
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
