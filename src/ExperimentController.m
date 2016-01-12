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
        chartStatisticsHeader
        chartStatisticsDetail
        nChartStats
        animal
        visual
        h
        monitor
        x
        y
        yy
        randomHeadDirection
        stepPause
    end
    methods
        function obj = ExperimentController()
%             obj.hFigures = figure; 
            obj.nChartSystemSingleDimensionCells = 10;  % default
            obj.nHeadDirectionCells = 60;  %default
            obj.currentStep = 1; 
            obj.resetSeed = true; 
            obj.iteration = 0; 
            obj.nChartStats = 6;
            buildHeadDirectionSystem(obj, obj.nHeadDirectionCells);
            buildChartSystem(obj, obj.nChartSystemSingleDimensionCells);
            obj.headDirectionSystemPropertyMap = containers.Map(); 
            obj.chartSystemPropertyMap = containers.Map(); 
            buildChartSystemPropertyMap(obj);
            buildHeadDirectionSystemPropertyMap(obj);
            obj.chartStatisticsHeader = {}; 
            obj.animal = Animal(); 
            obj.visual = false; 
            obj.monitor = false; 
            obj.randomHeadDirection = true; 
            obj.stepPause = 0.1; 
        end
        function resetRandomSeed(obj, reset)
            obj.resetSeed = reset; 
        end
        function visualize(obj, visual)
            obj.visual = visual; 
            if visual
                obj.h = figure; 
                obj.chartSystem.h = obj.h;
                obj.headDirectionSystem.h = obj.h; 
                obj.animal.h = obj.h; 
%                 setupDisplay(obj);  % do later
            else
                if isvalid(obj.h) 
                    close(obj.h)
                end
            end
        end
        function buildHeadDirectionSystem(obj, nHeadDirectionCells)
            obj.nHeadDirectionCells = nHeadDirectionCells;
            rebuildHeadDirectionSystem(obj); 
        end
        function rebuildHeadDirectionSystem(obj) 
            obj.headDirectionSystem = HeadDirectionSystem(obj.nHeadDirectionCells);
            obj.headDirectionSystem.animal = obj.animal; 
            obj.headDirectionSystem.initializeActivation(obj.randomHeadDirection); 
            if obj.visual
                obj.headDirectionSystem.h = obj.h; 
            end
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
            if obj.resetSeed
               load '../rngDefaultSettings';
               rng(rngDefault);    
            end
            system.buildWeights(); 
            obj.currentStep = 1;             
            runBareSystem(obj, system); 
        end
        function step(obj, system)
           system.step();
           obj.animal.step(); 
           obj.currentStep = obj.currentStep + 1; 
           if obj.visual
               plot(obj);  
               pause(obj.stepPause); 
           end            
        end
        function runBareSystem(obj, system)
            for ii = obj.currentStep:obj.totalSteps
                step(obj, system); 
%                system.step();
%                obj.animal.step(); 
%                obj.currentStep = obj.currentStep + 1; 
%                if obj.visual
%                    plot(obj);  
%                    pause(0.1); 
%                end
            end
            obj.iteration = obj.iteration + 1;
            if obj.monitor
                disp([obj.iteration length(obj.chartStatisticsDetail)]); 
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
        function addHeadDirectionSystemProperty(obj, property)
            addSystemProperty(obj, obj.headDirectionSystemPropertyMap, ... 
                property, obj.headDirectionSystem); 
        end
        function addChartSystemProperty(obj, property)
            addSystemProperty(obj, obj.chartSystemPropertyMap, ... 
                property, obj.chartSystem); 
        end
        function addSystemProperty(obj, map, property, system) 
            setSystemProperties(obj, map, property, system.(property)); 
        end
        function setSystemProperties(obj, map, property, value) 
            map(property) = value; 
            increment = [property,'.increment'];
            map(increment) = 1; 
            max = [property,'.max'];
            map(max) = value; 
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
        function addEvent(obj, system, time, event)
            system.addEvent(time, event); 
        end
        function addHeadDirectionSystemEvent(obj, time, event)
           obj.headDirectionSystem.addEvent(time, event); 
        end
        function addChartSystemEvent(obj, time, event)
           obj.chartSystem.addEvent(time, event); 
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
        function rerunChartSystem(obj, record)
            setSystemProperties(obj, obj.chartSystemPropertyMap, 'alphaOffset', record(1,obj.nChartStats+1)); 
            setSystemProperties(obj, obj.chartSystemPropertyMap, 'betaGain', record(1,obj.nChartStats+2)); 
            setSystemProperties(obj, obj.chartSystemPropertyMap, 'CInhibitionOffset', record(1,obj.nChartStats+3)); 
            setSystemProperties(obj, obj.chartSystemPropertyMap, 'featureLearningRate', record(1,obj.nChartStats+4)); 
            setSystemProperties(obj, obj.chartSystemPropertyMap, 'normalizedWeight', record(1,obj.nChartStats+5)); 
            setSystemProperties(obj, obj.chartSystemPropertyMap, 'sigmaAngularWeight', record(1,obj.nChartStats+6)); 
            setSystemProperties(obj, obj.chartSystemPropertyMap, 'sigmaHeadWeight', record(1,obj.nChartStats+7)); 
            setSystemProperties(obj, obj.chartSystemPropertyMap, 'sigmaWeightPattern', record(1,obj.nChartStats+8));
            iterateChartSystemForPropertyRanges(obj);
        end

        function iterateChartSystemForPropertyRanges(obj)
            obj.chartStatisticsHeader = {'iteration', 'weightSum', 'maxActivation', ... 
                'deltaMaxMin', 'numMax', 'maxSlope', 'alphaOffset', ...
                'betaGain', 'CInhibitionOffset', 'featureLearningRate', ...
                'normalizedWeight', 'sigmaAngularWeight', 'sigmaHeadWeight', ... 
                'sigmaWeightPattern'}; 
            obj.chartStatisticsDetail = zeros(1,obj.nChartStats+8); 
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
                runSystem(obj,obj.chartSystem); % runChartSystem(obj) forces rebuild
                weightPage = obj.chartSystem.wHeadDirectionWeights(:,:,1); 
                weightSum = sum(sum(weightPage)); 
                maxActivation = max(max(obj.chartSystem.uActivation)); 
                minActivation = min(min(obj.chartSystem.uActivation)); 
                deltaMaxMin = maxActivation - minActivation;  
                [numMax , maxSlope] = obj.chartSystem.getMetrics(); 
                obj.chartStatisticsDetail(obj.iteration,:) = [obj.iteration, ...
                    weightSum, maxActivation, deltaMaxMin, numMax, maxSlope, aa, bb, cc, dd, ee, ff, gg, hh]; 
                tempDetail = obj.chartStatisticsDetail;
                save 'detail50' tempDetail; 
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
        function setupDisplay(obj)
            figure(obj.h); 
            hold on;  
            obj.x = -1.1:.01:1.1;
            obj.y = zeros(1,221); 
            for ii = 1:length(obj.x)
                obj.y(1,ii) = abs(sqrt(1.21 - obj.x(1,ii)^2));
            end;
            obj.yy = -obj.y;
            subplot(221);
            hold on; 
            title({'Physical head direction ',sprintf('t = %d',obj.currentStep)})
            p = plot(obj.x,obj.y,obj.x,obj.yy);
            axis equal
            axis off
            p(1).LineWidth = 5;
            p(2).LineWidth = 5;
            p(2).Color = [0.5 0.5 0.5];
            p(1).Color = [0.5 0.5 0.5];
            subplot(222);
            hold on 
            title({'Internal head direction ',sprintf('t = %d',obj.currentStep)})
%             title('Internal head direction');
            q = plot(obj.x,obj.y,obj.x,obj.yy);
            plot(.9192,.9192, ...
                'o','MarkerFaceColor','blue','MarkerSize',5,'MarkerEdgeColor','blue');
            plot(-1.3,0, ...
                'o','MarkerFaceColor','blue','MarkerSize',5,'MarkerEdgeColor','blue');
            axis equal
            axis off
            q(1).LineWidth = 5;
            q(2).LineWidth = 5;
            q(2).Color = [0.5 0.5 0.5];
            q(1).Color = [0.5 0.5 0.5];
            
            drawnow
        end
        function plot(obj)
%             if obj.firstPlot
%                 obj.h = figure('color','w');
%                 drawnow
%                 obj.firstPlot = 0;
%             end
            figure(obj.h);
            subplot(221);
            title({'Physical head direction ',sprintf('t = %d',obj.currentStep)})
            obj.animal.plot(); 
            subplot(222);
            title({'Internal head direction ',sprintf('t = %d',obj.currentStep)})
            obj.headDirectionSystem.plotCircle(); 
            subplot(224);
            obj.headDirectionSystem.plotActivation(); 
            hold on; 
            title({'Head direction activation',sprintf('t = %d',obj.currentStep)})
            
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
