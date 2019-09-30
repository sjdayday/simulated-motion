% System interface:  all systems implement System
classdef S6 < handle 

    properties
        ec
    end
    methods 
        function obj = S6(visual)
            close all;
            obj.ec = ExperimentController(); 
            obj.ec.visualize(visual);
            obj.ec.build(); 
            if visual
                obj.ec.setupDisplay(); 
            end
            obj.ec.stepPause = 0;
            obj.ec.resetSeed = false; 
            obj.ec.totalSteps = 40;
%             obj.ec.randomHeadDirection = false; % no effect?  
            obj.ec.addHeadDirectionSystemEvent(5, 'obj.minimumVelocity=pi/30;'); 
            obj.ec.addAnimalEvent(5, 'obj.minimumVelocity=pi/30; obj.minimumRunVelocity = 0.05; obj.showFeatures = 1; obj.features = [30 52];'); 
            obj.ec.addAnimalEvent(7, 'obj.showFeatures = 0; obj.features = [];'); 
            obj.ec.addHeadDirectionSystemEvent(10, 'obj.initializeActivation(true);'); 
            obj.ec.addAnimalEvent(10, 'obj.orientAnimal(pi/3); obj.calculateVertices();'); 
            obj.ec.addAnimalEvent(12, 'obj.motorCortex.runDistance = 6; obj.motorCortex.run();');             % obj.ec.addAnimalEvent(12, 'obj.turn(-1,1);'); 
%             obj.ec.addControllerEvent(11, 'disp(''animal physically placed at orientation pi/3, and randomly initializing internal head direction''); pause(10); ')
%             obj.ec.addHeadDirectionSystemEvent(10, 'obj.initializeActivation(true);'); 
            % obj.ec.addAnimalEvent(11, 'obj.hippocampalFormation.headDirectionSystem.clockwiseVelocity = -obj.minimumVelocity; obj.turn(-1,1);');
%             obj.ec.addAnimalEvent(20, 'obj.hippocampalFormation.headDirectionSystem.clockwiseVelocity = -obj.minimumVelocity;'); 
            obj.ec.addAnimalEvent(21, 'obj.motorCortex.turnDistance = 10; obj.motorCortex.clockwiseTurn();');             % obj.ec.addAnimalEvent(12, 'obj.turn(-1,1);'); 
%             obj.ec.addAnimalEvent(12, 'obj.hippocampalFormation.headDirectionSystem.clockwiseVelocity = -obj.minimumVelocity; obj.motorCortex.moveDistance = 10; obj.motorCortex.clockwiseTurn();'); 
            % obj.ec.addAnimalEvent(13, 'obj.turn(-1,1);'); 
            % obj.ec.addAnimalEvent(14, 'obj.turn(-1,1);'); 
%             obj.ec.addControllerEvent(12, 'disp(''animal orienting in new environment, so turning clockwise, stopping (conveniently) at orientation 0.''); pause(10); ')
%             obj.ec.addControllerEvent(25, 'disp(''now in physical orientation where features are detectable; internal head direction should adjust.''); pause(10); ')
%              obj.ec.addAnimalEvent(29, 'obj.hippocampalFormation.headDirectionSystem.clockwiseVelocity = 0; obj.clockwiseVelocity = 0'); 
            obj.ec.addAnimalEvent(30, 'obj.showFeatures = 1; obj.features = [30 52];'); 
            obj.ec.addHeadDirectionSystemEvent(30, 'obj.readMode = 1;');
%             obj.ec.addControllerEvent(40, 'disp(''about to run 2''); pause(10); ')
            obj.ec.addAnimalEvent(39, 'obj.showFeatures = 0; obj.features = [];'); 
            obj.ec.addAnimalEvent(40, 'obj.motorCortex.runDistance = 4; obj.motorCortex.run();'); 
            obj.ec.addHeadDirectionSystemEvent(40, 'obj.readMode = 0;');
            obj.ec.addHeadDirectionSystemEvent(41, 'obj.readMode = 0;');            
%              obj.ec.addAnimalEvent(40, 'obj.hippocampalFormation.headDirectionSystem.clockwiseVelocity = -obj.minimumVelocity;');            
%              obj.ec.addControllerEvent(41, 'disp(''did not just changed HDS velocity''); pause(10); ')
            obj.ec.addAnimalEvent(50, 'obj.motorCortex.turnDistance = 12; obj.motorCortex.clockwiseTurn();');
            obj.ec.addAnimalEvent(70, 'obj.motorCortex.runDistance = 20; obj.motorCortex.run();'); 
        end
        function run(obj, steps)
            obj.ec.runHeadDirectionSystemForSteps(steps);            
        end
        function runAll(obj)
            obj.ec.runHeadDirectionSystem();            
        end
    end
end
