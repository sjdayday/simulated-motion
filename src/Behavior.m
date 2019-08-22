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
        thread
        threadRunner
%         listener
        petriNetPath
        defaultPetriNet
        petriNet
        isDone
        prefix
        behaviorPrefix
        acknowledging
        placeReport
    end
    methods
         function obj = Behavior(prefix, animal)
            import uk.ac.imperial.pipe.runner.*;
            obj.petriNetPath = [cd, '/petrinet/'];
            obj.defaultPetriNet = 'base-control.xml';
            obj.isDone = false;
            obj.prefix = prefix; 
            obj.behaviorPrefix = ''; % override in specific behavior
            obj.animal = animal; 
            obj.acknowledging = false; 
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
         function buildRunner(obj)
            import uk.ac.imperial.pipe.runner.*;
            import java.lang.Thread;
            obj.runner = PetriNetRunner(buildPetriNetName(obj));
            obj.runner.setPlaceReporterParameters(true, true, 0); 
            obj.enable();
            obj.runner.setFiringLimit(1000);
%             obj.runner.setFiringDelay(1000);
            obj.waitForInput(true);
             
         end
        function buildStandardSemantics(obj)
            obj.buildRunner(); 
            obj.listenPlace([obj.prefix,'Done'], @obj.done); 
        end
        function buildThreadedStandardSemantics(obj)
            import uk.ac.imperial.pipe.runner.*;
            import java.lang.Thread;
            obj.buildRunner(); 
            obj.listenPlaceWithAcknowledgement([obj.prefix, 'Ready'], @obj.ready); 
            obj.listenPlaceWithAcknowledgement([obj.prefix, 'Done'], @obj.done)
            obj.acknowledging = true; 
            obj.threadRunner = ThreadedPetriNetRunner(obj.runner);
            obj.thread = Thread(obj.threadRunner);             
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
%             f = java.lang.Boolean(false); 
            listenPlaceBare(obj, place, evaluator, false); % false 
        end
%       After dispatching this evaluator, 
%       Runner will not proceed without explicit acknowledgement: acknowledge(obj, place)  
        function listenPlaceWithAcknowledgement(obj, place, evaluator)
%             t = java.lang.Boolean(true); 
            listenPlaceBare(obj, place, evaluator, true);  % true  
        end
        function listenPlaceBare(obj, place, evaluator, acknowledgement)
            import uk.ac.imperial.pipe.runner.*;
            listener = BooleanPlaceListener(place, obj.runner, acknowledgement);
            obj.runner.listenForTokenChanges(listener, place, acknowledgement);
            set(listener,'PropertyChangeCallback',evaluator);
        end           
        function acknowledge(obj, place) 
           obj.runner.acknowledge(place);  
        end
        function ready(obj, ~, ~)
           disp('ready');
           obj.placeReport = obj.runner.getPlaceReport();
           if (obj.acknowledging) 
                obj.acknowledge('Ready'); 
           end

        end

        function done(obj, ~, ~)
%            disp(obj.runner.getPlaceReport()); % setMarkedPlaces(false)

           obj.waitForInput(false);
           if (obj.acknowledging) 
                obj.acknowledge('Done'); 
           else
                obj.run();  % concurrentModificationException if run() here when threaded
           end
           obj.isDone = true;
           disp('isdone: ');
           disp(obj.isDone);
%            obj.animal.behaviorDone(); 
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
