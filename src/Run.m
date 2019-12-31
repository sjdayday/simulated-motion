%% Run class:  
% invokes run.xml PetriNet with speed, and distance parameters, and tracks distance turned  
classdef Run <  Behavior  

    properties
         distanceRun
         distance
         speed
    end
    methods
        function obj = Run(prefix, animal, speed, distance, behaviorStatus, build)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal, behaviorStatus);
            obj.distanceRun = 0; 
            obj.behaviorStatus.speed = speed; 
            obj.speed = speed; 
            obj.distance = distance; 
            obj.behaviorStatus.distance = distance; 
            obj.behaviorStatus.behavior = obj; 
            if (build)
                obj.build(); 
            end            
        end
        function status = getStandaloneStatus(obj)
            status = RunBehaviorStatusStandalone(obj.prefix, []);
        end
        function status = getIncludeStatus(obj)
            % so far, unused
            status = RunBehaviorStatusInclude(obj.prefix, obj.runner); 
        end        
        
        function done(obj) % , ~, ~
            obj.animal.runDone(); 
        end
        function stepped(obj)  % , ~, ~ 
            obj.distanceRun = obj.distanceRun + 1;
             disp(['distanceRun: ',num2str(obj.distanceRun)]); 
            obj.animal.run(obj.speed); 
            obj.acknowledge('Stepped'); 
            disp('exiting stepped'); 
        end
    end
end
