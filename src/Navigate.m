%% Navigate class:  
% invokes navigate.xml PetriNet 
% ...with speed, direction and distance parameters, and tracks distance turned  
classdef Navigate <  Behavior  

    properties
         distanceTurned
         clockwiseness
         speed
         finish
         stopOnReadyForTesting
         includeBehavior
    end
    methods
        function obj = Navigate(prefix, animal, behaviorStatus, build)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal, behaviorStatus);
            obj.behaviorStatus.placeReportLimit = 100; % otherwise, will consume lots of memory
%             obj.defaultPetriNet = 'include-navigate-move-turn-run.xml';
            obj.behaviorStatus.behaviorPrefix = [prefix,'Move.']; % Turn or Run...
            obj.finish = false;
            obj.stopOnReadyForTesting = false; 
            obj.behaviorStatus.behavior = obj; 
            if (build)
                obj.build(); 
            end
            
        end
        function status = getStandaloneStatus(obj)
           status = NavigateBehaviorStatusStandalone(obj.prefix, []);
        end
        function status = getIncludeStatus(obj)
            % currently unused 
%            status = NavigateBehaviorStatusInclude(obj.prefix, obj.runner); 
        end
        
        function simulate(obj, simulated)
            obj.animal.motorCortex.setSimulatedMotion(simulated); 
        end
        function done(obj)
            obj.animal.motorCortex.nextRandomNavigation(); 
        end
        
        function simulateChanged(obj, source, event)
            disp(['source name: ', source.Name]); 
            disp(['event class: ', class(event)]); 
            disp(['event name: ', event.Name]); 
        end
    end
end
