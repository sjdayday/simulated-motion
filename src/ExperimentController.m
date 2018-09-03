%% ExperimentController class:  controller for ExperimentView
% invokes classes as requested through the ExperimentView GUI 
classdef ExperimentController < System 

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
        runner
        listener
    end
    methods
        function obj = ExperimentController()
            obj.build(); 
        end
        function build(obj)
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
            buildAnimal(obj); 
            obj.visual = false; 
            obj.monitor = false; 
            obj.randomHeadDirection = true; 
            obj.stepPause = 0.1;             
        end
        function buildAnimal(obj)
            obj.animal = Animal(); 
            obj.animal.headDirectionSystem = obj.headDirectionSystem; 
            obj.animal.chartSystem = obj.chartSystem; 
        end
%         function buildRunner(obj)
%             import uk.ac.imperial.pipe.runner.*
%             obj.runner = PetriNetRunner('/Users/steve/Documents/MATLAB/simpleNet2.xml');
%             obj.listener = BooleanPlaceListener('P1');
%             obj.runner.markPlace('P0','Default',1);
%             obj.runner.listenForTokenChanges(obj.listener,'P1');
%             set(obj.listener,'PropertyChangeCallback',@obj.showEvent);
%             obj.runner.setFiringLimit(10);
%             obj.runner.setWaitForExternalInput(true);
%             obj.runner.run();
%             
%         end
%         function evt = showEvent(obj, source, evt )
%             disp('show Event')
%             disp(source)
%             disp('evt: ')
%             disp(evt)
%             disp(evt.getPropertyName())
%             disp(evt.getOldValue())
%             obj.runner.setWaitForExternalInput(false);
%             obj.runner.run();
%             % disp(javaMethod('getOldValue',evt))
%         end

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
            tempMap = []; 
            if not(isempty(obj.headDirectionSystem))
                if not(isempty(obj.headDirectionSystem.eventMap))
                    tempMap = obj.headDirectionSystem.eventMap; 
                end                
            end
            obj.headDirectionSystem = HeadDirectionSystem(obj.nHeadDirectionCells);
            obj.headDirectionSystem.animal = obj.animal;
            if not(isempty(tempMap))
                obj.headDirectionSystem.eventMap = tempMap; 
            end
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
                obj.loadFixedRandom(); 
            end
            system.build(); 
            obj.currentStep = 1;             
            runBareSystem(obj, system); 
        end
        function loadFixedRandom(~)
               load '../rngDefaultSettings';
               rng(rngDefault);                
        end
        function step(obj, system)
           events(obj); 
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
            end
            obj.iteration = obj.iteration + 1;
            if obj.monitor
%                 disp([obj.iteration length(obj.chartStatisticsDetail)]); 
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
        function setSystemProperties(~, map, property, value) 
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
        function value = getSystemProperty(~, map, property) 
            value = map(property); 
        end
        function setChartSystemProperty(obj, property, value) 
            setSystemProperty(obj, obj.chartSystemPropertyMap, property, value); 
        end
        function setHeadDirectionSystemProperty(obj, property, value) 
            setSystemProperty(obj, obj.headDirectionSystemPropertyMap, property, value); 
        end
        % perhaps: map is property name:  obj.(map)(property) = value
        function setSystemProperty(~, map, property, value) 
            map(property) = value; 
        end
        function updateSystemWithPropertyValue(~, system, property, value)
            system.(property) = value;  
        end
        function updateChartSystemWithPropertyValue(obj, property, value)
            updateSystemWithPropertyValue(obj, obj.chartSystem, property, value); 
        end
        function addEvent(~, system, time, event)
            system.addEvent(time, event); 
        end
        function addHeadDirectionSystemEvent(obj, time, event)
           obj.headDirectionSystem.addEvent(time, event); 
        end
        function addChartSystemEvent(obj, time, event)
           obj.chartSystem.addEvent(time, event); 
        end
        function addAnimalEvent(obj, time, event)
           obj.animal.addEvent(time, event); 
        end
        function addControllerEvent(obj, step, event)
            obj.eventMap(step) = event; 
        end
        function events(obj)
%             disp('experiment controller keys: '); 
%             disp(obj.eventMap.keys());
            if obj.eventMap.isKey(obj.currentStep)
               eval(obj.eventMap(obj.currentStep));
%                  disp('experiment controller event: ') 
%                  disp([num2str(obj.currentStep),obj.eventMap(obj.currentStep)]); 
            end
        end

        function buildHeadDirectionSystemPropertyMap(obj)
            addHeadDirectionSystemProperty(obj, 'alphaOffset');
            addHeadDirectionSystemProperty(obj, 'angularWeightOffset');
            addHeadDirectionSystemProperty(obj, 'betaGain');
            addHeadDirectionSystemProperty(obj, 'CInhibitionOffset');
            addHeadDirectionSystemProperty(obj, 'featureLearningRate');
            addHeadDirectionSystemProperty(obj, 'normalizedWeight');
            addHeadDirectionSystemProperty(obj, 'sigmaAngularWeight');
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
            setSystemProperties(obj, obj.chartSystemPropertyMap, 'sigmaWeightPattern', record(1,obj.nChartStats+7));
            iterateChartSystemForPropertyRanges(obj);
        end

        function iterateChartSystemForPropertyRanges(obj)
            obj.chartStatisticsHeader = {'iteration', 'weightSum', 'maxActivation', ... 
                'deltaMaxMin', 'numMax', 'maxSlope', 'alphaOffset', ...
                'betaGain', 'CInhibitionOffset', 'featureLearningRate', ...
                'normalizedWeight', 'sigmaAngularWeight',  ... 
                'sigmaWeightPattern'}; 
            obj.chartStatisticsDetail = zeros(1,obj.nChartStats+7); 
            for aa = gCSP(obj, 'alphaOffset'):gCSPi(obj, 'alphaOffset'):gCSPx(obj, 'alphaOffset')
            for bb = gCSP(obj, 'betaGain'):gCSPi(obj, 'betaGain'):gCSPx(obj, 'betaGain')
            for cc = gCSP(obj, 'CInhibitionOffset'):gCSPi(obj, 'CInhibitionOffset'):gCSPx(obj, 'CInhibitionOffset')
            for dd = gCSP(obj, 'featureLearningRate'):gCSPi(obj, 'featureLearningRate'):gCSPx(obj, 'featureLearningRate')
            for ee = gCSP(obj, 'normalizedWeight'):gCSPi(obj, 'normalizedWeight'):gCSPx(obj, 'normalizedWeight')
            for ff = gCSP(obj, 'sigmaAngularWeight'):gCSPi(obj, 'sigmaAngularWeight'):gCSPx(obj, 'sigmaAngularWeight')
            for gg = gCSP(obj, 'sigmaWeightPattern'):gCSPi(obj, 'sigmaWeightPattern'):gCSPx(obj, 'sigmaWeightPattern')
                rebuildChartSystem(obj); 
                updateChartSystemWithPropertyValue(obj, 'alphaOffset', aa); 
                updateChartSystemWithPropertyValue(obj, 'betaGain', bb); 
                updateChartSystemWithPropertyValue(obj, 'CInhibitionOffset', cc); 
                updateChartSystemWithPropertyValue(obj, 'featureLearningRate', dd); 
                updateChartSystemWithPropertyValue(obj, 'normalizedWeight', ee); 
                updateChartSystemWithPropertyValue(obj, 'sigmaAngularWeight', ff); 
                updateChartSystemWithPropertyValue(obj, 'sigmaWeightPattern', gg); 
                runSystem(obj,obj.chartSystem); % runChartSystem(obj) forces rebuild
                weightPage = obj.chartSystem.wHeadDirectionWeights(:,:,1); 
                weightSum = sum(sum(weightPage)); 
                maxActivation = max(max(obj.chartSystem.uActivation)); 
                minActivation = min(min(obj.chartSystem.uActivation)); 
                deltaMaxMin = maxActivation - minActivation;  
                [numMax , maxSlope] = obj.chartSystem.getMetrics(); 
                obj.chartStatisticsDetail(obj.iteration,:) = [obj.iteration, ...
                    weightSum, maxActivation, deltaMaxMin, numMax, maxSlope, aa, bb, cc, dd, ee, ff, gg]; 
%                 tempDetail = obj.chartStatisticsDetail;
%                 save 'detail50' tempDetail; 
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
%             plot(.9192,.9192, ...
%                 'o','MarkerFaceColor','blue','MarkerSize',5,'MarkerEdgeColor','blue');
%             plot(-1.3,0, ...
%                 'o','MarkerFaceColor','blue','MarkerSize',5,'MarkerEdgeColor','blue');
            axis equal
            axis off
            q(1).LineWidth = 5;
            q(2).LineWidth = 5;
            q(2).Color = [0.5 0.5 0.5];
            q(1).Color = [0.5 0.5 0.5];
            
            drawnow
        end
        function plot(obj)
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
            drawnow
        end        
    end
end
