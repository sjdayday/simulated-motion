classdef NavigationStatusTest < AbstractTest
    properties
        animal
    end

    methods (Test)
        function testNSRandomUntilOutOfStepsThenImmediateTransitionToNSFinal(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 6; 
            motorCortex.moveHelper = TestingMoveHelper(motorCortex);  
            motorCortex.prepareNavigate(); 
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex); 
            status = motorCortex.navigationStatus;
            newStatus = status.nextStatus(); 
            testCase.assertClass(newStatus, 'NavigationStatusRandom'); 
            testCase.assertEqual(status.steps, 4);
            testCase.assertEqual(status.behavior, motorCortex.runBehavior);
            testCase.assertEqual(motorCortex.remainingDistance, 2);
            newStatus2 = newStatus.nextStatus(); 
            testCase.assertClass(newStatus2, 'NavigationStatusRandom'); 
            testCase.assertEqual(newStatus.steps, 2);
            testCase.assertEqual(newStatus.behavior, motorCortex.turnBehavior);
            testCase.assertEqual(motorCortex.remainingDistance, 0);
            testCase.assertEqual(motorCortex.navigation.behaviorStatus.finish, false);                        
            newStatus3 = newStatus2.nextStatus(); 
            testCase.assertClass(newStatus3, 'NavigationStatusFinal'); 
            testCase.assertClass(newStatus3.lastStatus, 'NavigationStatusFinal');            
            testCase.assertClass(newStatus3.lastStatus.lastStatus, 'NavigationStatusRandom');             
            testCase.assertEqual(motorCortex.navigation.behaviorStatus.finish, true, ...
                'both transitions to NSFinal and executes immediately');
            newStatus4 = newStatus3.nextStatus(); 
            testCase.assertClass(newStatus4, 'NavigationStatusFinal'); 
        end
        function testNSRandomUntilPendingSimulationImmediatelyNSRandomSimulation(testCase)
            testCase.buildAnimal();
            motorCortex = testCase.animal.motorCortex; 
            motorCortex.remainingDistance = 100; 
            motorCortex.moveHelper = TestingMoveHelper(motorCortex);  
            motorCortex.prepareNavigate(); 
            motorCortex.navigationStatus = NavigationStatusRandom(motorCortex); 
            status = motorCortex.navigationStatus;
            newStatus = status.nextStatus(); 
            testCase.assertClass(newStatus, 'NavigationStatusRandom'); 
            testCase.assertEqual(status.steps, 4);
            testCase.assertEqual(status.behavior, motorCortex.runBehavior);
            motorCortex.setSimulatedMotion(true);
            testCase.assertEqual(motorCortex.simulatedMotion, false);
            newStatus2 = newStatus.nextStatus();              
            testCase.assertClass(newStatus2, 'NavigationStatusSimulatedRandom');             
            testCase.assertClass(newStatus2.lastStatus, 'NavigationStatusPendingSimulationOn'); 
            testCase.assertClass(newStatus2.lastStatus.lastStatus, 'NavigationStatusRandom');             
            testCase.assertEqual(motorCortex.simulatedMotion, true);
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
