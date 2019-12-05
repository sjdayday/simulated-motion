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
        navigatePrefix
        turnSpeed
        clockwiseNess
        clockwise  % read-only 
        counterClockwise % read-only
        markedPlaceReport
        remainingDistance
        maxBehaviorSteps
        behaviorHistory
        keepRunnerForReporting
        turnBehavior
        runBehavior
        orientBehavior
        placeRecognized
        simulatedMotion
        physicalPlace
        navigation
        firingLimit
        stopOnReadyForTesting
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
            obj.navigatePrefix = 'Navigate.'; 
            obj.clockwise = -1;
            obj.counterClockwise = 1; 
            obj.turnSpeed = 1;
            obj.clockwiseNess = obj.counterClockwise; 
            obj.markedPlaceReport = '';
            obj.remainingDistance = 0; 
            obj.maxBehaviorSteps = 5; 
            obj.behaviorHistory = [];
            obj.turnBehavior = 1; 
            obj.runBehavior = 2;
            obj.orientBehavior = 3; 
            obj.placeRecognized = false; 
            obj.simulatedMotion = false; 
            obj.physicalPlace = []; 
            obj.firingLimit = 10000000;
            obj.stopOnReadyForTesting = false; 
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
        % orient(true) when placed, else orient(false), cause activation
        % already stable
        function orient(obj, stabilize)
           disp('about to orient'); 
           obj.startOrienting(stabilize); 
           obj.finishOrienting(); 
        end
        function startOrienting(obj, stabilize)
           obj.behaviorHistory = [obj.behaviorHistory; [obj.orientBehavior 0 0]]; 
           obj.animal.hippocampalFormation.orienting = true; 
           if stabilize
                obj.animal.stabilizeActivation(); 
           end
        end
        function finishOrienting(obj)
           obj.placeRecognized = obj.animal.hippocampalFormation.placeRecognized;
           if obj.placeRecognized
               obj.turnDistance = obj.cuePhysicalHeadDirectionOffset(); 
               obj.counterClockwiseTurn(); 
               obj.behaviorHistory = [obj.behaviorHistory; [obj.turnBehavior obj.turnDistance obj.clockwiseNess]];                
               if obj.animal.rightWhiskerTouching || obj.animal.leftWhiskerTouching
                  disp('whisker touching while orienting, moving away');  
                  obj.randomNavigation(15); 
                  disp('random navigation done');  
                  obj.orient(false); 
               end
               obj.animal.hippocampalFormation.settle();             
           else
           end
           obj.animal.hippocampalFormation.orienting = false;            
 
        end
        function nextRandomNavigation(obj)
           steps = obj.randomSteps(); 
           if obj.turnAwayFromWhiskersTouching(steps)
               disp('turning away from whiskers touching'); 
               behavior = obj.turnBehavior; 
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
           if (behavior == obj.turnBehavior) 
               obj.turnDistance = steps; 
               direction = randi([0,1]);
               if direction 
                  obj.counterClockwiseTurn(); 
               else
                  obj.clockwiseTurn(); 
               end
           elseif (behavior == obj.runBehavior)
              obj.runDistance = steps;   
              obj.currentPlan = obj.run();
              obj.clockwiseNess = 0; 
           end
        end
        function prepareNavigate(obj)
            obj.movePrefix = 'Navigate.Move.'; % Turn.
            obj.navigation = Navigate(obj.navigatePrefix, obj.animal);
            obj.navigation.firingLimit = obj.firingLimit; 
            obj.navigation.keepRunnerForReporting = obj.keepRunnerForReporting; 
            obj.navigation.build(); 
%             obj.currentPlan = aNavigation;             
        end
        function navigate(obj, steps)
            if (obj.stopOnReadyForTesting) 
                obj.navigation.stopOnReadyForTesting = true; 
            end
          % if end of steps...
%               obj.navigation.finish = true; 
%         end
%             aNavigation = Navigate(obj.navigatePrefix, obj.animal); 
%             aNavigation.keepRunnerForReporting = obj.keepRunnerForReporting; 
%             obj.currentPlan = aNavigation;             
            obj.navigation.execute(); 
            obj.markedPlaceReport = obj.navigation.placeReport;             
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
        function setSimulatedMotion(obj, simulated)
            obj.simulatedMotion = simulated; 
            obj.animal.simulatedMotion = simulated;
            obj.animal.hippocampalFormation.simulatedMotion = simulated; 
            if simulated
               obj.physicalPlace = obj.animal.hippocampalFormation.placeOutput;  
               obj.turnDistance = 0; 
            end
        end
        function settlePhysical(obj)
            obj.animal.hippocampalFormation.placeOutput = obj.physicalPlace;
            obj.animal.hippocampalFormation.updateSubsystemFeatureDetectors(); 
            obj.animal.hippocampalFormation.settleGrids(); 
            obj.reverseSimulatedTurn(); 
        end
        function reverseSimulatedTurn(obj)
            if obj.turnDistance > 0
               obj.clockwiseNess = obj.clockwiseNess * -1; 
               obj.turn(); 
            end            
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
