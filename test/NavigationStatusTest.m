classdef NavigationStatusTest < AbstractTest
    properties
        animal
    end

    methods (Test)
        function testNSRandomUntilOutOfStepsThenImmediateTransitionToNSFinal(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 6; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            updateAll = false; 
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex, updateAll); 
            
            status = motorCortex.navigationStatus;
            newStatus = helper.nextStatus(); 
%             newStatus = status.nextStatus(); 
            testCase.assertClass(newStatus, 'NavigationStatusRandom'); 
            testCase.assertEqual(status.steps, 4);
            testCase.assertEqual(status.behavior, motorCortex.runBehavior);
            testCase.assertEqual(motorCortex.remainingDistance, 2);
            testCase.assertEqual(motorCortex.behaviorHistory, [2 4 0]);
            newStatus2 = helper.nextStatus(); 
%             newStatus2 = newStatus.nextStatus(); 
            testCase.assertClass(newStatus2, 'NavigationStatusRandom'); 
            testCase.assertEqual(newStatus.steps, 2);
            testCase.assertEqual(newStatus.behavior, motorCortex.turnBehavior);
            testCase.assertEqual(motorCortex.remainingDistance, 0);
            testCase.assertEqual(motorCortex.behaviorHistory, [2 4 0 ; 1 2 1], 'CCW turn');
            testCase.assertEqual(motorCortex.navigation.behaviorStatus.finish, false);                        
            newStatus3 = helper.nextStatus(); 
%             newStatus3 = newStatus2.nextStatus();             
            testCase.assertClass(newStatus3, 'NavigationStatusFinal'); 
            testCase.assertClass(newStatus3.lastStatus, 'NavigationStatusFinal');            
            testCase.assertClass(newStatus3.lastStatus.lastStatus, 'NavigationStatusRandom');             
            testCase.assertEqual(motorCortex.navigation.behaviorStatus.finish, true, ...
                'both transitions to NSFinal and executes immediately');
            newStatus4 = helper.nextStatus(); 
%             newStatus4 = newStatus3.nextStatus(); 
            testCase.assertClass(newStatus4, 'NavigationStatusFinal'); 
        end
        function testNSRandomUntilPendingSimulationImmediatelyNSRandomSimulation(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            updateAll = false; 
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex, updateAll); 
            status = motorCortex.navigationStatus;
            newStatus = helper.nextStatus(); 
%             newStatus = status.nextStatus();             
            testCase.assertClass(newStatus, 'NavigationStatusRandom'); 
            testCase.assertEqual(status.steps, 4);
            testCase.assertEqual(status.behavior, motorCortex.runBehavior);
            motorCortex.setSimulatedMotion(true);
            testCase.assertEqual(motorCortex.simulatedMotion, false);
            newStatus2 = helper.nextStatus();              
%             newStatus2 = newStatus.nextStatus();                          
            testCase.assertClass(newStatus2, 'NavigationStatusSimulatedRandom');             
            testCase.assertClass(newStatus2.lastStatus, 'NavigationStatusPendingSimulationOn'); 
            testCase.assertClass(newStatus2.lastStatus.lastStatus, 'NavigationStatusRandom');             
            testCase.assertEqual(motorCortex.simulatedMotion, true);
        end
        function testNSSimulatedRandomTransitionsToNSSettle(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            updateAll = false; 
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex, updateAll); 
            motorCortex.setSimulatedMotion(true);
            newStatus = helper.nextStatus(); 
            testCase.assertClass(newStatus, 'NavigationStatusSimulatedRandom'); 
            newStatus2 = helper.nextStatus();
            testCase.assertEqual(newStatus2.lastStatus.steps, 4);
            testCase.assertEqual(newStatus2.lastStatus.behavior, motorCortex.runBehavior);
            testCase.assertEqual(motorCortex.simulatedMotion, true);
            testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [2 4 0 ], 'run 4');
            testCase.assertClass(newStatus2, 'NavigationStatusSettle');             
        end
        function testIfLastTurnNSSettleTransitionsToReverseSimulatedTurn(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            updateAll = false; 
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex, updateAll); 
            motorCortex.setSimulatedMotion(true);
            testStatus = helper.nextStatus(); 
            testCase.assertClass(testStatus, 'NavigationStatusSimulatedRandom'); 
            testStatus.behavior = motorCortex.turnBehavior; % force a turn
            motorCortex.clockwiseness = motorCortex.counterClockwise; 
            newStatus2 = helper.nextStatus();
            testCase.assertEqual(newStatus2.lastStatus.steps, 4);
            motorCortex.turnDistance = 4; 
            testCase.assertEqual(newStatus2.lastStatus.behavior, motorCortex.turnBehavior);
            testCase.assertEqual(motorCortex.simulatedMotion, true);
            testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [1 4 1 ], 'CCW 4');
            testCase.assertClass(newStatus2, 'NavigationStatusSettle');             
            newStatus3 = helper.nextStatus(); 
            testCase.assertClass(newStatus3, 'NavigationStatusSimulatedRandom'); 
            testCase.assertClass(newStatus3.lastStatus, 'NavigationStatusSettleReverseTurn'); 
            testCase.assertEqual(newStatus2.steps, 4);
            testCase.assertEqual(newStatus3.lastStatus.steps, 4, ...
                'passed from settle to settle reversed turn');            
            testCase.assertEqual(newStatus3.lastStatus.behavior, motorCortex.reverseSimulatedTurnBehavior);
            testCase.assertEqual(newStatus2.clockwiseness, motorCortex.clockwise, ... 
                'reversed clockwiseness' );            
            testCase.assertEqual(newStatus3.lastStatus.clockwiseness, motorCortex.clockwise, ... 
                'passed from settle to settle reversed turn' );            
            testCase.assertEqual(motorCortex.simulatedMotion, true);
            testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [1 4 1; 11 4 -1 ], 'CW 4');
        end
        function testSimulatedRunThenPendingSimulationOffThenRetraceFirstRun(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            updateAll = false; 
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex, updateAll); 
            motorCortex.setSimulatedMotion(true);
            testStatus = helper.nextStatus(); 
            testCase.assertClass(testStatus, 'NavigationStatusSimulatedRandom'); 
            testStatus.behavior = motorCortex.runBehavior; % force a run
            motorCortex.clockwiseness = 0; 
            newStatus2 = helper.nextStatus();
            testCase.assertEqual(newStatus2.lastStatus.steps, 4);
            motorCortex.runDistance = 4; 
            testCase.assertEqual(newStatus2.lastStatus.behavior, motorCortex.runBehavior);
            testCase.assertEqual(motorCortex.simulatedMotion, true);
            testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [2 4 0 ], 'run 4');
            testCase.assertClass(newStatus2, 'NavigationStatusSettle');             
            
            motorCortex.setSimulatedMotion(false);
            
            newStatus3 = helper.nextStatus(); 
            testCase.assertClass(newStatus3, 'NavigationStatusRetraceSimulatedRun'); 
            testCase.assertClass(newStatus3.lastStatus, 'NavigationStatusPendingSimulationOff'); 
        end
        function testSettleReverseTurnThenPendingSimulationOffThenRetraceRun(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            updateAll = false; 
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex, updateAll); 
            motorCortex.setSimulatedMotion(true);
            testStatus = helper.nextStatus(); 
            testCase.assertClass(testStatus, 'NavigationStatusSimulatedRandom'); 
            testStatus.behavior = motorCortex.turnBehavior; % force a turn
            motorCortex.clockwiseness = motorCortex.counterClockwise; 
            newStatus2 = helper.nextStatus();
            testCase.assertEqual(newStatus2.lastStatus.steps, 4);
            motorCortex.turnDistance = 4; 
            testCase.assertEqual(newStatus2.lastStatus.behavior, motorCortex.turnBehavior);
            testCase.assertEqual(motorCortex.simulatedMotion, true);
            testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [1 4 1 ], 'CCW 4');
            testCase.assertClass(newStatus2, 'NavigationStatusSettle');
            
            motorCortex.setSimulatedMotion(false);
            
            newStatus3 = helper.nextStatus(); 
            testCase.assertClass(newStatus3, 'NavigationStatusPendingSimulationOff'); 
            testCase.assertClass(newStatus3.lastStatus, 'NavigationStatusSettleReverseTurn'); 
            % immediate to pending off 
            newStatus4 = helper.nextStatus(); 
            testCase.assertClass(newStatus4, 'NavigationStatusRetraceSimulatedRun'); 
            testCase.assertClass(newStatus4.lastStatus, 'NavigationStatusPendingSimulationOff'); 

            
%             testCase.assertEqual(newStatus2.steps, 4);
%             testCase.assertEqual(newStatus3.lastStatus.steps, 4, ...
%                 'passed from settle to settle reversed turn');            
%             testCase.assertEqual(newStatus3.lastStatus.behavior, motorCortex.reverseSimulatedTurnBehavior);
%             testCase.assertEqual(newStatus2.clockwiseness, motorCortex.clockwise, ... 
%                 'reversed clockwiseness' );            
%             testCase.assertEqual(newStatus3.lastStatus.clockwiseness, motorCortex.clockwise, ... 
%                 'passed from settle to settle reversed turn' );            
%             testCase.assertEqual(motorCortex.simulatedMotion, true);
%             testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [1 4 1; 11 4 -1 ], 'CW 4');
% 
%             testCase.buildAnimal();
%             motorCortex = testCase.animal.motorCortex; 
%             motorCortex.remainingDistance = 100; 
%             helper = TestingMoveHelper(motorCortex);  
%             motorCortex.moveHelper = helper; 
%             motorCortex.prepareNavigate(); 
%             updateAll = false; 
%             motorCortex.navigationStatus = NavigationStatusRandom(motorCortex, updateAll); 
%             motorCortex.setSimulatedMotion(true);
%             testStatus = helper.nextStatus(); 
%             testCase.assertClass(testStatus, 'NavigationStatusSimulatedRandom'); 
%             testStatus.behavior = motorCortex.runBehavior; % force a run
%             motorCortex.clockwiseness = 0; 
%             newStatus2 = helper.nextStatus();
%             testCase.assertEqual(newStatus2.lastStatus.steps, 4);
%             motorCortex.runDistance = 4; 
%             testCase.assertEqual(newStatus2.lastStatus.behavior, motorCortex.runBehavior);
%             testCase.assertEqual(motorCortex.simulatedMotion, true);
%             testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [2 4 0 ], 'run 4');
%             testCase.assertClass(newStatus2, 'NavigationStatusSettle');             
%             
%             motorCortex.setSimulatedMotion(false);
%             
%             newStatus3 = helper.nextStatus(); 
%             testCase.assertClass(newStatus3, 'NavigationStatusRetraceSimulatedRun'); 
%             testCase.assertClass(newStatus3.lastStatus, 'NavigationStatusPendingSimulationOff'); 
        end
        
        function buildAnimal(testCase)
            env = Environment();
            env.addWall([0 0],[0 2]); 
            env.addWall([0 2],[2 2]); 
            env.addWall([0 0],[2 0]); 
            env.addWall([2 0],[2 2]);
            env.build();
            testCase.animal = Animal();
            testCase.animal.pullVelocityFromAnimal = false; 
            testCase.animal.build(); 
            testCase.animal.place(env, 1, 1, 0);
        end
    end
end
