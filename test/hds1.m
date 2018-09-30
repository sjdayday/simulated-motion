%% hds1: head direction system scenario 1 
% "actual" direction on left uncorrelated to randomly derived "inferred"
% position on right, but relative movements correctly reflected in both.
% 50 steps
% initial stabilization
% slow clockwise motion (t = 5-15)
% fast counter clockwise motion (t = 25-40) 
close all
clear all
cr = ExperimentController();
cr.visualize(true);
cr.setupDisplay(); 
cr.stepPause = 1;  % 0.25;
cr.totalSteps = 50;
cr.randomHeadDirection = true;
% cr.addControllerEvent(3, 'pause(30); ')
% expecting 2pi down to 3/2pi, then back up to 0 to pi/2
cr.addAnimalEvent(5, 'obj.minimumVelocity=pi/20; obj.clockwiseVelocity = -obj.minimumVelocity; obj.turn(-1,1);'); 
cr.addAnimalEvent(6, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(7, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(8, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(9, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(10, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(11, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(12, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(13, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(14, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(15, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(16, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(17, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(18, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(19, 'obj.turn(-1,1);'); 
% runs 60 up to 8 but displays as clockwise (opposite)
cr.addAnimalEvent(20, 'obj.clockwiseVelocity = 0;'); 
cr.addAnimalEvent(25, 'obj.counterClockwiseVelocity = obj.minimumVelocity*2;'); 
% runs 8 down to 49 but displays as CCW
cr.addAnimalEvent(40, 'obj.counterClockwiseVelocity = 0;'); 
cr.runHeadDirectionSystem();
