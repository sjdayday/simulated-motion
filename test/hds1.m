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
cr.stepPause = 0.3;
cr.totalSteps = 50;
cr.randomHeadDirection = true;
cr.addAnimalEvent(5, 'obj.clockwiseVelocity = -obj.minimumVelocity;'); 
cr.addAnimalEvent(20, 'obj.clockwiseVelocity = 0;'); 
cr.addAnimalEvent(25, 'obj.counterClockwiseVelocity = obj.minimumVelocity*2;'); 
cr.addAnimalEvent(40, 'obj.counterClockwiseVelocity = 0;'); 
cr.runHeadDirectionSystem();

%             obj.time = obj.time+1;
%             if obj.time == 3
%                 obj.features = [30 52]; 
%             end
%             if obj.time == 10
%                 obj.features = []; 
%             end
%             if obj.time == 5
%                 obj.clockwiseVelocity = -obj.minimumVelocity; 
%             end
%             if obj.time == 18
%                 obj.clockwiseVelocity = 0; 
%             end
%             if obj.time == 25
%                 obj.counterClockwiseVelocity = obj.minimumVelocity*2; 
%             end
%             if obj.time == 37
%                 obj.counterClockwiseVelocity = 0; 
%             end
