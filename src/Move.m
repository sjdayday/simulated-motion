%% Turn class:  
% invokes turn.xml PetriNet with speed, direction and distance parameters, and tracks distance turned  
classdef Move <  Behavior  

    properties
         distanceMoved
         speed
         distance
         clockwiseness
         turn
         includeBehavior % needs to be set by behaviorStatus
    end
    methods                
        function obj = Move(prefix, animal, speed, distance, clockwiseness, turn, behaviorStatus)
            import uk.ac.imperial.pipe.runner.*;
            obj = obj@Behavior(prefix, animal, behaviorStatus);
            obj.distanceMoved = 0; 
            obj.behaviorStatus.speed = speed; 
            obj.behaviorStatus.clockwiseness = clockwiseness; 
            obj.behaviorStatus.distance = distance;
            obj.turn = turn; 
            obj.behaviorStatus.turn = turn; 
            obj.behaviorStatus.behavior = obj; 
            obj.runner = obj.behaviorStatus.buildThreadedRunner(); 
            obj.behaviorStatus.setupListeners();
            obj.behaviorStatus.markPlaces(); 
            
%             if (obj.standalone)
%                 obj.defaultPetriNet = 'include-move-turn-run.xml';
%                 obj.buildThreadedStandardSemantics();                
%                 obj.buildThreadedRunner(); 
%                 obj.listenPlaces(); % must be explicitly called (once) when included
%             end
%             if (listenAndMark)
%                 obj.listenPlaces(); % must be explicitly called (once) when included
%                 obj.markPlaces(listenAndMark);
%             end
%            disp('move acknowledging: ');
%            disp(obj.acknowledging);           
%            disp('move standalone: ');
%            disp(obj.standalone);           

%             obj.execute(); 
           
        end
        function status = getStandaloneStatus(obj)
            status = MoveBehaviorStatusStandalone(obj.prefix, []);
        end
        function status = getIncludeStatus(obj)
            status = MoveBehaviorStatusInclude(obj.prefix, obj.runner); 
        end        
%         function markPlaces(obj, listenAndMark)
%             obj.markPlaceMultipleTokens([obj.prefix, 'Speed'], obj.speed); 
%             obj.markPlaceMultipleTokens([obj.prefix, 'Distance'], obj.distance); 
%             
%             if (obj.turn)
%                obj.behaviorPrefix = [obj.prefix,'Turn.'];
%                obj.markPlace([obj.prefix,'Turn']);
%                if (obj.clockwiseness == 1)
%                     obj.markPlace([obj.prefix, 'CounterClockwise']);
%                end 
%                if (obj.clockwiseness == -1)
%                     obj.markPlace([obj.prefix, 'Clockwise']);                
%                end
%                obj.behavior = Turn(obj.behaviorPrefix, obj.animal, obj.clockwiseness, obj.speed, obj.distance, obj.behaviorStatus); 
%                obj.behavior.acknowledging = true; 
%             else     
%                obj.behaviorPrefix = [obj.prefix,'Run.']; 
%                obj.markPlace([obj.prefix,'Run']);  
% %                obj.behavior = Run(obj.behaviorPrefix, obj.animal, obj.speed, obj.distance, obj.behaviorStatus);                            
%                obj.behavior = Run(obj.behaviorPrefix, obj.animal, obj.speed, obj.distance, obj.runner, listenAndMark);             
%                obj.behavior.acknowledging = true;                    
%             end
%  
%         end
        function done(obj) % , ~, ~
%             if (obj.standalone)
                disp(['prefix for move.done: ', obj.behaviorStatus.prefix]);
%                 done@Behavior(obj, 1, 1); 
%             end
            if (obj.turn)
                obj.distanceMoved = obj.includeBehavior.distanceTurned; 
            else
                obj.distanceMoved = obj.includeBehavior.distanceRun;
            end
        end        
    end
end
