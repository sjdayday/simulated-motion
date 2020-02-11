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
            lastStatus = []; 
            updateAll = false; 
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex, updateAll, lastStatus); 
            status = motorCortex.navigationStatus;
            newStatus = helper.nextStatus(); 
%             newStatus = status.nextStatus(); 
            testCase.assertTrue(newStatus.lastStatus.moving); 
            testCase.assertClass(newStatus, 'NavigationStatusRandom'); 
            testCase.assertEqual(status.steps, 4);
            testCase.assertEqual(status.behavior, motorCortex.runBehavior);
            testCase.assertEqual(motorCortex.remainingDistance, 2);
            testCase.assertEqual(motorCortex.behaviorHistory, [2 4 0]);
            newStatus2 = helper.nextStatus(); 
%             newStatus2 = newStatus.nextStatus(); 
            testCase.assertTrue(newStatus2.lastStatus.moving); 
            testCase.assertClass(newStatus2, 'NavigationStatusRandom'); 
            testCase.assertEqual(newStatus.steps, 2);
            testCase.assertEqual(newStatus.behavior, motorCortex.turnBehavior);
            testCase.assertEqual(motorCortex.remainingDistance, 0);
            testCase.assertEqual(motorCortex.behaviorHistory, [2 4 0 ; 1 2 1], 'CCW turn');
            testCase.assertEqual(motorCortex.navigation.behaviorStatus.finish, false);                        
            newStatus3 = helper.nextStatus(); 
%             newStatus3 = newStatus2.nextStatus();             
            testCase.assertFalse(newStatus3.lastStatus.moving); 
            testCase.assertClass(newStatus3, 'NavigationStatusFinal'); 
            testCase.assertClass(newStatus3.lastStatus, 'NavigationStatusFinal');            
            testCase.assertClass(newStatus3.lastStatus.lastStatus, 'NavigationStatusRandom');             
            testCase.assertEqual(motorCortex.navigation.behaviorStatus.finish, true, ...
                'both transitions to NSFinal and executes immediately');
            newStatus4 = helper.nextStatus(); 
%             newStatus4 = newStatus3.nextStatus(); 
            testCase.assertFalse(newStatus4.lastStatus.moving); 
            testCase.assertClass(newStatus4, 'NavigationStatusFinal', 'no change....exiting'); 
        end
        function testRandomThenWhiskersTurnAwayThenRandom(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            lastStatus = []; 
            updateAll = false; 
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex, updateAll, lastStatus); 
            
            testCase.animal.rightWhiskerTouching = true; 
            newStatus = helper.nextStatus(); 
            testCase.assertClass(newStatus, 'NavigationStatusRandom');                            
            testCase.assertClass(newStatus.lastStatus, 'NavigationStatusWhiskersTurnAway'); 
            testCase.assertEqual(newStatus.lastStatus.behavior, motorCortex.turnBehavior);            
            testCase.assertEqual(newStatus.lastStatus.steps, 4);              
            testCase.assertEqual(motorCortex.clockwiseness, motorCortex.counterClockwise);
            testCase.assertClass(newStatus.lastStatus.lastStatus, 'NavigationStatusRandom', ...
                'where we started');                                        
        end
        function testRetraceRunThenWhiskersTurnAwayThenRandom(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            lastStatus = []; 
            updateAll = false; 
            motorCortex.navigationStatus = NavigationStatusRetraceRun(motorCortex, updateAll, lastStatus); 
            motorCortex.runDistance = 3; 
            
            testCase.animal.rightWhiskerTouching = true; 
            newStatus = helper.nextStatus(); 
            testCase.assertClass(newStatus, 'NavigationStatusRandom');                            
            testCase.assertClass(newStatus.lastStatus, 'NavigationStatusWhiskersTurnAway'); 
            testCase.assertEqual(newStatus.lastStatus.behavior, motorCortex.turnBehavior);            
            testCase.assertEqual(newStatus.lastStatus.steps, 3);              
            testCase.assertEqual(motorCortex.clockwiseness, motorCortex.counterClockwise);
            testCase.assertClass(newStatus.lastStatus.lastStatus, 'NavigationStatusRetraceRun', ...
                'where we started');                                        
        end
        function testNSPendingSimulationThenNSRandomSimulationThenSettle(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            lastStatus = []; 
            updateAll = false; 
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex, updateAll, lastStatus); 
            status = motorCortex.navigationStatus;
            newStatus = helper.nextStatus(); 
%             newStatus = status.nextStatus();  
            testCase.assertTrue(newStatus.lastStatus.moving); 
            testCase.assertClass(newStatus, 'NavigationStatusRandom'); 
            testCase.assertEqual(status.steps, 4);
            testCase.assertEqual(status.behavior, motorCortex.runBehavior);
            
            motorCortex.setSimulatedMotion(true);
            
            testCase.assertEqual(motorCortex.simulatedMotion, false);
            newStatus2 = helper.nextStatus();              
            testCase.assertTrue(newStatus2.lastStatus.moving);             
            testCase.assertFalse(newStatus2.lastStatus.lastStatus.moving); 
            testCase.assertClass(newStatus2, 'NavigationStatusSettle');                
            testCase.assertClass(motorCortex.navigationStatus, 'NavigationStatusSettle');    
            testCase.assertClass(newStatus2.lastStatus, 'NavigationStatusSimulatedRandom');    
            testCase.assertEqual(newStatus2.lastStatus.steps, 2);
            testCase.assertEqual(newStatus2.lastStatus.behavior, motorCortex.runBehavior);
            testCase.assertEqual(motorCortex.simulatedMotion, true);
            testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [2 2 0 ], 'run 4');
            testCase.assertClass(newStatus2.lastStatus.lastStatus, 'NavigationStatusPendingSimulationOn'); 
            testCase.assertClass(newStatus2.lastStatus.lastStatus.lastStatus, ...
                'NavigationStatusRandom', 'where we started');             
        end
        function testSimulatedTurnNSSettleTransitionsToNSSettleNetTurns(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            lastStatus = []; 
            updateAll = false; 
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex, updateAll, lastStatus); 
            motorCortex.setSimulatedMotion(true);
            rand(); 
            newStatus = helper.nextStatus(); 
            testCase.assertClass(newStatus, 'NavigationStatusSettle');                            
            testCase.assertClass(newStatus.lastStatus, 'NavigationStatusSimulatedRandom'); 
            testCase.assertEqual(newStatus.lastStatus.behavior, motorCortex.turnBehavior);            
            testCase.assertEqual(newStatus.lastStatus.steps, 5);
            motorCortex.turnDistance = 5;              
            testCase.assertEqual(motorCortex.clockwiseness, motorCortex.counterClockwise);
            testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [1 5 1 ], 'CCW 5');
            motorCortex.setSimulatedMotion(false);            
            newStatus2 = helper.nextStatus();
            testCase.assertClass(motorCortex.navigationStatus, 'NavigationStatusPendingSimulationOff');    
            testCase.assertClass(newStatus2, 'NavigationStatusPendingSimulationOff');             
            testCase.assertClass(newStatus2.lastStatus, 'NavigationStatusSettleNetTurns');
            testCase.assertClass(newStatus2.lastStatus.lastStatus, 'NavigationStatusSettle', ...
                'where we started');                                        
            testCase.assertEqual(newStatus2.lastStatus.steps, 5);
            testCase.assertEqual(newStatus2.lastStatus.behavior, motorCortex.reverseSimulatedTurnBehavior);
            testCase.assertEqual(motorCortex.simulatedMotion, true);
            testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [1 5 1; 11 5 -1 ], 'CW 5');
        end
        function testSimulatedRunThenPendingSimulationOffThenRetraceFirstRun(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            lastStatus = [];
            updateAll = false; 
            
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex, updateAll, lastStatus); 
            motorCortex.setSimulatedMotion(true);
            
            testCase.assertEqual(motorCortex.simulatedMotion, false);
            newStatus = helper.nextStatus(); 
            testCase.assertClass(newStatus, 'NavigationStatusSettle');                
            testCase.assertClass(newStatus.lastStatus, 'NavigationStatusSimulatedRandom');    
            testCase.assertEqual(newStatus.lastStatus.steps, 4);
            testCase.assertEqual(newStatus.lastStatus.behavior, motorCortex.runBehavior);
            testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [2 4 0 ], 'run 4');            
            motorCortex.setSimulatedMotion(false);            
            newStatus2 = helper.nextStatus(); 
            testCase.assertClass(newStatus2, 'NavigationStatusRandom'); 
            testCase.assertClass(newStatus2.lastStatus, 'NavigationStatusRetraceRun'); 
            testCase.assertTrue(newStatus2.lastStatus.moving);                         
            testCase.assertClass(newStatus2.lastStatus.lastStatus, 'NavigationStatusRetraceSimulatedMoves');             
            testCase.assertFalse(newStatus2.lastStatus.lastStatus.moving); 
            testCase.assertClass(newStatus2.lastStatus.lastStatus.lastStatus, ...
                'NavigationStatusPendingSimulationOff');             
            testCase.assertClass(newStatus2.lastStatus.lastStatus.lastStatus.lastStatus, ...
                'NavigationStatusSettleNetTurns');             
            testCase.assertClass(newStatus2.lastStatus.lastStatus.lastStatus.lastStatus.lastStatus, ...
                'NavigationStatusSettle', 'where we started');             
        end
        function testMultipleTurnsThenSettleNetTurnsThenPendingSimulationOff(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            lastStatus = []; 
            updateAll = false; 
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex, updateAll, lastStatus); 

            motorCortex.setSimulatedMotion(true);
            rand(); 
            newStatus = helper.nextStatus(); 
            testCase.assertClass(newStatus, 'NavigationStatusSettle');                            
            testCase.assertClass(newStatus.lastStatus, 'NavigationStatusSimulatedRandom'); 
            testCase.assertEqual(newStatus.lastStatus.behavior, motorCortex.turnBehavior);            
            testCase.assertEqual(newStatus.lastStatus.steps, 5);
            motorCortex.turnDistance = 5;              
            testCase.assertEqual(motorCortex.clockwiseness, motorCortex.counterClockwise);
            testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [1 5 1 ], 'CCW 5');
            
            rand(); rand(); 
            newStatus2 = helper.nextStatus();
            testCase.assertClass(motorCortex.navigationStatus, 'NavigationStatusSettle');    
            testCase.assertClass(newStatus2, 'NavigationStatusSettle');             
            testCase.assertClass(newStatus2.lastStatus, 'NavigationStatusSimulatedRandom');
            testCase.assertClass(newStatus2.lastStatus.lastStatus, 'NavigationStatusSettle', ...
                'where we started');                                        
            testCase.assertEqual(newStatus2.lastStatus.steps, 4);
            testCase.assertEqual(newStatus2.lastStatus.behavior, motorCortex.turnBehavior);
            testCase.assertEqual(motorCortex.simulatedMotion, true);
            testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [1 5 1; 1 4 -1 ], 'CCW 5, CW 4');

            motorCortex.setSimulatedMotion(false);
            newStatus3 = helper.nextStatus(); 
            testCase.assertClass(newStatus3, 'NavigationStatusPendingSimulationOff');             
            testCase.assertClass(newStatus3.lastStatus, 'NavigationStatusSettleNetTurns'); 
            testCase.assertTrue(newStatus3.lastStatus.moving);                         
            testCase.assertEqual(newStatus3.lastStatus.steps, 1);
            testCase.assertEqual(newStatus3.lastStatus.clockwiseness, -1);
            testCase.assertEqual(newStatus3.lastStatus.behavior, motorCortex.reverseSimulatedTurnBehavior);
            testCase.assertEqual(motorCortex.simulatedMotion, true);
            testCase.assertClass(newStatus3.lastStatus.lastStatus, ...
                'NavigationStatusSettle', 'where we started'); 
        end
        function testTurnsNetToZeroThenPendingSimulationOffThenRetraceMoves(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            lastStatus = []; 
            updateAll = false; 
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex, updateAll, lastStatus); 

            motorCortex.setSimulatedMotion(true);
            rand(); 
            newStatus = helper.nextStatus(); 
            testCase.assertClass(newStatus, 'NavigationStatusSettle');                            
            testCase.assertClass(newStatus.lastStatus, 'NavigationStatusSimulatedRandom'); 
            testCase.assertEqual(newStatus.lastStatus.behavior, motorCortex.turnBehavior);            
            testCase.assertEqual(newStatus.lastStatus.steps, 5);
            motorCortex.turnDistance = 5;              
            testCase.assertEqual(motorCortex.clockwiseness, motorCortex.counterClockwise);
            testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [1 5 1 ], 'CCW 5');
            % force offsetting turns
            motorCortex.simulatedBehaviorHistory = [1 5 1; 1 5 -1]; 
            
            motorCortex.setSimulatedMotion(false);            
            newStatus2 = helper.nextStatus();  
            testCase.assertClass(motorCortex.navigationStatus, 'NavigationStatusRetraceSimulatedMoves');    
            testCase.assertClass(newStatus2, 'NavigationStatusRetraceSimulatedMoves');             
%             testCase.assertClass(newStatus2, 'NavigationStatusPendingSimulationOff');             
%             testCase.assertClass(newStatus2.lastStatus.lastStatus, 'NavigationStatusSettle', ...
%                 'where we started');                                        
            testCase.assertClass(newStatus2.lastStatus, 'NavigationStatusRetraceTurn'); % 
            testCase.assertEqual(newStatus2.lastStatus.steps, 5);
            testCase.assertEqual(newStatus2.lastStatus.behavior, motorCortex.turnBehavior);
            testCase.assertEqual(newStatus2.lastStatus.clockwiseness, motorCortex.counterClockwise);
            testCase.assertTrue(newStatus2.lastStatus.moving);                         
%             testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [1 5 1; 11 5 -1 ], 'CW 5');
            testCase.assertClass(newStatus2.lastStatus.lastStatus, 'NavigationStatusRetraceSimulatedMoves');
            testCase.assertClass(newStatus2.lastStatus.lastStatus.lastStatus, ...
                'NavigationStatusPendingSimulationOff');         
            testCase.assertClass(newStatus2.lastStatus.lastStatus.lastStatus.lastStatus, ...
                'NavigationStatusSettleNetTurns');  
            testCase.assertClass(newStatus2.lastStatus.lastStatus.lastStatus.lastStatus.lastStatus, ...
                'NavigationStatusSettle', 'where we started');                                        
        end
        function testRetraceMovesEndsAtFirstRun(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            lastStatus = []; 
            updateAll = false; 
            motorCortex.simulatedBehaviorHistory = [ 1 5 1; 11 5 -1; 1 4 -1; 2 3 0 ; 2 2 0]; 
            motorCortex.navigationStatus = NavigationStatusPendingSimulationOff(motorCortex, updateAll, lastStatus); 
%             motorCortex.setSimulatedMotion(true);
            newStatus = helper.nextStatus(); 
            testCase.assertClass(newStatus, 'NavigationStatusRetraceSimulatedMoves');             
            testCase.assertClass(newStatus.lastStatus, 'NavigationStatusRetraceTurn'); 
            testCase.assertTrue(newStatus.lastStatus.moving);                                     
            testCase.assertEqual(newStatus.lastStatus.steps, 5);            
            testCase.assertEqual(newStatus.lastStatus.clockwiseness, ...
                motorCortex.counterClockwise);                                    
            testCase.assertClass(newStatus.lastStatus.lastStatus, 'NavigationStatusRetraceSimulatedMoves'); 
            testCase.assertClass(newStatus.lastStatus.lastStatus.lastStatus, ...
               'NavigationStatusPendingSimulationOff', 'where we started');                                                    

            newStatus2 = helper.nextStatus();
          
            testCase.assertClass(newStatus2, 'NavigationStatusRetraceSimulatedMoves');             
            testCase.assertClass(newStatus2.lastStatus, 'NavigationStatusRetraceTurn'); 
            testCase.assertTrue(newStatus2.lastStatus.moving);      
            testCase.assertEqual(newStatus2.lastStatus.steps, 4);            
            testCase.assertClass(newStatus2.lastStatus.lastStatus, 'NavigationStatusRetraceSimulatedMoves'); 
            testCase.assertEqual(newStatus2.lastStatus.lastStatus.steps, 4);                        
            testCase.assertEqual(newStatus2.lastStatus.lastStatus.clockwiseness, ...
                motorCortex.clockwise);                                    
            testCase.assertClass(newStatus2.lastStatus.lastStatus.lastStatus, ...
               'NavigationStatusRetraceSimulatedMoves', 'skipping the reversed turn, where we started');
            testCase.assertEqual(newStatus2.lastStatus.lastStatus.lastStatus.behavior, ...
                motorCortex.reverseSimulatedTurnBehavior);                                    
            testCase.assertClass(newStatus2.lastStatus.lastStatus.lastStatus.lastStatus, ...
               'NavigationStatusRetraceTurn', 'first move');                                                    
            testCase.assertEqual(newStatus2.lastStatus.lastStatus.lastStatus.lastStatus.steps, 5);                 
            testCase.assertTrue(motorCortex.navigateFirstSimulatedRun);
            
            newStatus3 = helper.nextStatus();
            testCase.assertClass(newStatus3, 'NavigationStatusRandom');             
            testCase.assertClass(newStatus3.lastStatus, 'NavigationStatusRetraceRun'); 
            testCase.assertTrue(newStatus3.lastStatus.moving);                                     
            testCase.assertEqual(newStatus3.lastStatus.steps, 3);            
            testCase.assertClass(newStatus3.lastStatus.lastStatus, 'NavigationStatusRetraceSimulatedMoves'); 
            testCase.assertEqual(newStatus3.lastStatus.lastStatus.steps, 3);                        
            testCase.assertEqual(newStatus3.lastStatus.lastStatus.behavior, ...
                motorCortex.runBehavior);                                    
            testCase.assertClass(newStatus3.lastStatus.lastStatus.lastStatus, ...
               'NavigationStatusRetraceTurn', 'previous');
            testCase.assertEqual(newStatus3.lastStatus.lastStatus.lastStatus.behavior, ...
                motorCortex.turnBehavior);                                    
            testCase.assertEqual(newStatus3.lastStatus.lastStatus.lastStatus.steps, 4);                 
            testCase.assertEqual(motorCortex.simulatedBehaviorHistory, [ 2 2 0]); 
            testCase.assertTrue(motorCortex.navigateFirstSimulatedRun, ...
                'still true until next random navigation');
 
            newStatus4 = helper.nextStatus();            
            testCase.assertClass(newStatus4, 'NavigationStatusRandom');             
            testCase.assertClass(newStatus4.lastStatus, 'NavigationStatusRandom'); 
            testCase.assertFalse(motorCortex.navigateFirstSimulatedRun, ...
                'next random navigation turns the flag off');
        end
        function testSimulationOffFlagThenSettleNetTurnsThenPendingSimulationOff(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            lastStatus = []; 
            updateAll = false;
            motorCortex.pendingSimulationOff = true; 
            motorCortex.simulatedBehaviorHistory = [ 1 5 1; 1 4 -1; 2 3 0 ; 1 3 -1]; 
            motorCortex.navigationStatus = NavigationStatusSimulatedRandom(motorCortex, updateAll, lastStatus); 
%             motorCortex.setSimulatedMotion(true);
            newStatus = helper.nextStatus(); 
            testCase.assertClass(newStatus, 'NavigationStatusPendingSimulationOff');             
            testCase.assertClass(newStatus.lastStatus, 'NavigationStatusSettleNetTurns'); 
            testCase.assertTrue(newStatus.lastStatus.moving);                                     
            testCase.assertEqual(newStatus.lastStatus.steps, 2);            
            testCase.assertEqual(newStatus.lastStatus.clockwiseness, motorCortex.counterClockwise); 
            testCase.assertEqual(motorCortex.simulatedBehaviorHistory, ... 
                [ 1 5 1; 1 4 -1; 2 3 0 ; 1 3 -1; 11 2 1]); 
            testCase.assertClass(newStatus.lastStatus.lastStatus, 'NavigationStatusSettle'); 
            testCase.assertClass(newStatus.lastStatus.lastStatus.lastStatus, ...
               'NavigationStatusSimulatedRandom', 'where we started');                                                    

        end
        function testRetraceMovesTransitionsToRandomNavIfNoSimulatedRun(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            helper = TestingMoveHelper(motorCortex);  
            motorCortex.moveHelper = helper; 
            motorCortex.prepareNavigate(); 
            lastStatus = []; 
            updateAll = false; 
            motorCortex.simulatedBehaviorHistory = [ 1 5 1; 11 5 -1; 1 4 -1]; 
            motorCortex.navigationStatus = NavigationStatusPendingSimulationOff(motorCortex, updateAll, lastStatus); 
%             motorCortex.setSimulatedMotion(true);
            newStatus = helper.nextStatus(); 
            testCase.assertClass(newStatus, 'NavigationStatusRetraceSimulatedMoves');             
            testCase.assertClass(newStatus.lastStatus, 'NavigationStatusRetraceTurn'); 
            testCase.assertTrue(newStatus.lastStatus.moving);                                     
            testCase.assertEqual(newStatus.lastStatus.steps, 5);            
            testCase.assertClass(newStatus.lastStatus.lastStatus, 'NavigationStatusRetraceSimulatedMoves'); 
            testCase.assertClass(newStatus.lastStatus.lastStatus.lastStatus, ...
               'NavigationStatusPendingSimulationOff', 'where we started');  
           testCase.assertTrue(motorCortex.navigateFirstSimulatedRun);

            newStatus2 = helper.nextStatus();
            testCase.assertClass(newStatus2, 'NavigationStatusRetraceSimulatedMoves');             
            testCase.assertClass(newStatus2.lastStatus, 'NavigationStatusRetraceTurn'); 
            testCase.assertTrue(newStatus2.lastStatus.moving);                                     
            testCase.assertEqual(newStatus2.lastStatus.steps, 4);            
            testCase.assertClass(newStatus2.lastStatus.lastStatus, 'NavigationStatusRetraceSimulatedMoves'); 
            testCase.assertEqual(newStatus2.lastStatus.lastStatus.steps, 4);                        
            testCase.assertEqual(newStatus2.lastStatus.lastStatus.clockwiseness, ...
                motorCortex.clockwise);                                    
            testCase.assertClass(newStatus2.lastStatus.lastStatus.lastStatus, ...
               'NavigationStatusRetraceSimulatedMoves', 'skipping the reversed turn, where we started');
            testCase.assertEqual(newStatus2.lastStatus.lastStatus.lastStatus.behavior, ...
                motorCortex.reverseSimulatedTurnBehavior);                                    
            testCase.assertClass(newStatus2.lastStatus.lastStatus.lastStatus.lastStatus, ...
               'NavigationStatusRetraceTurn', 'first move');                                                    
            testCase.assertEqual(newStatus2.lastStatus.lastStatus.lastStatus.lastStatus.steps, 5);                 

            newStatus3 = helper.nextStatus();
            testCase.assertClass(newStatus3, 'NavigationStatusRandom');             
            testCase.assertClass(newStatus3.lastStatus, 'NavigationStatusRandom'); 
            testCase.assertTrue(newStatus3.lastStatus.moving);
            testCase.assertClass(newStatus3.lastStatus.lastStatus, 'NavigationStatusRetraceSimulatedMoves');                         
            testCase.assertEqual(newStatus3.lastStatus.lastStatus.behavior, motorCortex.noBehavior);  

            testCase.assertClass(newStatus3.lastStatus.lastStatus.lastStatus, ...
                'NavigationStatusRetraceTurn'); 
            testCase.assertEqual(newStatus3.lastStatus.lastStatus.lastStatus.steps, 4);                        
            testCase.assertEqual(newStatus3.lastStatus.lastStatus.lastStatus.behavior, ...
                motorCortex.turnBehavior);                                    
            testCase.assertTrue(isempty(motorCortex.simulatedBehaviorHistory));  
            testCase.assertFalse(motorCortex.navigateFirstSimulatedRun);
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
