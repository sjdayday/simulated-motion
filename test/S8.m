% System interface:  all systems implement System
classdef S8 < handle 

    properties
        ec
    end
    methods 
        function obj = S8()
            close all;
            obj.ec = ExperimentController(); 
            obj.ec.visualize(true);
            obj.ec.pullVelocityFromAnimal = false;
            obj.ec.defaultFeatureDetectors = false; 
            obj.ec.updateFeatureDetectors = true; 
            obj.ec.settleToPlace = false;
            obj.ec.showHippocampalFormationECIndices = true; 
            obj.ec.build(); 
            
            obj.ec.setupDisplay(); 
            obj.ec.stepPause = 0;
            obj.ec.resetSeed = false; 
            forced = HeadDirectionSystemForced(60); 
            forced.build();
            obj.ec.rebuildHeadDirectionSystemFlag = false; 
            obj.ec.animal.hippocampalFormation.headDirectionSystem = forced; 

            obj.ec.totalSteps = 30; % 28
%             obj.ec.randomHeadDirection = false; % no effect?  
%             obj.ec.addControllerEvent(10, 'disp(''force HDS activation''); pause(10); ');
            obj.ec.addHeadDirectionSystemEvent(5, 'obj.minimumVelocity=pi/30;obj.initializeActivation(true);'); 
            obj.ec.addAnimalEvent(5, 'obj.minimumVelocity=pi/30; obj.minimumRunVelocity = 0.05;'); 
            obj.ec.addAnimalEvent(7, 'obj.orientAnimal(pi/3); obj.calculateVertices();'); 
            obj.ec.addHeadDirectionSystemEvent(8, 'obj.forceActivation(10);'); 
            obj.ec.addAnimalEvent(8, 'obj.hippocampalFormation.settleToPlace = true; ');
            obj.ec.addAnimalEvent(9, 'obj.hippocampalFormation.settleToPlace = true; ');
%             obj.ec.addControllerEvent(9, 'disp(''force HDS activation''); pause(10); ');            
%             obj.ec.addHeadDirectionSystemEvent(25, 'obj.animal.hippocampalFormation.headDirectionSystem.uActivation = zeros(1,60);obj.animal.hippocampalFormation.headDirectionSystem.uActivation(10) = 1;');             
%             obj.ec.addControllerEvent(26, 'disp(''force animal HDS activation''); pause(10); ');
%             obj.ec.addControllerEvent(27, 'disp(''force2 animal HDS activation''); pause(10); ');            
%             obj.ec.addAnimalEvent(8, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();'); 
            obj.ec.addAnimalEvent(10, 'obj.motorCortex.runDistance = 7; obj.motorCortex.run();');             
%             obj.ec.addAnimalEvent(12, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
% %             obj.ec.addAnimalEvent(12, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();  obj.hippocampalFormation.settleToPlace = true; ');            obj.ec.addAnimalEvent(14, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
%             obj.ec.addAnimalEvent(16, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
%             obj.ec.addAnimalEvent(18, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
%             obj.ec.addAnimalEvent(20, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
%             obj.ec.addAnimalEvent(22, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
%             obj.ec.addAnimalEvent(24, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(28, 'obj.motorCortex.turnDistance = 30; obj.motorCortex.clockwiseTurn();');            
            obj.ec.addHeadDirectionSystemEvent(26, 'obj.forceActivation(40);'); 
%             obj.ec.addControllerEvent(27, 'disp(''force HDS activation''); pause(10); ');
            obj.ec.addAnimalEvent(58, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();'); 
            obj.ec.addAnimalEvent(60, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');             
            obj.ec.addAnimalEvent(62, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(64, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(66, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(68, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(70, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(72, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
            obj.ec.addAnimalEvent(74, 'obj.motorCortex.runDistance = 1; obj.motorCortex.run();');
        end
        function run(obj, steps)
            obj.ec.runHeadDirectionSystemForSteps(steps);            
        end
        function runAll(obj)
            obj.ec.runHeadDirectionSystem();            
        end
    end
end
