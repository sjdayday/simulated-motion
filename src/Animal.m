% Animal class:  model movement and depiction of the physical animal
classdef Animal < System

    properties
        firstPlot
        h
        clockwiseVelocity
        counterClockwiseVelocity
        directions
        positions
        currentDirection
        currentPosition
        minimumVelocity
        markers
        features
        showFeatures
        justOriented 
    end
    methods
        function obj = Animal()
            obj = obj@System(); 
            obj.directions = zeros(1,3);
            obj.positions = zeros(3,2); 
            obj.markers = gobjects(3,1); 
            obj.firstPlot = 1; 
            obj.minimumVelocity = pi/20; 
            obj.clockwiseVelocity = 0; 
            obj.counterClockwiseVelocity = 0; 
            obj.features = [];
            obj.showFeatures = 0; 
            obj.justOriented = 0; 
        end
        function build(obj)
           % inherited from System; unused. 
        end
        %% Single time step 
        function  step(obj)
            step@System(obj); 
        end
        function orientAnimal(obj, direction)
            obj.currentDirection = direction; 
            updatePosition(obj); 
            obj.justOriented = 1; 
        end
        function updatePosition(obj)
            obj.currentPosition = [cos(obj.currentDirection) sin(obj.currentDirection)];
        end
        function setupMarkers(obj)
            hold on;
            obj.markers(3) = plot(obj.currentPosition(1), obj.currentPosition(2), ...
                'o','MarkerFaceColor',[0.75 0.75 0.75],'MarkerSize',10,'MarkerEdgeColor',[0.75 0.75 0.75]);
            obj.markers(2) = plot(obj.currentPosition(1), obj.currentPosition(2), ...
                'o','MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',10,'MarkerEdgeColor',[0.5 0.5 0.5]);
            obj.markers(1) = plot(obj.currentPosition(1), obj.currentPosition(2), ...
                'o','MarkerFaceColor','black','MarkerSize',10,'MarkerEdgeColor','black');
                drawnow;
            pause(1); 
        end
        function bumpDirections(obj)
            obj.directions(3) = obj.directions(2);  
            obj.directions(2) = obj.directions(1);  
            obj.directions(1) = obj.currentDirection;              
            obj.positions(3,:) = obj.positions(2,:);  
            obj.positions(2,:) = obj.positions(1,:);  
            obj.positions(1,:) = obj.currentPosition;              
        end
        function markerUpdate(obj, position1, position2, position3)
            obj.markers(1).XData = position1(1); 
            obj.markers(1).YData = position1(2); 
            obj.markers(2).XData = position2(1); 
            obj.markers(2).YData = position2(2); 
            obj.markers(3).XData = position3(1);  
            obj.markers(3).YData = position3(2); 
            bumpDirections(obj);
            drawnow;            
        end
        function movingMarkerUpdate(obj)
            markerUpdate(obj, obj.currentPosition, obj.positions(1,:), obj.positions(2,:)); 
        end
        function notMovingMarkerUpdate(obj)
            markerUpdate(obj, obj.currentPosition, obj.currentPosition, obj.currentPosition); 
        end
        function updateOrientation(obj)
            if obj.justOriented                
                obj.justOriented = 0; 
            else
                obj.currentDirection = obj.directions(1) + ... 
                    obj.clockwiseVelocity + obj.counterClockwiseVelocity;
                updatePosition(obj);                 
            end
            if obj.currentDirection == obj.directions(1)
               notMovingMarkerUpdate(obj);  
            else
               movingMarkerUpdate(obj); 
            end
            
        end
        function plot(obj)
            figure(obj.h)
            if obj.firstPlot
                direction = 0; 
                orientAnimal(obj, direction);
                setupMarkers(obj); 
                obj.firstPlot = 0;
            end
            if obj.showFeatures
                hold on
                plot(.9192,.9192, ...
                'o','MarkerFaceColor','blue','MarkerSize',5,'MarkerEdgeColor','blue');
                plot(-1.3,0, ...
                'o','MarkerFaceColor','blue','MarkerSize',5,'MarkerEdgeColor','blue');
            end            
            hold off; 
            axis manual;
            updateOrientation(obj);
        end        
    end
end
