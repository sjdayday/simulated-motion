%% BehaviorStatus class:  base class for behaviorStatus 
% BehaviorStatus handles the different possible life cycles for a Behavior 
% Standalone behaviors map one to one with a single Petri net, creating and destroying 
%  a single PetrinetRunner
% Include behaviors map to an IncludeHierarchy.  Only the top level
%  creates a PetrinetRunner; lower levels use the existing runner. 
% For included Petri nets that might execute multiple times, listeners may just be 
%  created once, while places that act as input parameters may be marked at each 
%  execution. 
classdef TurnBehaviorStatusStandalone < BehaviorStatus 

    properties
         clockwiseness
         speed
         distance 

%         behavior
%         runner 
% %         placeSystem
%         cortex
%         motorCortex
% %         visualCortex
%         subCortex
% %         headDirectionSystem
% %         chartSystem
%         runner
%         thread
%         threadRunner
% %         listener
%         petriNetPath
%         defaultPetriNet
%         petriNet
%         isDone
%         prefix
%         firingLimit
%         behaviorPrefix
%         acknowledging
%         placeReport
%         listeners
%         keepRunnerForReporting
%         placeReportLimit
%         standalone
    end
    methods
         function obj = TurnBehaviorStatusStandalone(prefix, runner)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@BehaviorStatus(prefix, runner);
            obj.defaultPetriNet = 'turn-SA.xml';
%             obj.prefix = prefix; 
%             obj.behavior = behavior;  <---- must be set later
%             obj.runner = runner;
%             if (isempty(runner))
%                 obj.standalone = true; 
%             else
%                 obj.standalone = false; 
%                 obj.runner = runner; 
%             end
%             obj.petriNetPath = [cd, '/petrinet/'];
%             obj.defaultPetriNet = 'base-control.xml';        
%             obj.isDone = false;
%             obj.prefix = prefix; 
%             obj.firingLimit = 10000000; % 10M; don't stop prematurely unless overridden
%             obj.placeReportLimit = 0;  % unlimited; override for Navigate
%             obj.behaviorPrefix = ''; % override in specific behavior
%             obj.animal = animal; 
            obj.acknowledging = true; 
%             getSystemsFromAnimal(obj); 
%             obj.listeners = [BooleanPlaceListener('dummy')]; % avoid error in cleanup when only one BPL is added
%             obj.keepRunnerForReporting = false; 
         end
         function setupListeners(obj)
            setupListeners@BehaviorStatus(obj); 
            obj.listenPlaceWithAcknowledgement([obj.prefix, 'Turned'], @obj.turned); 
         end
         function markPlaces(obj)
            if (obj.clockwiseness == 1)
                obj.markPlace([obj.behaviorPrefix, 'CounterClockwise']);
            end 
            if (obj.clockwiseness == -1)
                obj.markPlace([obj.behaviorPrefix, 'Clockwise']);                
            end
            obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Speed'], obj.speed); 
            obj.markPlaceMultipleTokens([obj.behaviorPrefix, 'Distance'], obj.distance); 
         end
        function done(obj, ~, ~)
            done@BehaviorStatus(obj, 1, 1);             
            obj.behavior.done(); 
        end         
        function turned(obj, ~, ~) 
            obj.behavior.turned(); 
%             obj.behavior.distanceTurned = obj.behavior.distanceTurned + 1;
%              disp(['distanceTurned: ',num2str(obj.behavior.distanceTurned)]); 
%             obj.behavior.animal.turn(obj.clockwiseness, obj.speed); 
%             obj.behavior.acknowledge('Turned'); 
%             disp('exiting turned'); 
        end         
        function cleanup(obj)
           obj.standaloneCleanup();  
        end
% buildRunner()
% setupListeners()
% markPlaces
% execute

%         function runner = buildRunner(obj)
% %             obj.buildThreadedRunner();              
% %             runner = obj.runner; 
%             if (obj.standalone)
%                 import uk.ac.imperial.pipe.runner.*;
%                 import java.lang.Thread;
%                 obj.runner = PetriNetRunner(buildPetriNetName(obj));
%                 obj.runner.setPlaceReporterParameters(true, true, 0); 
%                 obj.enable();
%                 obj.runner.setFiringLimit(obj.firingLimit);
%                 obj.runner.setSeed(rand()*1000000);
%     %             obj.runner.setFiringDelay(1000);
%                 obj.waitForInput(true);
%             end
%          end
%          function execute(obj)
%             obj.thread.start(); 
% %             obj.run();
%             while (~obj.isDone)
%                 pause(0.1); 
%             end   
%          end
%         function buildStandardSemantics(obj)
%             obj.buildRunner(); 
%             obj.listenPlaces(); 
% %             obj.listenPlace([obj.prefix,'Done'], @obj.done); 
%         end
%         function listenPlaces(obj)
%            if (obj.acknowledging) 
%                 obj.listenPlaceWithAcknowledgement([obj.prefix, 'Done'], @obj.done)
%     %           needed for place report
%                 obj.listenPlaceWithAcknowledgement([obj.prefix, 'Ready'], @obj.ready);                
%            else
%                 obj.listenPlace([obj.prefix,'Done'], @obj.done); 
%            end
%         end
%         function buildThreadedStandardSemantics(obj)
%             obj.buildThreadedRunner(); 
%             obj.listenPlaces(); 
% %             obj.listenPlaceWithAcknowledgement([obj.prefix, 'Done'], @obj.done)
% % %           needed for place report
% %             obj.listenPlaceWithAcknowledgement([obj.prefix, 'Ready'], @obj.ready); 
%         end
%         function buildThreadedRunner(obj)
%             import uk.ac.imperial.pipe.runner.*;
%             import java.lang.Thread;
%             obj.buildRunner(); 
%             obj.acknowledging = true; 
%             obj.threadRunner = ThreadedPetriNetRunner(obj.runner);
%             obj.thread = Thread(obj.threadRunner);                         
%         end
%         function enable(obj)
%             obj.markPlace([obj.prefix,'Enabled']);            
%         end
%         function waitForInput(obj, wait)
%             obj.runner.setWaitForExternalInput(wait);
%         end
%         function run(obj)
%             obj.runner.run();    
%         end
%         function listenPlace(obj, place, evaluator)
% %             f = java.lang.Boolean(false); 
%             listenPlaceBare(obj, place, evaluator, false, false); % false 
%         end
% %       After dispatching this evaluator, 
% %       Runner will not proceed without explicit acknowledgement: acknowledge(obj, place)  
%         function listenPlaceWithAcknowledgement(obj, place, evaluator)
% %             t = java.lang.Boolean(true); 
%             listenPlaceBare(obj, place, evaluator, true, false);  % true  
%         end
%         function listenPlaceWithAcknowledgementBothEvents(obj, place, evaluator)
%             listenPlaceBare(obj, place, evaluator, true, true);  % true  
%         end
%         function listenPlaceBare(obj, place, evaluator, acknowledgement, bothEvents)
%             import uk.ac.imperial.pipe.runner.*;
%             listener = BooleanPlaceListener(place, obj.runner, acknowledgement, bothEvents);
%             obj.runner.listenForTokenChanges(listener, place, acknowledgement);
%             set(listener,'PropertyChangeCallback',evaluator);
%             obj.listeners = [obj.listeners; listener];
%         end           
%         function acknowledge(obj, place) 
%            obj.runner.acknowledge(place);  
%         end
%         function ready(obj, ~, ~)
%            disp('ready');
%            obj.placeReport = obj.runner.getPlaceReport();
%            if (obj.acknowledging) 
%                 obj.acknowledge('Ready'); 
%            end
% 
%         end
% 
%         % move done logic to a method that can be called anywhere, not just
%         % from a subclass
%         function doDone(obj)
% %            disp(obj.runner.getPlaceReport()); % setMarkedPlaces(false)
% 
% %            obj.waitForInput(false);
% %            disp('behavior acknowledging: ');
% %            disp(obj.acknowledging);           
% %            disp('behavior standalone: ');
% %            disp(obj.standalone);           
%            if (obj.acknowledging) 
%                
%                 obj.acknowledge('Done'); 
%            else
%                 obj.run();  % concurrentModificationException if run() here when threaded
%            end
%            if (obj.standalone)
%                obj.waitForInput(false);
%                obj.cleanupJvmMemory();
%            end
%            obj.isDone = true;
% %            obj.cleanupJvmMemory(); 
%            disp('isdone: ');
%            disp(obj.isDone);
% %            obj.animal.behaviorDone();             
%         end
%         function cleanupJvmMemory(obj)
%            disp(size(obj.listeners));
%            disp(obj.listeners(1,:)); 
%            for ii = 1:length(obj.listeners)
%               obj.listeners(ii,1) = [];
%            end
%            obj.thread = []; 
%            obj.threadRunner = []; 
%            if ~obj.keepRunnerForReporting
%                obj.runner = []; 
%            end
% 
%         end
%         function markPlace(obj, place)
%            obj.markPlaceMultipleTokens(place, 1);
% %            obj.runner.markPlace(place, 'Default', 1); 
%         end
%         function markPlaceMultipleTokens(obj, place, tokens)
%            obj.runner.markPlace(place,'Default', tokens); 
%         end
%         function petriNet = buildPetriNetName(obj)
%             if (isempty(obj.petriNet)) 
%                 p = obj.getDefaultPetriNet();
%             else 
%                 p = obj.petriNet; 
%             end
%             petriNet =  [obj.getPetriNetPath(),p];
%         end
%         function petriNet = getPetriNet(obj)
%             petriNet = '';
%         end
%         function path = getPetriNetPath(obj)
%             path = obj.petriNetPath;
%         end
%         function defaultPetriNet = getDefaultPetriNet(obj)
%             defaultPetriNet = obj.defaultPetriNet;
%         end
%         function resetRandomSeed(obj, reset)
%             obj.resetSeed = reset; 
%         end
%         function placeReport = getPlaceReport(obj, index)
%            placeReport = obj.runner.getPlaceReport(index); 
%         end
    end
end
