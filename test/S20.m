% multiple scenarios 
% copy S14
classdef S20 < handle 

    properties
        ec
    end
    methods 
        function runAll(obj)
%             obj.flavors(2, 2, 1, true, true); 
%             obj.flavors(2, 4, 1, true, true); 
%             obj.flavors(2, 6, 1, true, true);             
%             obj.flavors(2, 2, 2, true, true); 
%             obj.flavors(2, 4, 2, true, true); 
%             obj.flavors(2, 6, 2, true, true);             
%             obj.flavors(2, 2, 3, true, true); 
%             obj.flavors(2, 4, 3, true, true); 
%             obj.flavors(2, 6, 3, true, true);             
%             obj.flavors(2, 2, 1, false, true); 
%             obj.flavors(2, 4, 1, false, true); 
%             obj.flavors(2, 6, 1, false, true);             
%             obj.flavors(2, 2, 2, false, true); 
%             obj.flavors(2, 4, 2, false, true); 
%             obj.flavors(2, 6, 2, false, true);             
%             obj.flavors(2, 2, 3, false, true); 
%             obj.flavors(2, 4, 3, false, true); 
%             obj.flavors(2, 6, 3, false, true);             
%             obj.flavors(2, 2, 1, true, false); 
%             obj.flavors(2, 4, 1, true, false); 
%             obj.flavors(2, 6, 1, true, false);             
%             obj.flavors(2, 2, 2, true, false); 
%             obj.flavors(2, 4, 2, true, false); 
%             obj.flavors(2, 6, 2, true, false);             
%             obj.flavors(2, 2, 3, true, false); 
%             obj.flavors(2, 4, 3, true, false); 
%             obj.flavors(2, 6, 3, true, false);             
            obj.flavors(2, 2, 1, false, false); 
            obj.flavors(2, 4, 1, false, false); 
            obj.flavors(2, 6, 1, false, false);             
            obj.flavors(2, 2, 2, false, false); 
            obj.flavors(2, 4, 2, false, false); 
            obj.flavors(2, 6, 2, false, false);             
            obj.flavors(2, 2, 3, false, false); 
            obj.flavors(2, 4, 3, false, false); 
            obj.flavors(2, 6, 3, false, false);             

%             obj.ec.sparseOrthogonalizingNetwork = true; 
%             obj.ec.ripples = 6;
%             obj.ec.nGridGains = 2; % x 2 = grids
% %             obj.ec.nHeadDirectionCells = 60;
% %             obj.ec.nCueIntervals = 60;
% %             obj.ec.hdsMinimumVelocity = pi/30; 
% %             obj.ec.minimumTurnVelocity=pi/30;
%             nextScenario = 1; % > 1 is restart after previous problem  
%             lastScenario = 1; 
%             obj.ec.runScenarios(nextScenario, lastScenario, 3000); 
%             disp(obj.ec.environment.showGridSquares()); 
        end        
        function flavors(obj, last, ripples, gains, sparse, moreCells)
            obj.buildController(); 
            obj.ec.sparseOrthogonalizingNetwork = sparse; 
            obj.ec.ripples = ripples;
            obj.ec.nGridGains = gains; % x 2 = grids
            if moreCells
                obj.ec.nHeadDirectionCells = 60;
                obj.ec.nCueIntervals = 60;
                obj.ec.hdsMinimumVelocity = pi/30; 
                obj.ec.minimumTurnVelocity=pi/30;                
            end
            nextScenario = 1; % > 1 is restart after previous problem  
            lastScenario = last; 
            obj.ec.runScenarios(nextScenario, lastScenario, 3000); 
            disp(obj.ec.environment.showGridSquares()); 
        end
        function buildController(obj)
            close all;
            obj.ec = ExperimentController(); 
            obj.ec.scenarioDelay = 5; % 5 seconds between delays to avoid NPE between PetriNetRunner threads
            obj.ec.report = true; 
            obj.ec.reportTag = 'v1.0.6';
            obj.ec.reportPipeTag = 'pipe-core--2.0.0'; 
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
            obj.ec.hdsMinimumVelocity = pi/15; 
            obj.ec.minimumRunVelocity = 0.05; 
            obj.ec.minimumTurnVelocity=pi/15;
            obj.ec.build(); 
            obj.ec.stepPause = 0;
            obj.ec.resetSeed = false; 
%             obj.ec.runScenarios(1, 3000); 
% %             obj.ec.totalSteps = 10; % 28
            disp(obj.ec.environment.showGridSquares()); 
            
        end
        function obj = S20()
            obj.buildController(); 
        end
        function run(obj, steps)
%             obj.ec.runHeadDirectionSystemForSteps(steps);            
        end
%         function runAll(obj)
%             % sparse placeID = 0; 
%             obj.ec.ripples = 6; % 2 mecoutput;  3 = 6 mecoutput 
%             nextScenario = 1; 
%             lastScenario = 1; 
%             obj.ec.runScenarios(nextScenario, lastScenario, 100); 
%             disp(obj.ec.environment.showGridSquares());  
%         end
%         function runAll(obj)
%             % sparse placeID = 0; 
%             obj.ec.nGridGains = 1; % 2 mecoutput;  3 = 6 mecoutput 
%             nextScenario = 1; 
%             lastScenario = 1; 
%             obj.ec.runScenarios(nextScenario, lastScenario, 30); 
%             disp(obj.ec.environment.showGridSquares());  
%         end
%         function runAll(obj)
%             % sparse placeID = 0; 
%             obj.ec.sparseOrthogonalizingNetwork = false; 
%             nextScenario = 1; 
%             lastScenario = 1; 
%             obj.ec.runScenarios(nextScenario, lastScenario, 3000); 
%             disp(obj.ec.environment.showGridSquares());  
%         end
%         function runAll(obj)
%             % headDirectionCells = 60 
%             obj.ec.nHeadDirectionCells = 60;
%             obj.ec.nCueIntervals = 60;
%             obj.ec.hdsMinimumVelocity = pi/30; 
%             obj.ec.minimumTurnVelocity=pi/30;
% 
%             nextScenario = 1; 
%             lastScenario = 1; 
%             obj.ec.runScenarios(nextScenario, lastScenario, 3000); 
%             disp(obj.ec.environment.showGridSquares());     
%         end
    end
end
