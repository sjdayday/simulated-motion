%% TestingBehavior class:  class for unit testing Behavior
classdef TestingMoveHelper < Behavior 

    properties
    end
    methods
         function obj = TestingMoveHelper(prefix, animal, behaviorStatus)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal, behaviorStatus);

         end
         function behaviorStatus = getStandaloneStatus(obj)
            behaviorStatus = TestingBehaviorStatusStandalone('', []);  
         end
         function behaviorStatus = getIncludeStatus(obj)
            behaviorStatus = TestingBehaviorStatusInclude('', []); 
         end

         function buildStatus(obj, behaviorStatus)
            if (isempty(behaviorStatus))
                obj.behaviorStatus = obj.getStandaloneStatus();
            else
                obj.behaviorStatus = behaviorStatus; 
            end
        
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

end
