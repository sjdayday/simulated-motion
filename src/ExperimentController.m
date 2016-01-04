%% ExperimentController class:  controller for ExperimentView
% invokes classes as requested through the ExperimentView GUI 
classdef ExperimentController < handle 

    properties
        chartSystem
        headDirectionSystem
        nChartSystemSingleDimensionCells
        nHeadDirectionCells
        hFigures
        totalSteps
        currentStep
        resetSeed
    end
    methods
        function obj = ExperimentController()
%             obj.hFigures = figure; 
            obj.nChartSystemSingleDimensionCells = 10;  % default
            obj.nHeadDirectionCells = 60;  %default
            obj.currentStep = 1; 
            obj.resetSeed = true; 
            buildHeadDirectionSystem(obj, obj.nHeadDirectionCells);
            buildChartSystem(obj, obj.nChartSystemSingleDimensionCells);
        end
        function resetRandomSeed(obj, reset)
            obj.resetSeed = reset; 
        end
        function buildHeadDirectionSystem(obj, nHeadDirectionCells)
            obj.nHeadDirectionCells = nHeadDirectionCells;
            rebuildHeadDirectionSystem(obj); 
        end
        function rebuildHeadDirectionSystem(obj) 
           obj.headDirectionSystem = HeadDirectionSystem(obj.nHeadDirectionCells); 
        end
        function buildChartSystem(obj, nChartSystemSingleDimensionCells)
            obj.nChartSystemSingleDimensionCells = nChartSystemSingleDimensionCells;
            rebuildChartSystem(obj);
        end
        function rebuildChartSystem(obj) 
            obj.chartSystem = ChartSystem(obj.nChartSystemSingleDimensionCells); 
        end
        function runHeadDirectionSystem(obj)
            rebuildHeadDirectionSystem(obj);
            runSystem(obj,obj.headDirectionSystem); 
        end
        function runChartSystem(obj)
            rebuildChartSystem(obj);
            runSystem(obj,obj.chartSystem); 
        end
        function runSystem(obj, system)
            system.buildWeights(); 
            obj.currentStep = 1;             
            runBareSystem(obj, system); 
        end
        function runBareSystem(obj, system)
            if obj.resetSeed
               load '../rngDefaultSettings';
               rng(rngDefault);    
            end
            for ii = obj.currentStep:obj.totalSteps
               system.step(); 
               obj.currentStep = obj.currentStep + 1; 
            end                        
        end
        function continueHeadDirectionSystem(obj)
            if obj.currentStep == 1
                runHeadDirectionSystem(obj);
            else
                runBareSystem(obj,obj.headDirectionSystem);             
            end
        end
        function continueChartSystem(obj)
            if obj.currentStep == 1
                runChartSystem(obj);
            else
                runBareSystem(obj,obj.chartSystem);             
            end
        end
        function plot(obj)
            if obj.firstPlot
                obj.h = figure('color','w');
                drawnow
                obj.firstPlot = 0;
            end
            figure(obj.h);
            % plot the smoothed activation before we stretch it
%             plot(obj.xAxisValues, [obj.activationBeforeStabilization obj.activationBeforeStabilization]);
            surf(obj.uActivation); 
            view(45,45); 
%             plot(obj.xAxisValues, [obj.uActivation obj.uActivation]); 
% %             plot(obj.xAxisValues, repmat(obj.activation,[1 2]));
%             obj.xAxis = gca; 
%             % these values only work if nSingleDimensionCells is 60
%             obj.xAxis.XTick = [0 15 30 45 60 75 90 105 120];
%             obj.xAxis.XTickLabel = ... 
%                 {'-2\pi', '-3\pi/2', '-\pi', '-\pi/2', '0', '\pi/2', '\pi', '3\pi/2', '2\pi'};
% %                 {'-360', '-270', '-180', '-90', '0', '90', '180', '270', '360'};
%             title({'Head direction',sprintf('time = %d ',obj.time)});
%             subplot(131);
%             imagesc(reshape(obj.activation,obj.nY,obj.nX));
%             axis square
%             title('Population activity')
%             set(gca,'ydir','normal')
%             subplot(132);
%             imagesc(obj.spikes./obj.occupancy);
%             axis square
%             set(gca,'ydir','normal')
%             t = obj.time*obj.dt; 
%             title({sprintf('t = %.1f ms',t),'Rate map'})
%             subplot(133);
%             plot(obj.position(1,1:obj.time),obj.position(2,1:obj.time));
%             hold on;
%             if ~isempty(obj.spikeCoords)
%             plot(obj.spikeCoords(2:obj.spikeind,1), ... 
%             obj.spikeCoords(2:obj.spikeind,2),'r.')
%             end
%             title({'Trajectory (blue)','and spikes (red)'})
%             axis square
            drawnow
        end        
    end
end
