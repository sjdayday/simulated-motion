% System interface:  all systems implement System
classdef S4 < handle 

    properties
        ec
    end
    methods 
        function obj = S4()
            close all;
            obj.ec = ExperimentController(); 
            obj.ec.visualize(true);
            obj.ec.build(); 

            obj.ec.setupDisplay(); 
            obj.ec.stepPause = 0.5;
            obj.ec.resetSeed = false; 
            obj.ec.totalSteps = 40;
            obj.ec.randomHeadDirection = false;
            obj.ec.addAnimalEvent(5, 'obj.minimumVelocity=pi/20; obj.showFeatures = 1; obj.features = [30 52];'); 
            obj.ec.addAnimalEvent(7, 'obj.showFeatures = 0; obj.features = [];'); 
            obj.ec.addHeadDirectionSystemEvent(10, 'obj.initializeActivation(true);'); 
            obj.ec.addAnimalEvent(10, 'obj.orientAnimal(pi/4); obj.calculateVertices();'); 
            % obj.ec.addControllerEvent(10, 'disp(''animal physically moved to orientation pi/4, and randomly initializing internal head direction''); pause(10); ')
%             obj.ec.addHeadDirectionSystemEvent(10, 'obj.initializeActivation(true);'); 
            % obj.ec.addAnimalEvent(11, 'obj.hippocampalFormation.headDirectionSystem.clockwiseVelocity = -obj.minimumVelocity; obj.turn(-1,1);');
            obj.ec.addAnimalEvent(12, 'obj.hippocampalFormation.headDirectionSystem.clockwiseVelocity = -obj.minimumVelocity; obj.motorCortex.moveDistance = 10; obj.motorCortex.clockwiseTurn();'); 
            % obj.ec.addAnimalEvent(12, 'obj.turn(-1,1);'); 
            % obj.ec.addAnimalEvent(13, 'obj.turn(-1,1);'); 
            % obj.ec.addAnimalEvent(14, 'obj.turn(-1,1);'); 
            % obj.ec.addControllerEvent(11, 'disp(''animal orienting in new environment, so turning clockwise, stopping (conveniently) at orientation 0.''); pause(10); ')
            % obj.ec.addControllerEvent(15, 'disp(''now in physical orientation where features are detectable; internal head direction should adjust.''); pause(10); ')
            obj.ec.addAnimalEvent(25, 'obj.showFeatures = 1; obj.features = [30 52]; obj.hippocampalFormation.headDirectionSystem.clockwiseVelocity = 0; obj.clockwiseVelocity = 0'); 
            obj.ec.addHeadDirectionSystemEvent(25, 'obj.readMode = 1;'); 
        end
        function run(obj, steps)
            obj.ec.runHeadDirectionSystemForSteps(steps);            
        end
        function runAll(obj)
            obj.ec.runHeadDirectionSystem();            
        end
    end
end
