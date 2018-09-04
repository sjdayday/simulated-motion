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
        headDirectionSystem
        chartSystem
        runner
%         listener
        petriNetPath
        defaultPetriNet
        petriNet
        isDone
        prefix
    end
    methods
         function obj = Behavior(prefix, animal)
            import uk.ac.imperial.pipe.runner.*;
            obj.petriNetPath = [cd, '/petrinet/'];
            obj.defaultPetriNet = 'base-control.xml';
            obj.isDone = false;
            obj.prefix = prefix; 
            obj.animal = animal; 
            getSystemsFromAnimal(obj); 
         end
         function getSystemsFromAnimal(obj)     
            obj.placeSystem = obj.animal.placeSystem; 
            obj.cortex = obj.animal.cortex;
            obj.motorCortex = obj.animal.motorCortex;
            obj.visualCortex = obj.animal.visualCortex;
            obj.subCortex = obj.animal.subCortex;
            obj.headDirectionSystem = obj.animal.headDirectionSystem;
            obj.chartSystem = obj.animal.chartSystem;
         end
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
        function buildStandardSemantics(obj)
            import uk.ac.imperial.pipe.runner.*;
            obj.runner = PetriNetRunner(buildPetriNetName(obj));
            obj.enable();
            obj.listenPlace([obj.prefix,'Done'], @obj.done); 
            obj.runner.setFiringLimit(1000);
            obj.waitForInput(true)
        end
        function enable(obj)
            obj.markPlace([obj.prefix,'Enabled']); 
        end
        function waitForInput(obj, wait)
            obj.runner.setWaitForExternalInput(wait);
        end
        function run(obj)
            obj.runner.run();    
        end
        function listenPlace(obj, place, evaluator)
            import uk.ac.imperial.pipe.runner.*;
            listener = BooleanPlaceListener(place);
            obj.runner.listenForTokenChanges(listener,place);
            set(listener,'PropertyChangeCallback',evaluator);
        end
%         function listenPlace(obj, place, evaluator)
%             import uk.ac.imperial.pipe.runner.*;
%             obj.listener = BooleanPlaceListener(place);
%             obj.runner.listenForTokenChanges(obj.listener,place);
%             set(obj.listener,'PropertyChangeCallback',evaluator);
%         end
        function done(obj, ~, ~)
           obj.isDone = true;
           disp('isdone: ');
           disp(obj.isDone);
           obj.waitForInput(false);
           obj.run();
        end
        function markPlace(obj, place)
           obj.markPlaceMultipleTokens(place, 1);
%            obj.runner.markPlace(place, 'Default', 1); 
        end
        function markPlaceMultipleTokens(obj, place, tokens)
           obj.runner.markPlace(place,'Default', tokens); 
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
