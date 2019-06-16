% System interface:  all systems implement System
% Run, initialize activation, orient, attempt to recover last place ID.  
classdef S10 < handle 

    properties
        ec
    end
    methods 
        function obj = S10()
            close all;
            obj.ec = ExperimentController(); 
            obj.ec.visualize(true);
            obj.ec.pullVelocityFromAnimal = false;
            obj.ec.pullFeaturesFromAnimal = false; 
            obj.ec.defaultFeatureDetectors = false; 
            obj.ec.updateFeatureDetectors = true; 
            obj.ec.showHippocampalFormationECIndices = true; 
            obj.ec.placeMatchThreshold = 2;
            obj.ec.build(); 
            obj.ec.setupDisplay(); 
            obj.ec.stepPause = 0;
            obj.ec.resetSeed = false; 
            obj.ec.totalSteps = 48;
%             obj.ec.randomHeadDirection = false; % no effect?  
            obj.ec.addHeadDirectionSystemEvent(5, 'obj.minimumVelocity=pi/30;obj.initializeActivation(true);'); 
            obj.ec.addAnimalEvent(5, 'obj.minimumVelocity=pi/30; obj.minimumRunVelocity = 0.05;'); 
            obj.ec.addAnimalEvent(7, 'obj.orientAnimal(pi/3); obj.calculateVertices();'); 
            obj.ec.addAnimalEvent(8, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();'); 
            obj.ec.addAnimalEvent(10, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');             
            obj.ec.addAnimalEvent(12, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(14, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(16, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(18, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(20, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(22, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(24, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addControllerEvent(25, 'disp(''observe location....''); pause(20); ')
            obj.ec.addHeadDirectionSystemEvent(26, 'obj.initializeActivation(true);'); 
            obj.ec.addAnimalEvent(26, 'obj.hippocampalFormation.initializeGridActivation();');
            obj.ec.addHeadDirectionSystemEvent(40, 'obj.readMode = 1;');
            obj.ec.addAnimalEvent(41, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');     
            obj.ec.addAnimalEvent(45, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');
            obj.ec.addAnimalEvent(49, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');
            obj.ec.addAnimalEvent(53, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');
            obj.ec.addAnimalEvent(57, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');
%             obj.ec.addAnimalEvent(31, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');
%             obj.ec.addAnimalEvent(31, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');
%             obj.ec.addAnimalEvent(31, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');
%             obj.ec.addAnimalEvent(31, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');
%             obj.ec.addAnimalEvent(31, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');
%             obj.ec.addAnimalEvent(31, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');
%             obj.ec.addAnimalEvent(31, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');
%             obj.ec.addAnimalEvent(31, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');
%             obj.ec.addAnimalEvent(31, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');
%             obj.ec.addAnimalEvent(31, 'obj.motorCortex.turnDistance = 1; obj.motorCortex.clockwiseTurn();');
%             obj.ec.addAnimalEvent(26, 'obj.motorCortex.turnDistance = 30; obj.motorCortex.clockwiseTurn();');            
%             obj.ec.addAnimalEvent(58, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();'); 
%             obj.ec.addAnimalEvent(60, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');             
%             obj.ec.addAnimalEvent(62, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
%             obj.ec.addAnimalEvent(64, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
%             obj.ec.addAnimalEvent(66, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
%             obj.ec.addAnimalEvent(68, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
%             obj.ec.addAnimalEvent(70, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
%             obj.ec.addAnimalEvent(72, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
%             obj.ec.addAnimalEvent(74, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
        end
        function run(obj, steps)
            obj.ec.runHeadDirectionSystemForSteps(steps);            
        end
        function runAll(obj)
            obj.ec.runHeadDirectionSystem();            
        end
    end
end
