% Animal class:  model movement and depiction of the physical animal
classdef Animal < System

    properties
        environment
        hippocampalFormation
        placeSystem
        cortex
        motorCortex
        visualCortex
        subCortex
        headDirectionSystem
        chartSystem
        firstPlot
        h
        visual
        nHeadDirectionCells
        randomHeadDirection
        defaultFeatureDetectors
        pullVelocityFromAnimal
        clockwiseVelocity
        counterClockwiseVelocity
        directions
        positions
        currentDirection
        unitCirclePosition
        minimumVelocity
        markers
        features
        showFeatures
        justOriented
        vertices
        axisOfRotation
        width
        length
        lastX
        lastY
        lastDegrees
        shape
        placed
        x 
        y
    end
    methods
        function obj = Animal()
            obj = obj@System(); 
            obj.directions = zeros(1,3);
            obj.positions = zeros(3,2); 
            obj.markers = gobjects(3,1); 
            obj.firstPlot = 1; 
            obj.minimumVelocity = pi/30; % corresponds to 60 head direction system cells  
            obj.clockwiseVelocity = 0; 
            obj.counterClockwiseVelocity = 0; 
            obj.features = [];
            obj.showFeatures = 0; 
            obj.justOriented = 0;
            obj.visual = false; 
            obj.nHeadDirectionCells = 60; 
            obj.randomHeadDirection = true; 
            obj.pullVelocityFromAnimal = true;
            obj.defaultFeatureDetectors = true; 
            obj.motorCortex = MotorCortex(obj); 
            obj.width = 0.05; 
            obj.length = 0.2;
            obj.placed = 0; 

        end
        function build(obj)
            obj.hippocampalFormation = HippocampalFormation();
            obj.hippocampalFormation.animal = obj; 
            obj.hippocampalFormation.defaultFeatureDetectors = obj.defaultFeatureDetectors; 
            obj.hippocampalFormation.randomHeadDirection = obj.randomHeadDirection;
            obj.hippocampalFormation.nHeadDirectionCells = obj.nHeadDirectionCells; 
            obj.hippocampalFormation.pullVelocity = obj.pullVelocityFromAnimal;
            obj.hippocampalFormation.visual = obj.visual; 
            obj.hippocampalFormation.h = obj.h; 
            
            obj.hippocampalFormation.build();  
            obj.headDirectionSystem = obj.hippocampalFormation.headDirectionSystem; 
            obj.buildInitialVertices(); 
        end
        function buildInitialVertices(obj)
            obj.vertices = [0 0+obj.width; 0 0-obj.width; 0+obj.length 0]; 
            obj.axisOfRotation = [0 0 0; 0 0 1];
            obj.x = 0;
            obj.y = 0; 
            obj.lastX = 0; 
            obj.lastY = 0; 
            obj.lastDegrees = 0; 
            obj.shape = antenna.Polygon('Vertices', obj.vertices); 
        end
        function buildDefaultHeadDirectionSystem(obj)
            buildHeadDirectionSystem(obj, obj.nHeadDirectionCells); 
        end
        function buildHeadDirectionSystem(obj, nHeadDirectionCells)
            obj.nHeadDirectionCells = nHeadDirectionCells;          
            rebuildHeadDirectionSystem(obj); 
        end
        function rebuildHeadDirectionSystem(obj)
            obj.hippocampalFormation.nHeadDirectionCells = obj.nHeadDirectionCells;
            obj.hippocampalFormation.rebuildHeadDirectionSystem(); 
%             tempMap = []; 
%             if not(isempty(obj.hippocampalFormation.headDirectionSystem))
%                 if not(isempty(obj.headDirectionSystem.eventMap))
%                     tempMap = obj.headDirectionSystem.eventMap; 
%                 end                
%             end
%             obj.headDirectionSystem = HeadDirectionSystem(obj.nHeadDirectionCells);
%             obj.headDirectionSystem.animal = obj;
%             if not(isempty(tempMap))
%                 obj.headDirectionSystem.eventMap = tempMap; 
%             end
%             obj.headDirectionSystem.initializeActivation(obj.randomHeadDirection); 
%             if obj.visual
%                 obj.headDirectionSystem.h = obj.h; 
%                 obj.hippocampalFormation.headDirectionSystem.h = obj.h; 
%             end
        end

        %% Single time step 
        function  step(obj)
            step@System(obj); 
            disp(['time: ',num2str(obj.time),' currentDirection: ',num2str(obj.currentDirection)]); 
        end
        function turn(obj, clockwiseNess, relativeSpeed)
            if obj.placed 
                if (clockwiseNess == 1) || (clockwiseNess == -1)
                    obj.currentDirection = obj.currentDirection + (clockwiseNess * (relativeSpeed * obj.minimumVelocity));
                    calculateVertices(obj);
                else
                    error('Animal:ClockwiseNess', ...
                        'turn(clockwiseNess, relativeSpeed) clockwiseNess must be 1 (CCW) or -1 (CW).') ;
                end
            else
                error('Animal:NotPlaced', ...
                    'animal must be placed before it can turn or move:  place(...)') ;
            end
        end
        function orientAnimal(obj, direction)
            obj.currentDirection = direction; 
            updateUnitCirclePosition(obj); 
            obj.justOriented = 1; 
        end
        function updateOrientation(obj)
            if obj.justOriented                
                obj.justOriented = 0; 
            else
%                 obj.currentDirection = obj.directions(1) + ... 
%                     obj.clockwiseVelocity + obj.counterClockwiseVelocity;
                updateUnitCirclePosition(obj);                 
            end
            if obj.currentDirection == obj.directions(1)
               notMovingMarkerUpdate(obj);  
            else
               movingMarkerUpdate(obj); 
            end     
        end
        function place(obj, environment, x, y, radians)
            obj.placed = 1; 
            obj.buildInitialVertices(); 
            obj.environment = environment;
            obj.environment.setPosition([x y]); 
            obj.currentDirection = radians; 
            calculateAxisOfRotation(obj); 
            calculateVertices(obj); 
        end
        function calculateAxisOfRotation(obj)
            obj.x = obj.environment.position(1); 
            obj.y = obj.environment.position(2); 
            obj.axisOfRotation = [obj.x obj.y 0; obj.x obj.y 1];
        end
        function calculateVertices(obj)
            radians = obj.currentDirection; 
             calculateAxisOfRotation(obj);
%              x = obj.environment.position(1); 
%              y = obj.environment.position(2); 
            degrees = radians * 180 / pi;
            translate(obj.shape, [obj.x-obj.lastX, obj.y-obj.lastY,0]);
            % degrees needs to be difference between current and last
            rotate(obj.shape, degrees - obj.lastDegrees, obj.axisOfRotation(1,1:3), obj.axisOfRotation(2,1:3)); 
            temp = obj.shape.Vertices; 
            obj.vertices = [temp(1,1:2); temp(2,1:2); temp(3,1:2)];                    
            obj.lastX = obj.x; 
            obj.lastY = obj.y; 
            obj.lastDegrees = degrees; 
        end
        function distance = closestWallDistance(obj)
            distance = obj.environment.closestWallDistance(); 
        end
        function updateUnitCirclePosition(obj)
            obj.unitCirclePosition = [cos(obj.currentDirection) sin(obj.currentDirection)];
        end
        function setupMarkers(obj)
            hold on;
            obj.markers(3) = plot(obj.unitCirclePosition(1), obj.unitCirclePosition(2), ...
                'o','MarkerFaceColor',[0.75 0.75 0.75],'MarkerSize',10,'MarkerEdgeColor',[0.75 0.75 0.75]);
            obj.markers(2) = plot(obj.unitCirclePosition(1), obj.unitCirclePosition(2), ...
                'o','MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',10,'MarkerEdgeColor',[0.5 0.5 0.5]);
            obj.markers(1) = plot(obj.unitCirclePosition(1), obj.unitCirclePosition(2), ...
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
            obj.positions(1,:) = obj.unitCirclePosition;              
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
            markerUpdate(obj, obj.unitCirclePosition, obj.positions(1,:), obj.positions(2,:)); 
        end
        function notMovingMarkerUpdate(obj)
            markerUpdate(obj, obj.unitCirclePosition, obj.unitCirclePosition, obj.unitCirclePosition); 
        end
        function plotAnimal(obj)
            figure(obj.h)
            p = antenna.Polygon('Vertices', [0.95 1; 1.05 1;1 1.2]); % [0.95 1 0; 1.05 1 0;1 1.2 0][-1 0 0;-0.5 0.2 0;0 0 0]
            plot(p, 'Color',[0.65 0.65 0.65],'LineWidth',3)
% rotate(p, 25, [0,1,0], [0,0,0])
% translate(p, [-0.4, 0.3, 0])

%             t=[0 1 0.5 0];
%             y=[0 0 0.5 0];
%             plot(t,y, 'Color','gray','LineWidth',1.5);
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
