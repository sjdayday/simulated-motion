% Smaller grids, fewer head direction cells, two hashed place outputs
% copy S12, with separateMecLec = true; two hashed place outputs
% two cues only, and nFeatures = 1
% place match threshold from 2 to 1
% if 60 or 30, or 20 (maybe) HDS moves normally
% if 16, moves occasionally
% if 12, HDS doesn't move   
classdef S13 < handle 

    properties
        ec
    end
    methods 
        function obj = S13(visual)
            close all;
            obj.ec = ExperimentController();
            obj.ec.nHeadDirectionCells = 30;
            obj.ec.nCueIntervals = 30;
            obj.ec.gridSize=[6,5]; 
%             obj.ec.includeHeadDirectionFeatureInput = false;
            obj.ec.visualize(visual);
            obj.ec.pullVelocityFromAnimal = false;
            obj.ec.pullFeaturesFromAnimal = false;  % had missed this
            obj.ec.defaultFeatureDetectors = false; 
            obj.ec.updateFeatureDetectors = true; 
            obj.ec.settleToPlace = false;
            obj.ec.placeMatchThreshold = 1; % was 2  
            obj.ec.showHippocampalFormationECIndices = true; 
            obj.ec.sparseOrthogonalizingNetwork = true; 
            obj.ec.separateMecLec = true; 
            obj.ec.twoCuesOnly = true; 
            obj.ec.nFeatures = 1; 
            obj.ec.hdsPullsFeatureWeightsFromLec = true;
            obj.ec.build(); 
            if visual
                obj.ec.setupDisplay(); 
            end
            obj.ec.stepPause = 0;
            obj.ec.resetSeed = false; 
            obj.ec.totalSteps = 8; % 28
            obj.ec.addHeadDirectionSystemEvent(5, 'obj.minimumVelocity=pi/10;obj.initializeActivation(true);'); 
            obj.ec.addAnimalEvent(5, 'obj.minimumRunVelocity = 0.05; obj.minimumVelocity=pi/10'); 
%             obj.ec.addAnimalEvent(7, 'obj.orientAnimal(pi/3); obj.calculateVertices();'); 
            obj.ec.addAnimalEvent(8, 'obj.motorCortex.randomNavigation(40); ');
        end
        function run(obj, steps)
            obj.ec.runHeadDirectionSystemForSteps(steps);            
        end
        function runAll(obj)
            obj.ec.runHeadDirectionSystem();            
        end
    end
end
