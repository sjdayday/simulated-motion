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
        noBehavior
        reverseSimulatedTurnBehavior
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
        navigateFirstSimulatedRun
        simulationSettleRequired
        pendingSimulationOn
        pendingSimulationOff
        debugSteps
        currentBehavior
        simulatedRunPlaces
        successfulRetrace
        moveHelper
        navigationStatus
        ripples
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
            obj.reverseSimulatedTurnBehavior = 11; 
            obj.noBehavior= -1;
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
            obj.navigateFirstSimulatedRun = false; 
            obj.simulationSettleRequired = false;
            obj.pendingSimulationOn = false;
            obj.pendingSimulationOff = false; 
            obj.debugSteps = 0; 
            obj.currentBehavior = 0;
            obj.simulatedRunPlaces = {}; 
            obj.successfulRetrace = false; 
            obj.ripples = 4; % default
            obj.moveHelper = MoveHelper(obj);
            lastStatus = []; 
            updateAll = true; 
            obj.navigationStatus = NavigationStatusRandom(obj, updateAll, lastStatus); 
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
                obj.navigationStatus.nextStatus();
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
        function updateBehaviorHistory(obj, behavior, steps)
           obj.behaviorHistory = [obj.behaviorHistory; [behavior steps obj.clockwiseness]];                
        end
        function updateSimulatedBehaviorHistory(obj, behavior, steps)
           obj.simulatedBehaviorHistory = [obj.simulatedBehaviorHistory; [behavior steps obj.clockwiseness]];                
        end
        function exitNavigation(obj)
           disp('no remaining steps...exiting');  
           obj.navigation.behaviorStatus.finish = true;
           obj.navigation.behaviorStatus.waitForInput(false); 
           obj.navigation.behaviorStatus.isDone = true;
        end
        function simulationOn(obj)
            obj.simulatedMotion = true; 
            obj.animal.simulatedMotion = true;
            obj.animal.hippocampalFormation.simulatedMotion = true; 

            obj.physicalPlace = obj.animal.hippocampalFormation.placeOutput;  
            obj.turnDistance = 0; % needed for reverseSimulatedTurn; run reversal is automatic
            obj.simulatedBehaviorHistory = [];
            obj.simulatedRunPlaces = {};  
        end
        function addPlaceToSimulatedRunPlaces(obj, placeIndices)
           index = length(obj.simulatedRunPlaces) + 1; 
           obj.simulatedRunPlaces{index} = placeIndices; 
        end
        function evaluateSuccessfulRetrace(obj, placeIndices) 
           obj.successfulRetrace = false;
           numberPlaces = length(obj.simulatedRunPlaces); 
           if (numberPlaces > 0)
               obj.evaluateRetraceForCurrentPlace(placeIndices); 
               if (numberPlaces == 1)
                   obj.simulatedRunPlaces = {};  
               else
                   obj.simulatedRunPlaces = obj.simulatedRunPlaces(2:end);    
               end
           end 
        end
        function evaluateRetraceForCurrentPlace(obj, placeIndices) 
            simulatedIndices = obj.simulatedRunPlaces{1}; 
            anyMatches = ismember(simulatedIndices, placeIndices); % vector of logicals
            obj.successfulRetrace = all(anyMatches);
        end
        function simulationOff(obj)
            obj.simulatedMotion = false; 
            obj.animal.simulatedMotion = false;
            obj.animal.hippocampalFormation.simulatedMotion = false; 
            
            obj.navigateFirstSimulatedRun = true;  
            obj.successfulRetrace = false; 
        end        
        function turnAway = turnAwayFromWhiskersTouching(obj, steps)
            turnAway = true; 
            if (obj.animal.rightWhiskerTouching) 
               obj.turnDistance = steps;  
               obj.counterClockwiseTurn();
            elseif (obj.animal.leftWhiskerTouching) 
               obj.turnDistance = steps;  
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
        function nextBehavior = retraceFirstSimulatedRun(obj, steps)
           disp('retraceFirstSimulatedRun'); 
           nextBehavior = obj.popNextSimulatedBehavior(); 
           if (nextBehavior(1) == obj.reverseSimulatedTurnBehavior)
              nextBehavior = obj.retraceFirstSimulatedRun(steps); 
           end
           if (obj.navigateFirstSimulatedRun)  
               disp('navigateFirstSimulatedRun'); 
               if (nextBehavior(1) == obj.turnBehavior)
                  obj.turnDistance = nextBehavior(2); 
                  obj.runDistance = 0; 
                  obj.clockwiseness = nextBehavior(3); 
                  obj.currentPlan = obj.turn();
               end
               if (nextBehavior(1) == obj.runBehavior)
%                   obj.navigateFirstSimulatedRun = false;  
                  obj.turnDistance = 0; 
                  obj.runDistance = nextBehavior(2); 
                  obj.clockwiseness = 0; 
                  obj.currentPlan = obj.run();
                  disp('after navigating first simulated run, before turning flag off'); 
                  obj.navigateFirstSimulatedRun = false; % for reporting, don't turn off til run is done
               end 
               if (nextBehavior(1) == obj.noBehavior)
                  obj.navigateFirstSimulatedRun = false;  
                  nextBehavior = obj.turnOrRun(steps);                
               end            
           end
        end
        function behavior = popNextSimulatedBehavior(obj)
           rows = size(obj.simulatedBehaviorHistory, 1); 
           if (rows == 0)
               behavior = [obj.noBehavior, 0, 0];
           else
               behavior = obj.simulatedBehaviorHistory(1,:);    
               if (rows == 1)
                  obj.simulatedBehaviorHistory = []; 
               else
                  obj.simulatedBehaviorHistory = obj.simulatedBehaviorHistory(2:end,:); 
               end
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
            obj.navigation.behaviorStatus.ripples = obj.ripples; 
            obj.navigation.build(); 
            obj.runner = obj.navigation.runner; 
%             obj.runner.setFiringDelay(10); 
            obj.moveBehaviorStatus = obj.navigation.behaviorStatus.moveBehaviorStatus; 
%             obj.setupListeners(); % <<< 
%             obj.currentPlan = aNavigation;             
        end
        function navigate(obj, steps)
            if (obj.stopOnReadyForTesting) 
                obj.navigation.stopOnReadyForTesting = true; 
            end
            obj.behaviorHistory = [];
            obj.remainingDistance = steps; 

            obj.navigationStatus.nextStatus();  
%                 obj.nextRandomNavigation(); 
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
%             turn = true;
            obj.currentBehavior = obj.turnBehavior; 
%             build = false; 
%             runner = []; 
%             behaviorStatus = []; 
%             behavior = motorCortex.turnBehavior; 
%             distance = 15; 
%             clockwiseness = 1; 
%             speed = 1; 
%             testCase.assertEqual(animal.headDirectionSystem.getMaxActivationIndex(), 58);             
%             createdBehavior = helper.move(behavior, distance, speed, clockwiseness); 
            aMove = obj.moveHelper.move(obj.currentBehavior, obj.turnSpeed, obj.turnDistance, obj.clockwiseness); 
%             aMove = Move(obj.movePrefix, obj.animal, obj.turnSpeed, obj.turnDistance, obj.clockwiseness, turn, obj.getMoveBehaviorStatus(), build); % obj.runner obj.listenAndMark
% %             if (obj.standaloneMoves) 
            obj.moveHelper.doMove(aMove); 
%             end            
        end
        function aMove = run(obj)
            obj.clockwiseness = 0; 
%             turn = false;
            obj.currentBehavior = obj.runBehavior; 
%             build = false;
%             behaviorStatus = [];
            aMove = obj.moveHelper.move(obj.currentBehavior, obj.runSpeed, obj.runDistance, obj.clockwiseness); 
%             aMove = Move(obj.movePrefix, obj.animal, obj.runSpeed, obj.runDistance, obj.clockwiseness, turn, obj.getMoveBehaviorStatus(), build); 
% %             if (obj.standaloneMoves) 
            obj.moveHelper.doMove(aMove); 
% %             end                        
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
            obj.pendingSimulationOn = simulated; 
            obj.pendingSimulationOff = ~simulated;             
        end
        function settleBasic(obj)
            obj.animal.hippocampalFormation.placeOutput = obj.physicalPlace;
            obj.animal.hippocampalFormation.updateSubsystemFeatureDetectors(); 
            obj.animal.hippocampalFormation.settleGrids(); 
            obj.animal.resetSimulatedPositionOnlyToPhysicalPosition();
        end
        function turned = settlePhysical(obj)
            obj.settleBasic(); 
            turned = obj.reverseSimulatedTurn(); 
        end
        function turnNeeded = calculateNetSimulatedTurnsReversed(obj)
            netDistance = 0; 
            rows = size(obj.simulatedBehaviorHistory, 1);
            for ii = 1:rows
                behavior = obj.simulatedBehaviorHistory(ii,:);
                if (behavior(1) == obj.turnBehavior)
                    distance = behavior(2); 
                    clockwiseness = behavior(3); 
                    netDistance = netDistance + (distance * clockwiseness);   
                end
            end
            obj.turnDistance = abs(netDistance); 
            if (netDistance == 0) 
                turnNeeded = false;
                obj.clockwiseness = 0; 
            elseif (netDistance < 0)
                turnNeeded = true; 
                obj.clockwiseness = obj.counterClockwise; % reverse direction
            else
                turnNeeded = true; 
                obj.clockwiseness = obj.clockwise;  % reverse direction               
            end
        end
        function turned = reverseSimulatedTurn(obj)
            turned = false;
            if ((obj.turnDistance > 0) && (obj.clockwiseness ~= 0))
               turned = true; 
               disp(['reverse simulated turn; turnDistance: ',num2str(obj.turnDistance)]);                  
               obj.clockwiseness = obj.clockwiseness * -1; 
               obj.turn(); 
               obj.simulatedBehaviorHistory = [obj.simulatedBehaviorHistory; [obj.reverseSimulatedTurnBehavior obj.turnDistance obj.clockwiseness]];
               disp('obj.simulatedBehaviorHistory: '); 
               disp(obj.simulatedBehaviorHistory);
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
