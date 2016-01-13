% hds2: 
close all
clear all
cr = ExperimentController();
cr.visualize(true);
cr.setupDisplay(); 
cr.stepPause = 0.3;
cr.totalSteps = 15;
cr.randomHeadDirection = false;
cr.addAnimalEvent(5, 'obj.showFeatures = 1; obj.features = [30 52];'); 
cr.addAnimalEvent(10, 'obj.showFeatures = 0; obj.features = [];'); 
cr.runHeadDirectionSystem();


% cr.addAnimalEvent(18, 'obj.clockwiseVelocity = 0;'); 
% cr.addAnimalEvent(25, 'obj.counterClockwiseVelocity = obj.minimumVelocity*2;'); 
% cr.addAnimalEvent(37, 'obj.counterClockwiseVelocity = 0;'); 
% cr.runHeadDirectionSystem();

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
