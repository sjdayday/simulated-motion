%% BehaviorStatus class:  base class for behaviorStatus 
% BehaviorStatus handles the different possible life cycles for a Behavior 
% Standalone behaviors map one to one with a single Petri net, creating and destroying 
%  a single PetrinetRunner
% Include behaviors map to an IncludeHierarchy.  Only the top level
%  creates a PetrinetRunner; lower levels use the existing runner. 
% For included Petri nets that might execute multiple times, listeners may just be 
%  created once, while places that act as input parameters may be marked at each 
%  execution. 
classdef BehaviorStatus < handle 

    properties
        behavior
        runner 
        thread
        threadRunner
        petriNetPath
        defaultPetriNet
        petriNet
        isDone
        prefix
        firingLimit
        behaviorPrefix
        acknowledging
        placeReport
        listeners
        keepRunnerForReporting
        placeReportLimit
        readyAcknowledgeBuildsPlaceReport
    end
    methods
         function obj = BehaviorStatus(prefix, runner)
            import uk.ac.imperial.pipe.runner.*;
            obj.prefix = prefix; 
            obj.runner = runner;
            obj.defaultPetriNet = 'base-control.xml';                                
            obj.acknowledging = false; 
            obj.readyAcknowledgeBuildsPlaceReport = false;
         end
         function runner = buildRunner(obj)
            import uk.ac.imperial.pipe.runner.*;
            import java.lang.Thread;
            obj.runner = PetriNetRunner(buildPetriNetName(obj));
            obj.runner.setPlaceReporterParameters(true, true, 0); 
            obj.enable();
            obj.runner.setFiringLimit(obj.firingLimit);
            obj.runner.setSeed(rand()*1000000);
            obj.waitForInput(true);
            runner = obj.runner; 
         end
         function execute(obj)
            obj.thread.start(); 
            while (~obj.isDone)
                pause(0.1); 
            end   
         end
        function setupListeners(obj)
            obj.listenPlaces(); 
        end
        function listenPlaces(obj)
           if (obj.acknowledging) 
                obj.listenPlaceWithAcknowledgement([obj.prefix, 'Done'], @obj.done);
    %           needed for place report
                if (obj.readyAcknowledgeBuildsPlaceReport)
                    obj.listenPlaceWithAcknowledgement([obj.prefix, 'Ready'], @obj.ready);                
                end
           else
                obj.listenPlace([obj.prefix,'Done'], @obj.done); 
           end
        end
        function runner = buildThreadedRunner(obj)
            import uk.ac.imperial.pipe.runner.*;
            import java.lang.Thread;
            obj.buildRunner(); 
            obj.acknowledging = true; 
            obj.threadRunner = ThreadedPetriNetRunner(obj.runner);
            obj.thread = Thread(obj.threadRunner);                         
            runner = obj.runner ;
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
            listenPlaceBare(obj, place, evaluator, false, false); % false 
        end
% %       After dispatching this evaluator, 
% %       Runner will not proceed without explicit acknowledgement: acknowledge(obj, place)  
        function listenPlaceWithAcknowledgement(obj, place, evaluator)
            listenPlaceBare(obj, place, evaluator, true, false);  % true  
        end
        function listenPlaceWithAcknowledgementBothEvents(obj, place, evaluator)
            listenPlaceBare(obj, place, evaluator, true, true);  % true  
        end
        function listenPlaceBare(obj, place, evaluator, acknowledgement, bothEvents)
            import uk.ac.imperial.pipe.runner.*;
            listener = BooleanPlaceListener(place, obj.runner, acknowledgement, bothEvents);
            obj.runner.listenForTokenChanges(listener, place, acknowledgement);
            set(listener,'PropertyChangeCallback',evaluator);
            obj.listeners = [obj.listeners; listener];
        end           
        function acknowledge(obj, place) 
           obj.runner.acknowledge(place);  
        end
        function acknowledgeDone(obj)
             obj.acknowledge('Done'); 
        end
        function ready(obj, ~, ~)
           disp('ready');
           obj.placeReport = obj.runner.getPlaceReport();
           if (obj.acknowledging) 
                obj.acknowledge('Ready'); 
           end
        end
% 
        function done(obj, ~, ~)
            obj.doDone(); 
        end
        function doDone(obj)
           if (obj.acknowledging) 
                obj.acknowledgeDone();   
           else
                obj.run();  % concurrentModificationException if run() here when threaded
           end
           obj.cleanup(); % abstract, so overridden in standalone and include subclasses 
           obj.isDone = true;
           disp(['isdone: ', num2str(obj.isDone)]);
        end
        function standaloneCleanup(obj)
%             disp('standaloneCleanup'); 
        % include behavior will override with null
               obj.waitForInput(false);
               obj.cleanupJvmMemory();
        end
        function cleanupJvmMemory(obj)
           disp(size(obj.listeners));
           disp(obj.listeners(1,:)); 
           for ii = 1:length(obj.listeners)
              obj.listeners(ii,1) = [];
           end
           obj.thread = []; 
           obj.threadRunner = []; 
           if ~obj.keepRunnerForReporting
               obj.runner = []; 
           end

        end
        function markPlace(obj, place)
           obj.markPlaceMultipleTokens(place, 1);
        end
        function markPlaceMultipleTokens(obj, place, tokens)
           import uk.ac.imperial.pipe.runner.*; 
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
        function placeReport = getPlaceReport(obj, index)
           placeReport = obj.runner.getPlaceReport(index); 
        end
    end
    methods (Abstract)
        cleanup(obj)
    end
    
end
