pwd % hds2: 
close all
clear all
cr = ExperimentController();
cr.visualize(true);
cr.setupDisplay(); 
cr.stepPause = 0.5;
cr.resetSeed = false; 
cr.totalSteps = 30;
cr.randomHeadDirection = false;
cr.addAnimalEvent(5, 'obj.showFeatures = 1; obj.features = [30 52];'); 
cr.addAnimalEvent(7, 'obj.showFeatures = 0; obj.features = [];'); 
cr.addAnimalEvent(10, 'obj.orientAnimal(pi/4); obj.clockwiseVelocity = -obj.minimumVelocity;'); 
% cr.addControllerEvent(10, 'disp(''animal physically moved to orientation pi/4, and randomly initializing internal head direction''); pause(10); ')
cr.addHeadDirectionSystemEvent(10, 'obj.initializeActivation(true);'); 
cr.addAnimalEvent(11, 'obj.clockwiseVelocity = -obj.minimumVelocity;'); 
% cr.addControllerEvent(11, 'disp(''animal orienting in new environment, so turning clockwise, stopping (conveniently) at orientation 0.''); pause(10); ')
% cr.addControllerEvent(15, 'disp(''now in physical orientation where features are detectable; internal head direction should adjust.''); pause(10); ')
cr.addAnimalEvent(15, 'obj.showFeatures = 1; obj.features = [30 52]; obj.clockwiseVelocity = 0;'); 
cr.addHeadDirectionSystemEvent(15, 'obj.readMode = 1;'); 
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
