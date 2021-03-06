% System interface:  all systems implement System
classdef S11 < handle 

    properties
        ec
    end
    methods 
        function obj = S11(visual)
            close all;
            obj.ec = ExperimentController(); 
            obj.ec.visualize(visual);
            obj.ec.pullVelocityFromAnimal = false;
            obj.ec.defaultFeatureDetectors = false; 
            obj.ec.updateFeatureDetectors = true; 
%             obj.ec.includeHeadDirectionFeatureInput = false;
            obj.ec.settleToPlace = false;
            obj.ec.placeMatchThreshold = 2;
            obj.ec.showHippocampalFormationECIndices = true; 
            obj.ec.build(); 
            if visual
                obj.ec.setupDisplay(); 
            end
            obj.ec.stepPause = 0;
            obj.ec.resetSeed = false; 
            obj.ec.totalSteps = 100; % 28
            obj.ec.addHeadDirectionSystemEvent(5, 'obj.minimumVelocity=pi/30;obj.initializeActivation(true);'); 
            obj.ec.addAnimalEvent(5, 'obj.minimumRunVelocity = 0.05;'); 
%             obj.ec.addAnimalEvent(7, 'obj.orientAnimal(pi/3); obj.calculateVertices();'); 
            obj.ec.addAnimalEvent(8, 'obj.motorCortex.randomNavigation(1200); ');
        end
        function run(obj, steps)
            obj.ec.runHeadDirectionSystemForSteps(steps);            
        end
        function runAll(obj)
            obj.ec.runHeadDirectionSystem();            
        end
    end
end
