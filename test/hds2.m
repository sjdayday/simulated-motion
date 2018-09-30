pwd % hds2: 
close all;
clear all;
cr = ExperimentController();
cr.visualize(true);
cr.setupDisplay(); 
cr.stepPause = 0.5;
cr.resetSeed = false; 
cr.totalSteps = 30;
cr.randomHeadDirection = false;
cr.addAnimalEvent(5, 'obj.minimumVelocity=pi/20; obj.showFeatures = 1; obj.features = [30 52];'); 
cr.addAnimalEvent(7, 'obj.showFeatures = 0; obj.features = [];'); 
cr.addAnimalEvent(10, 'obj.orientAnimal(pi/4); '); 
% cr.addControllerEvent(10, 'disp(''animal physically moved to orientation pi/4, and randomly initializing internal head direction''); pause(10); ')
cr.addHeadDirectionSystemEvent(10, 'obj.initializeActivation(true);'); 
cr.addAnimalEvent(11, 'obj.hippocampalFormation.headDirectionSystem.clockwiseVelocity = -obj.minimumVelocity; obj.turn(-1,1);'); 
cr.addAnimalEvent(12, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(13, 'obj.turn(-1,1);'); 
cr.addAnimalEvent(14, 'obj.turn(-1,1);'); 
% cr.addControllerEvent(11, 'disp(''animal orienting in new environment, so turning clockwise, stopping (conveniently) at orientation 0.''); pause(10); ')
% cr.addControllerEvent(15, 'disp(''now in physical orientation where features are detectable; internal head direction should adjust.''); pause(10); ')
cr.addAnimalEvent(15, 'obj.showFeatures = 1; obj.features = [30 52]; obj.hippocampalFormation.headDirectionSystem.clockwiseVelocity = 0; obj.clockwiseVelocity = 0'); 
cr.addHeadDirectionSystemEvent(15, 'obj.readMode = 1;'); 
cr.runHeadDirectionSystem();

