%% ExperimentController class:  controller for ExperimentView
% invokes classes as requested through the ExperimentView GUI 
classdef ExperimentController < handle 

    properties
        chartSystem
        headDirectionSystem
        chartSystemPropertyMap
        headDirectionSystemPropertyMap
        nChartSystemSingleDimensionCells
        nHeadDirectionCells
        hFigures
        totalSteps
        currentStep
        resetSeed
        iteration
        statisticsHeader
        statisticsDetail
    end
    methods
        function obj = ExperimentController()
%             obj.hFigures = figure; 
            obj.nChartSystemSingleDimensionCells = 10;  % default
            obj.nHeadDirectionCells = 60;  %default
            obj.currentStep = 1; 
            obj.resetSeed = true; 
            obj.iteration = 0; 
            buildHeadDirectionSystem(obj, obj.nHeadDirectionCells);
            buildChartSystem(obj, obj.nChartSystemSingleDimensionCells);
            obj.headDirectionSystemPropertyMap = containers.Map(); 
            obj.chartSystemPropertyMap = containers.Map(); 
            buildChartSystemPropertyMap(obj);
            buildHeadDirectionSystemPropertyMap(obj);
            obj.statisticsHeader = {}; 
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
            obj.iteration = obj.iteration + 1; 
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
        function addHeadDirectionSystemProperty(obj, property)
            addSystemProperty(obj, obj.headDirectionSystemPropertyMap, ... 
                property, obj.headDirectionSystem); 
        end
        function addChartSystemProperty(obj, property)
            addSystemProperty(obj, obj.chartSystemPropertyMap, ... 
                property, obj.chartSystem); 
        end
        function addSystemProperty(obj, map, property, system) 
            map(property) = system.(property); 
            increment = [property,'.increment'];
            map(increment) = 1; 
            max = [property,'.max'];
            map(max) = system.(property); 
        end
        function value = getHeadDirectionSystemProperty(obj, property)
            value = getSystemProperty(obj, obj.headDirectionSystemPropertyMap, property);
        end
        function value = getChartSystemProperty(obj, property)
            value = getSystemProperty(obj, obj.chartSystemPropertyMap, property);
        end
        function value = getSystemProperty(obj, map, property) 
            value = map(property); 
        end
        function setChartSystemProperty(obj, property, value) 
            setSystemProperty(obj, obj.chartSystemPropertyMap, property, value); 
        end
        function setHeadDirectionSystemProperty(obj, property, value) 
            setSystemProperty(obj, obj.headDirectionSystemPropertyMap, property, value); 
        end
        % perhaps: map is property name:  obj.(map)(property) = value
        function setSystemProperty(obj, map, property, value) 
            map(property) = value; 
        end
        function updateSystemWithPropertyValue(obj, system, property, value)
            system.(property) = value;  
        end
        function updateChartSystemWithPropertyValue(obj, property, value)
            updateSystemWithPropertyValue(obj, obj.chartSystem, property, value); 
        end
 
        function buildHeadDirectionSystemPropertyMap(obj)
            addHeadDirectionSystemProperty(obj, 'alphaOffset');
            addHeadDirectionSystemProperty(obj, 'angularWeightOffset');
            addHeadDirectionSystemProperty(obj, 'betaGain');
            addHeadDirectionSystemProperty(obj, 'CInhibitionOffset');
            addHeadDirectionSystemProperty(obj, 'featureLearningRate');
            addHeadDirectionSystemProperty(obj, 'normalizedWeight');
            addHeadDirectionSystemProperty(obj, 'sigmaAngularWeight');
            addHeadDirectionSystemProperty(obj, 'sigmaHeadWeight');
        end
        function value = gCSP(obj, property)
            value = getSystemProperty(obj, obj.chartSystemPropertyMap, property);
        end
        function value = gCSPi(obj, property)
            value = getSystemProperty(obj, obj.chartSystemPropertyMap, [property,'.increment']);
        end
        function value = gCSPx(obj, property)
            value = getSystemProperty(obj, obj.chartSystemPropertyMap, [property,'.max']);
        end
        
        function iterateChartSystemForPropertyRanges(obj)
            obj.statisticsHeader = {'iteration', 'weightSum', 'maxActivation', ...
                'alphaOffset', ...
                'betaGain', 'CInhibitionOffset', 'featureLearningRate', ...
                'normalizedWeight', 'sigmaAngularWeight', 'sigmaHeadWeight', ... 
                'sigmaWeightPattern'}; 
            obj.statisticsDetail = zeros(1,11); 
            for aa = gCSP(obj, 'alphaOffset'):gCSPi(obj, 'alphaOffset'):gCSPx(obj, 'alphaOffset')
            for bb = gCSP(obj, 'betaGain'):gCSPi(obj, 'betaGain'):gCSPx(obj, 'betaGain')
            for cc = gCSP(obj, 'CInhibitionOffset'):gCSPi(obj, 'CInhibitionOffset'):gCSPx(obj, 'CInhibitionOffset')
            for dd = gCSP(obj, 'featureLearningRate'):gCSPi(obj, 'featureLearningRate'):gCSPx(obj, 'featureLearningRate')
            for ee = gCSP(obj, 'normalizedWeight'):gCSPi(obj, 'normalizedWeight'):gCSPx(obj, 'normalizedWeight')
            for ff = gCSP(obj, 'sigmaAngularWeight'):gCSPi(obj, 'sigmaAngularWeight'):gCSPx(obj, 'sigmaAngularWeight')
            for gg = gCSP(obj, 'sigmaHeadWeight'):gCSPi(obj, 'sigmaHeadWeight'):gCSPx(obj, 'sigmaHeadWeight')
            for hh = gCSP(obj, 'sigmaWeightPattern'):gCSPi(obj, 'sigmaWeightPattern'):gCSPx(obj, 'sigmaWeightPattern')
                rebuildChartSystem(obj); 
                updateChartSystemWithPropertyValue(obj, 'alphaOffset', aa); 
                updateChartSystemWithPropertyValue(obj, 'betaGain', bb); 
                updateChartSystemWithPropertyValue(obj, 'CInhibitionOffset', cc); 
                updateChartSystemWithPropertyValue(obj, 'featureLearningRate', dd); 
                updateChartSystemWithPropertyValue(obj, 'normalizedWeight', ee); 
                updateChartSystemWithPropertyValue(obj, 'sigmaAngularWeight', ff); 
                updateChartSystemWithPropertyValue(obj, 'sigmaHeadWeight', gg); 
                updateChartSystemWithPropertyValue(obj, 'sigmaWeightPattern', hh); 
                runChartSystem(obj); 
                weightPage = obj.chartSystem.wHeadDirectionWeights(:,:,1); 
                weightSum = sum(sum(weightPage)); 
                maxActivation = max(obj.chartSystem.uActivation); 
                obj.statisticsDetail(obj.iteration,:) = [obj.iteration, ...
                    weightSum, maxActivation, aa, bb, cc, dd, ee, ff, gg, hh]; 
                disp(obj.iteration); 
            end                
            end                
            end                
            end                
            end                
            end                
            end                
            end
        end
        function buildChartSystemPropertyMap(obj)
            addChartSystemProperty(obj, 'alphaOffset');
            addChartSystemProperty(obj, 'betaGain');
            addChartSystemProperty(obj, 'CInhibitionOffset');
            addChartSystemProperty(obj, 'featureLearningRate');
            addChartSystemProperty(obj, 'normalizedWeight');
            addChartSystemProperty(obj, 'sigmaAngularWeight');
            addChartSystemProperty(obj, 'sigmaHeadWeight'); 
            addChartSystemProperty(obj, 'sigmaWeightPattern');             
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
