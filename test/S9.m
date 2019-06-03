% System interface:  all systems implement System
% This compresses out the steps between runs, but doesn't work correctly:
% display doesn't update between runs.  
% not likely to be useful until step & time processing in EC are reconciled

classdef S9 < handle 

    properties
        ec
    end
    methods 
        function obj = S9()
            close all;
            obj.ec = ExperimentController(); 
            obj.ec.visualize(true);
            obj.ec.pullVelocityFromAnimal = false;
            obj.ec.defaultFeatureDetectors = false; 
            obj.ec.updateFeatureDetectors = true; 
            obj.ec.build(); 
            obj.ec.setupDisplay(); 
            obj.ec.stepPause = 0;
            obj.ec.resetSeed = false; 
            obj.ec.totalSteps = 18;
%             obj.ec.randomHeadDirection = false; % no effect?  
            obj.ec.addHeadDirectionSystemEvent(5, 'obj.minimumVelocity=pi/30;obj.initializeActivation(true);'); 
            obj.ec.addAnimalEvent(5, 'obj.minimumVelocity=pi/30; obj.minimumRunVelocity = 0.05;'); 
            obj.ec.addAnimalEvent(7, 'obj.orientAnimal(pi/3); obj.calculateVertices();'); 
            obj.ec.addAnimalEvent(8, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();'); 
            obj.ec.addAnimalEvent(10, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');             
            obj.ec.addAnimalEvent(11, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(12, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(13, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(14, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(15, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(16, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(17, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
%             obj.ec.addHeadDirectionSystemEvent(20, 'obj.initializeActivation(true);');  
            obj.ec.addAnimalEvent(18, 'obj.motorCortex.turnDistance = 30; obj.motorCortex.clockwiseTurn();');            
            obj.ec.addAnimalEvent(39, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();'); 
            obj.ec.addAnimalEvent(40, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');             
            obj.ec.addAnimalEvent(41, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(42, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(43, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(44, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(45, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(46, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(47, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
        end
        function run(obj, steps)
            obj.ec.runHeadDirectionSystemForSteps(steps);            
        end
        function runAll(obj)
            obj.ec.runHeadDirectionSystem();            
        end
    end
end
