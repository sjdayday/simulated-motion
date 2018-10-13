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
        end
        function turn(obj, clockwiseNess, relativeSpeed)
            if (clockwiseNess == 1) || (clockwiseNess == -1)
                obj.currentDirection = obj.currentDirection + (clockwiseNess * (relativeSpeed * obj.minimumVelocity));
            else
                error('Animal:ClockwiseNess', ...
                    'turn(clockwiseNess, relativeSpeed) clockwiseNess must be 1 (CCW) or -1 (CW).') ;
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
        function place(obj, environment, x, y, direction)
            obj.environment = environment;
            obj.environment.setPosition([x y]); 
            obj.currentDirection = direction; 
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
            t=[0 1 0.5 0];
            y=[0 0 0.5 0];
            plot(t,y);
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
