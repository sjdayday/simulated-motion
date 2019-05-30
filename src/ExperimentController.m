%% ExperimentController class:  controller for ExperimentView
% invokes classes as requested through the ExperimentView GUI 
classdef ExperimentController < System 

    properties
        environment
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
        systemMap
        lastSystem
        hPlace
%        possible grid parms 
%         nGridOrientations 
%         gridDirectionBiasIncrement             
%         nGridGains
%         baseGain 
%         gridSize            

    end
    methods
        function obj = ExperimentController()
            obj.visual = false;
%             obj.build(); 
        end
        function build(obj)
  %             obj.hFigures = figure; 
            obj.nChartSystemSingleDimensionCells = 10;  % default
            obj.currentStep = 1; 
            obj.resetSeed = true; 
            obj.iteration = 0; 
            obj.nChartStats = 6;
            buildEnvironment(obj);
            
            
            buildAnimal(obj); 
            buildChartSystem(obj, obj.nChartSystemSingleDimensionCells);
            obj.headDirectionSystemPropertyMap = containers.Map(); 
            obj.chartSystemPropertyMap = containers.Map(); 
            buildChartSystemPropertyMap(obj);
            buildHeadDirectionSystemPropertyMap(obj);
            obj.chartStatisticsHeader = {};
%             obj.visual = false; 
            obj.monitor = false; 
            obj.stepPause = 0.1;
            obj.buildSystemMap(); 
%             motorCortex = obj.animal.motorCortex; 
%             motorCortex.moveDistance = 10;
%             motorCortex.counterClockwiseTurn();

            obj.setChildTimekeeper(obj); 
        end
        function buildSystemMap(obj)
            obj.systemMap = containers.Map('KeyType','char','ValueType','double');
        end
        function setChildTimekeeper(obj, timekeeper) 
           obj.setTimekeeper(timekeeper); 
           obj.animal.setChildTimekeeper(timekeeper);  
        end
        function buildEnvironment(obj)
            obj.environment = Environment(); 
            obj.environment.addWall([0 0],[0 2]); 
            obj.environment.addWall([0 2],[2 2]); 
            obj.environment.addWall([0 0],[2 0]); 
            obj.environment.addWall([2 0],[2 2]);
            obj.environment.build(); 
%             env.setPosition([0.5 0.25]); 


        end
        function buildAnimal(obj)
            obj.animal = Animal();
            obj.animal.visual = true; 
            obj.animal.randomHeadDirection = obj.randomHeadDirection; 
            obj.animal.h = obj.h;
            obj.animal.build(); 
                obj.animal.hippocampalFormation.h = obj.h; 
                obj.animal.hippocampalFormation.headDirectionSystem.h = obj.h; 
            obj.animal.place(obj.environment, 1, 1, 0); % pi/2  
            obj.headDirectionSystem = obj.animal.hippocampalFormation.headDirectionSystem; 
            obj.animal.chartSystem = obj.chartSystem; 
            % move this to animal.place
            obj.animal.hippocampalFormation.lecSystem.setEnvironment(obj.environment);
            obj.animal.controller = obj;
        end

        function resetRandomSeed(obj, reset)
            obj.resetSeed = reset; 
        end
        function visualize(obj, visual)
            obj.visual = visual; 
            if visual
                obj.h = figure; 
                set(gcf,'color','w');
%                 obj.chartSystem.h = obj.h;
%                 obj.headDirectionSystem.h = obj.h; % not needed? 
%                 obj.animal.h = obj.h; 
%                 obj.animal.hippocampalFormation.h = obj.h; 
%                 obj.animal.hippocampalFormation.headDirectionSystem.h = obj.h; 
%                 setupDisplay(obj);  % do later
            else
                if ishandle(obj.h) 
                    close(obj.h)
                end
            end
        end
        % ExperimentControllerTest only caller
        function buildHeadDirectionSystem(obj, nHeadDirectionCells)
            obj.animal.nHeadDirectionCells = nHeadDirectionCells;
            rebuildHeadDirectionSystem(obj); 
        end
        function rebuildHeadDirectionSystem(obj) 
            obj.animal.rebuildHeadDirectionSystem(); 
%             obj.headDirectionSystem = obj.animal.headDirectionSystem; 
        end
        function buildChartSystem(obj, nChartSystemSingleDimensionCells)
            obj.nChartSystemSingleDimensionCells = nChartSystemSingleDimensionCells;
            rebuildChartSystem(obj);
        end
        function rebuildChartSystem(obj) 
            obj.chartSystem = ChartSystem(obj.nChartSystemSingleDimensionCells); 
            obj.chartSystem.h = obj.h;
        end
        function currentStep=getCurrentStep(obj, systemName)
            if obj.systemMap.isKey(systemName)
                currentStep = obj.systemMap(systemName);  
            else
                currentStep = 1; 
            end
        end
        function incrementCurrentStep(obj, systemName) 
            current = obj.getCurrentStep(systemName);
            obj.currentStep = current+1;
            obj.systemMap(systemName) = obj.currentStep;  
        end
        % run by Test and HDS functions
        function runHeadDirectionSystem(obj)
            obj.runHeadDirectionSystemForSteps(obj.remainingSteps(obj.animal.hippocampalFormation.headDirectionSystem));
%             rebuildHeadDirectionSystem(obj);
%             setupSystem(obj, obj.animal.hippocampalFormation.headDirectionSystem); 
%             runSystem(obj,obj.animal.hippocampalFormation.headDirectionSystem); 
        end
        function runHeadDirectionSystemForSteps(obj, steps)
            if obj.getCurrentStep(class(obj.animal.hippocampalFormation.headDirectionSystem)) == 1
                obj.rebuildHeadDirectionSystem();
                obj.setupSystem(obj.animal.hippocampalFormation.headDirectionSystem);         
            end
            obj.lastSystem = obj.animal.hippocampalFormation.headDirectionSystem;
            obj.runSystemForSteps(obj.animal.hippocampalFormation.headDirectionSystem, steps); 
        end

        function runChartSystem(obj)
            obj.runChartSystemForSteps(obj.remainingSteps(obj.chartSystem));
%             rebuildChartSystem(obj);
%             setupSystem(obj, obj.chartSystem); 
%             runSystem(obj,obj.chartSystem); 
        end
        % untested
        function runChartSystemForSteps(obj, steps)
            if obj.getCurrentStep(class(obj.chartSystem)) == 1
                obj.rebuildChartSystem();
                obj.setupSystem(obj.chartSystem);         
            end
            obj.lastSystem = obj.chartSystem;
            obj.runSystemForSteps(obj.chartSystem, steps); 
        end
        function setupSystem(obj, system)
            if obj.resetSeed
                obj.loadFixedRandom(); 
            end
            system.build(); 
            system.setTimekeeper(obj); 
            obj.currentStep = 1;                         
        end
        function runSystem(obj, system)
            runSystemForSteps(obj, system, obj.remainingSteps(system));
        end
        function remaining=remainingSteps(obj, system)
            remaining = obj.totalSteps-obj.getCurrentStep(class(system))+1;
        end
        function runSystemForSteps(obj, system, steps)
            stepsToRun = min(obj.remainingSteps(system), steps); 
            stepLimit = obj.currentStep+stepsToRun-1; 
            for ii = obj.currentStep:stepLimit
                obj.stepForSystem(system); 
%                 step(obj, system); 
            end
            obj.iteration = obj.iteration + 1;
            if obj.monitor
%                 disp([obj.iteration length(obj.chartStatisticsDetail)]); 
            end
        end
        function doStep(obj, system)
           system.step();
           obj.incrementCurrentStep(class(system));
%            obj.currentStep = obj.currentStep + 1; 
           if obj.visual
               plot(obj);  
               pause(obj.stepPause); 
           end                        
        end
        % FIXME
        function stepForSystem(obj, system)
           obj.step(); 
%            step@System(obj); 
%            events(obj); 
%            obj.animal.step(); 
%            system.step();
%            obj.incrementCurrentStep(class(system));
% %            obj.currentStep = obj.currentStep + 1; 
%            if obj.visual
%                plot(obj);  
%                pause(obj.stepPause); 
%            end
            obj.lastSystem = system; 
        end
%         function step(obj, system)        
        function step(obj)
           step@System(obj); 
           events(obj); 
           obj.animal.step(); 
           obj.doStep(obj.lastSystem); 
%            system.step();
%            obj.incrementCurrentStep(class(system));
% %            obj.currentStep = obj.currentStep + 1; 
%            if obj.visual
%                plot(obj);  
%                pause(obj.stepPause); 
%            end            
        end
        function continueHeadDirectionSystem(obj)
            if obj.currentStep == 1
                obj.runHeadDirectionSystem();
            else
                obj.runSystem(obj.animal.hippocampalFormation.headDirectionSystem);             
            end
        end
        function continueChartSystem(obj)
            if obj.currentStep == 1
                obj.runChartSystem();
            else
                obj.runSystem(obj.chartSystem);             
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
           obj.animal.hippocampalFormation.headDirectionSystem.addEvent(time, event); 
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
            % Why is this driven off current step, and the system version
            % is driven off time?  Why is this needed? 
%             disp('experiment controller keys: '); 
%             disp(obj.eventMap.keys());
            if obj.eventMap.isKey(obj.currentStep)
               eval(obj.eventMap(obj.currentStep));
%               remove event cause we were running this twice, which is the
%               real problem to debug. :-/
               obj.eventMap.remove(obj.currentStep); 
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
                obj.lastSystem = obj.chartSystem;
                updateChartSystemWithPropertyValue(obj, 'alphaOffset', aa); 
                updateChartSystemWithPropertyValue(obj, 'betaGain', bb); 
                updateChartSystemWithPropertyValue(obj, 'CInhibitionOffset', cc); 
                updateChartSystemWithPropertyValue(obj, 'featureLearningRate', dd); 
                updateChartSystemWithPropertyValue(obj, 'normalizedWeight', ee); 
                updateChartSystemWithPropertyValue(obj, 'sigmaAngularWeight', ff); 
                updateChartSystemWithPropertyValue(obj, 'sigmaWeightPattern', gg); 
                setupSystem(obj, obj.chartSystem); 
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
            hold on;  
            subplot(331); 
            obj.displayArena(); 
            subplot(332); % 221
            obj.x = -1.1:.01:1.1;
            obj.y = zeros(1,221); 
            for ii = 1:length(obj.x)
                obj.y(1,ii) = abs(sqrt(1.21 - obj.x(1,ii)^2));
            end
            obj.yy = -obj.y;
%             subplot(332); % 221
            hold on; 
            title({'Physical head direction ',sprintf('t = %d',obj.currentStep)})
            p = plot(obj.x,obj.y,obj.x,obj.yy);
            axis equal
            axis off
            p(1).LineWidth = 5;
            p(2).LineWidth = 5;
            p(2).Color = [0.5 0.5 0.5];
            p(1).Color = [0.5 0.5 0.5];
            subplot(333); % 222
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
        function displayArena(obj)
            figure(obj.h);
            hold on;
            for jj = 1:size(obj.environment.walls,1)
               wall = obj.environment.walls(jj,:); 
               L = line([wall(1) wall(3)], [wall(2) wall(4)],'Color','black','LineWidth',2); 
            end 
%             axis ([0 2 0 2 ]);
             axis off
%             axis equal
        end
        function plot(obj)
%  arena  pHDS   vHDS                       
% grid1   grid2    grid3
% EC act  CA3 act HDS act  
            figure(obj.h);
            subplot(331); 
            title({'Animal in the arena'})
            obj.animal.plotAnimal(); 
            subplot(332);  
            title({'Physical head direction ',sprintf('t = %d',obj.currentStep)})
            obj.animal.plot(); 
            subplot(333);  
            title({'Internal head direction ',sprintf('t = %d',obj.currentStep)})
            obj.animal.hippocampalFormation.headDirectionSystem.plotCircle(); 
            subplot(334);
            obj.animal.hippocampalFormation.grids(1).plotActivation();             
            subplot(335);
            obj.animal.hippocampalFormation.grids(2).plotActivation();             
            subplot(337);
            obj.animal.hippocampalFormation.grids(3).plotActivation();             
            subplot(338); 
            obj.animal.hippocampalFormation.grids(4).plotActivation();             
%             obj.animal.plotAnimal(); 
            hold on; 
%              subplot(338); 
%             obj.animal.plotAnimal(); 
             subplot(336); 
            obj.animal.hippocampalFormation.headDirectionSystem.plotActivation(); 
            
            delete(obj.hPlace); 
            obj.hPlace = subplot(339); 
            obj.animal.hippocampalFormation.plotPlaces(); 
            drawnow
        end        
    end
end
