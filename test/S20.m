% multiple scenarios 
% copy S14
classdef S20 < handle 

    properties
        ec
    end
    methods 
        function obj = S20(visual)
            close all;
            obj.ec = ExperimentController(); 
            obj.ec.report = true; 
            obj.ec.reportTag = '0123EF456';
            obj.ec.reportPipeTag = 'v1.2.1'; 
            obj.ec.reportFilepath =  '../test/logs/';
%             formattedDateTime = char(datetime(2020,1,19,16,0,55, 'Format','yyyy-MM-dd--HH-mm-ss')); 
%             obj.ec.reportFormattedDateTime = formattedDateTime;
%             obj.ec.cleanReporterFilesForTesting = true;
            obj.ec.nHeadDirectionCells = 30;
            obj.ec.nCueIntervals = 30;
            obj.ec.gridSize=[6,5]; 
            obj.ec.visualize(false);
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
            obj.ec.keepRunnerForReporting = true; % monitor for very large runs 
            obj.ec.hdsMinimumVelocity = pi/10; 
            obj.ec.minimumRunVelocity = 0.05; 
            obj.ec.minimumTurnVelocity=pi/10;
            obj.ec.build(); 
            obj.ec.stepPause = 0;
            obj.ec.resetSeed = false; 
%             obj.ec.runScenarios(1, 3000); 
% %             obj.ec.totalSteps = 10; % 28
            disp(obj.ec.environment.showGridSquares()); 
            
%             obj.ec = ExperimentController();
%             obj.ec.nHeadDirectionCells = 30;
%             obj.ec.nCueIntervals = 30;
%             obj.ec.gridSize=[6,5]; 
% %             obj.ec.includeHeadDirectionFeatureInput = false;
%             obj.ec.visualize(visual);
%             obj.ec.pullVelocityFromAnimal = false;
%             obj.ec.pullFeaturesFromAnimal = false;  % had missed this
%             obj.ec.defaultFeatureDetectors = false; 
%             obj.ec.updateFeatureDetectors = true; 
%             obj.ec.settleToPlace = false;
%             obj.ec.placeMatchThreshold = 1; % was 2  
%             obj.ec.showHippocampalFormationECIndices = true; 
%             obj.ec.sparseOrthogonalizingNetwork = true; 
%             obj.ec.separateMecLec = true; 
%             obj.ec.twoCuesOnly = true; 
%             obj.ec.nFeatures = 1; 
%             obj.ec.hdsPullsFeatureWeightsFromLec = true;
%             obj.ec.keepRunnerForReporting = true; % monitor for very large runs 
%             obj.ec.hdsMinimumVelocity = pi/10; 
%             obj.ec.minimumRunVelocity = 0.05; 
%             obj.ec.minimumTurnVelocity=pi/10;
%             obj.ec.build(); 
%             if visual
%                 obj.ec.setupDisplay(); 
%             end
%             obj.ec.stepPause = 0;
%             obj.ec.resetSeed = false; 
%             obj.ec.totalSteps = 10; % 28
%             obj.ec.addHeadDirectionSystemEvent(5, 'obj.initializeActivation(true);'); 
% %             obj.ec.addHeadDirectionSystemEvent(5, 'obj.minimumVelocity=pi/10;obj.initializeActivation(true);');             
% %             obj.ec.addAnimalEvent(5, 'obj.minimumRunVelocity = 0.05; obj.minimumVelocity=pi/10'); 
% %             obj.ec.addAnimalEvent(7, 'obj.orientAnimal(pi/3); obj.calculateVertices();'); 
%             obj.ec.addAnimalEvent(7, 'obj.motorCortex.prepareNavigate(); ');
%             obj.ec.addAnimalEvent(8, 'obj.motorCortex.navigate(10); ');            
        end
        function run(obj, steps)
%             obj.ec.runHeadDirectionSystemForSteps(steps);            
        end
        function runAll(obj)
            obj.ec.runScenarios(1, 30); 
            disp(obj.ec.environment.showGridSquares()); 
%             obj.ec.runHeadDirectionSystem();            
        end
    end
end
