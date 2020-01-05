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
        clockwiseness
        clockwise  % read-only 
        counterClockwise % read-only
        markedPlaceReport
        remainingDistance
        maxBehaviorSteps
        behaviorHistory
        simulatedBehaviorHistory
        keepRunnerForReporting
        readyAcknowledgeBuildsPlaceReport
        turnBehavior
        runBehavior
        orientBehavior
        placeRecognized
        simulatedMotion
        physicalPlace
        navigation
        firingLimit
        stopOnReadyForTesting
        runner
        standaloneMoves
        listenAndMark
        moveBehaviorStatus
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
            obj.clockwiseness = obj.counterClockwise; % default to start 
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
            obj.runner = []; 
            obj.movePrefix = 'Move.';
            obj.standaloneMoves = true; 
            obj.listenAndMark = true; 
            obj.readyAcknowledgeBuildsPlaceReport = false; 
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
               obj.behaviorHistory = [obj.behaviorHistory; [obj.turnBehavior obj.turnDistance obj.clockwiseness]];                
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
           if (steps == 0)
              obj.navigation.behaviorStatus.finish = true;
              obj.navigation.behaviorStatus.waitForInput(false); 
              obj.navigation.behaviorStatus.isDone = true;
           else 
               if obj.turnAwayFromWhiskersTouching(steps)
                   disp('turning away from whiskers touching'); 
                   behavior = obj.turnBehavior; 
               else
                   behavior = obj.turnOrRun(steps); 
               end
               if (obj.simulatedMotion)
                   obj.simulatedBehaviorHistory = [obj.simulatedBehaviorHistory; [behavior steps obj.clockwiseness]];                
                   obj.settlePhysical(); 
               else
                   obj.behaviorHistory = [obj.behaviorHistory; [behavior steps obj.clockwiseness]];                
               end
               
           end
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
               obj.runDistance = 0; 
               direction = randi([0,1]);
               if direction 
                  obj.counterClockwiseTurn(); 
               else
                  obj.clockwiseTurn(); 
               end
           elseif (behavior == obj.runBehavior)
              obj.runDistance = steps;  
              obj.turnDistance = 0; 
              obj.currentPlan = obj.run();
              obj.clockwiseness = 0; 
           end
        end
        function prepareNavigate(obj)
            build = false; 
            obj.standaloneMoves = false; 
            obj.movePrefix = 'Navigate.Move.'; % Turn.
            behaviorStatus = []; 
            obj.navigation = Navigate(obj.navigatePrefix, obj.animal, behaviorStatus, build);
            obj.navigation.behaviorStatus.firingLimit = obj.firingLimit; 
            obj.navigation.behaviorStatus.keepRunnerForReporting = obj.keepRunnerForReporting; 
            obj.navigation.behaviorStatus.readyAcknowledgeBuildsPlaceReport = obj.readyAcknowledgeBuildsPlaceReport; 
            obj.navigation.build(); 
            obj.runner = obj.navigation.runner; 
            obj.moveBehaviorStatus = obj.navigation.behaviorStatus.moveBehaviorStatus; 
%             obj.setupListeners(); % <<< 
%             obj.currentPlan = aNavigation;             
        end
        function setupListeners(obj) % <<<
           obj.listenAndMark = false;  
           aMove = obj.turn(); 
           aMove.acknowledging = true;            
           aMove.listenPlaces(); 

%            aMove.markPlaces(obj.listenAndMark);
           aMove.behavior.listenLocalPlaces();
%            aMove.behavior.markPlaces();
           aMove = obj.run(); 
           aMove.behavior.listenLocalPlaces(); 
           obj.listenAndMark = true; 
        end
        function navigate(obj, steps)
            if (obj.stopOnReadyForTesting) 
                obj.navigation.stopOnReadyForTesting = true; 
            end
            obj.behaviorHistory = [];
            obj.remainingDistance = steps; 
%             while (obj.remainingDistance > 0)
                obj.nextRandomNavigation(); 
%             end
         

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
            obj.clockwiseness = obj.counterClockwise; 
            obj.turn(); 
        end
        function clockwiseTurn(obj)
            obj.clockwiseness = obj.clockwise; 
            obj.turn(); 
        end
        function moveBehaviorStatus = getMoveBehaviorStatus(obj)
            if (obj.standaloneMoves) 
                moveBehaviorStatus = []; 
            else
                moveBehaviorStatus = obj.moveBehaviorStatus; 
            end                        
 
        end
        function aMove = turn(obj)
            disp(['clockwiseness: ', num2str(obj.clockwiseness)]);  
%             aTurn = Turn(obj.movePrefix, obj.animal, obj.clockwiseness, obj.turnSpeed, obj.turnDistance); 
            turn = true;
            build = false; 
%             runner = []; 
%             behaviorStatus = []; 
            aMove = Move(obj.movePrefix, obj.animal, obj.turnSpeed, obj.turnDistance, obj.clockwiseness, turn, obj.getMoveBehaviorStatus(), build); % obj.runner obj.listenAndMark
%             if (obj.standaloneMoves) 
                obj.doMove(aMove); 
%             end            
        end
        function aMove = run(obj)
            obj.clockwiseness = 0; 
            turn = false;
            build = false;
%             behaviorStatus = [];
            aMove = Move(obj.movePrefix, obj.animal, obj.runSpeed, obj.runDistance, obj.clockwiseness, turn, obj.getMoveBehaviorStatus(), build); 
%             if (obj.standaloneMoves) 
                obj.doMove(aMove); 
%             end                        
        end
        function doMove(obj, aMove)
            aMove.keepRunnerForReporting = obj.keepRunnerForReporting;
            aMove.behaviorStatus.keepRunnerForReporting = obj.keepRunnerForReporting;
%             aMove.readyAcknowledgeBuildsPlaceReport = obj.readyAcknowledgeBuildsPlaceReport; 
            aMove.behaviorStatus.readyAcknowledgeBuildsPlaceReport = obj.readyAcknowledgeBuildsPlaceReport; 
            obj.currentPlan = aMove;             
            aMove.build(); 
            aMove.execute(); 
            obj.markedPlaceReport = aMove.behaviorStatus.placeReport;             
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
            disp('setSimulatedMotion'); 
            disp(simulated); 
            obj.simulatedMotion = simulated; 
            obj.animal.simulatedMotion = simulated;
            obj.animal.hippocampalFormation.simulatedMotion = simulated; 
            if simulated
               obj.physicalPlace = obj.animal.hippocampalFormation.placeOutput;  
               obj.turnDistance = 0; % needed for reverseSimulatedTurn; run reversal is automatic
               obj.simulatedBehaviorHistory = [];
            end
        end
        function settlePhysical(obj)
            obj.animal.hippocampalFormation.placeOutput = obj.physicalPlace;
            obj.animal.hippocampalFormation.updateSubsystemFeatureDetectors(); 
            obj.animal.hippocampalFormation.settleGrids(); 
            obj.reverseSimulatedTurn(); 
        end
        function reverseSimulatedTurn(obj)
            disp(['reverse simulated turn; turnDistance: ',num2str(obj.turnDistance)]);  
            if obj.turnDistance > 0
               obj.clockwiseness = obj.clockwiseness * -1; 
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
