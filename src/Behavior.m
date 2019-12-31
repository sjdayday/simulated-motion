%% Behavior class:  base class for behaviors
% Behaviors invoke correponding Petri nets, including:  Run, Turn, Move, Navigate 
% Behaviors may be run as standalone Petri nets, or as part of include hierarchies 
classdef Behavior < handle 

    properties
        animal
        cortex
        motorCortex
        subCortex
        runner
        thread
        threadRunner
        petriNet
        prefix
        acknowledging
        placeReport
        keepRunnerForReporting
        behaviorStatus 
        
    end
    methods
         function obj = Behavior(prefix, animal, behaviorStatus)
            import uk.ac.imperial.pipe.runner.*;

            obj.prefix = prefix;             
            obj.buildStatus(behaviorStatus); 

            obj.behaviorStatus.petriNetPath = [cd, '/petrinet/'];

            obj.behaviorStatus.isDone = false;
            obj.behaviorStatus.firingLimit = 10000000; % 10M; don't stop prematurely unless overridden
            obj.behaviorStatus.placeReportLimit = 0;  % unlimited; override for Navigate
%             obj.behaviorStatus.behaviorPrefix = ''; % override in specific behavior
            obj.animal = animal; 
            getSystemsFromAnimal(obj); 
            if (size(obj.behaviorStatus.listeners) == 0) 
                obj.behaviorStatus.listeners = [BooleanPlaceListener('dummy')]; % avoid error in cleanup when only one BPL is added
            end
            obj.behaviorStatus.keepRunnerForReporting = false; 

         end
         function buildStatus(obj, behaviorStatus)
            if (isempty(behaviorStatus))
                obj.behaviorStatus = obj.getStandaloneStatus();
            else
                obj.behaviorStatus = behaviorStatus; 
            end
        
         end
         function build(obj)
            % should be driven by a flag to choose threaded or not threaded runner 
            obj.runner = obj.behaviorStatus.buildThreadedRunner(); 
            obj.behaviorStatus.setupListeners();
            obj.behaviorStatus.markPlaces(); 
         end
         function getSystemsFromAnimal(obj)     
            obj.cortex = obj.animal.cortex;
            obj.motorCortex = obj.animal.motorCortex;
            obj.subCortex = obj.animal.subCortex;
         end
         function buildRunner(obj)
            obj.runner = obj.behaviorStatus.buildRunner();                          
         end
         function execute(obj)
             obj.behaviorStatus.execute(); 
         end
        function buildStandardSemantics(obj)
            obj.buildRunner(); 
            obj.listenPlaces(); 
        end
        function listenPlaces(obj)
            obj.behaviorStatus.listenPlaces(); 
        end
        function buildThreadedStandardSemantics(obj)
            obj.behaviorStatus.buildThreadedStandardSemantics(); 
        end
        function run(obj)
            obj.behaviorStatus.run(); 
        end
        function acknowledge(obj, place) 
           obj.runner.acknowledge(place);  
        end
        function resetRandomSeed(obj, reset)
            obj.resetSeed = reset; 
        end
        function placeReport = getPlaceReport(obj, index)
           placeReport = obj.runner.getPlaceReport(index); 
        end
    end
    methods (Abstract)
        status = getStandaloneStatus(obj)
        status = getIncludeStatus(obj)
    end

end
