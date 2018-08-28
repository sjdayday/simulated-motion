%% ExperimentController class:  controller for ExperimentView
% invokes classes as requested through the ExperimentView GUI 
classdef Behavior < handle 

    properties
        animal
        placeSystem
        cortex
        motorCortex
        visualCortex
        subCortex
        runner
        listener
        petriNetPath
        defaultPetriNet
        petriNet
        isDone
    end
    methods
        function obj = Behavior()
            import uk.ac.imperial.pipe.runner.*;
            obj.petriNetPath = [cd, '/petrinet/'];
            obj.defaultPetriNet = 'base-control.xml';
            buildStandardSemantics(obj);
            obj.isDone = false; 
            
%             obj.eventMap = containers.Map('KeyType','double','ValueType','char');
% %             obj.hFigures = figure; 
%             obj.nChartSystemSingleDimensionCells = 10;  % default
%             obj.nHeadDirectionCells = 60;  %default
%             obj.currentStep = 1; 
%             obj.resetSeed = true; 
%             obj.iteration = 0; 
%             obj.nChartStats = 6;
% 
%             buildHeadDirectionSystem(obj, obj.nHeadDirectionCells);
%             buildChartSystem(obj, obj.nChartSystemSingleDimensionCells);
%             obj.headDirectionSystemPropertyMap = containers.Map(); 
%             obj.chartSystemPropertyMap = containers.Map(); 
%             buildChartSystemPropertyMap(obj);
%             buildHeadDirectionSystemPropertyMap(obj);
%             obj.chartStatisticsHeader = {}; 
%             obj.animal = Animal(); 
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
        function evt = showEvent(obj, source, evt )
            disp('show Event')
            disp(source)
            disp('evt: ')
            disp(evt)
            disp(evt.getPropertyName())
            disp(evt.getOldValue())
            obj.runner.setWaitForExternalInput(false);
            obj.runner.run();
            % disp(javaMethod('getOldValue',evt))
        end
        function buildStandardSemantics(obj)
            import uk.ac.imperial.pipe.runner.*;
            obj.runner = PetriNetRunner(buildPetriNetName(obj));
            obj.markPlace('Enabled'); 
            obj.listenPlace('Done', @obj.done); 
  %     obj.runner.markPlace('P0','Default',1);
            obj.runner.setFiringLimit(10);
            obj.waitForInput(true)
        end
        function waitForInput(obj, wait)
            obj.runner.setWaitForExternalInput(wait);
        end
        function run(obj)
            obj.runner.run();    
        end
        function listenPlace(obj, place, evaluator)
            import uk.ac.imperial.pipe.runner.*;
            obj.listener = BooleanPlaceListener(place);
            obj.runner.listenForTokenChanges(obj.listener,place);
            set(obj.listener,'PropertyChangeCallback',evaluator);
        end
        function done(obj, ~, ~)
           obj.isDone = true;
           disp('isdone: ');
           disp(obj.isDone);
           obj.waitForInput(false);
           obj.run();
        end
        function markPlace(obj, place)
           obj.runner.markPlace(place, 'Default', 1); 
        end
        function petriNet = buildPetriNetName(obj)
            if (isempty(obj.petriNet)) 
                p = obj.getDefaultPetriNet();
            else 
                p = obj.petriNet; 
            end
            petriNet =  [obj.getPetriNetPath(),p];
        end
        function petriNet = getPetriNet(obj)
            petriNet = '';
        end
        function path = getPetriNetPath(obj)
            path = obj.petriNetPath;
        end
        function defaultPetriNet = getDefaultPetriNet(obj)
            defaultPetriNet = obj.defaultPetriNet;
        end
        function resetRandomSeed(obj, reset)
            obj.resetSeed = reset; 
        end
%         function visualize(obj, visual)
%             obj.visual = visual; 
%             if visual
%                 obj.h = figure; 
%                 obj.chartSystem.h = obj.h;
%                 obj.headDirectionSystem.h = obj.h; 
%                 obj.animal.h = obj.h; 
% %                 setupDisplay(obj);  % do later
%             else
%                 if isvalid(obj.h) 
%                     close(obj.h)
%                 end
%             end
%         end
    end
end
