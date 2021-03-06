% Animal class:  model movement and depiction of the physical animal
classdef Animal < System

    properties
        controller
        environment
        hippocampalFormation
        % placeSystem, headDirectionSystem, chartSystem are in
        % hippocampalFormation; properties are here as easy anchors.
        % Consider replacing with getters against hippocampalFormation
        placeSystem  
        headDirectionSystem
        chartSystem
        cortex
        motorCortex
        visualCortex
        subCortex
        firstPlot
        h
        visual
        nHeadDirectionCells
        nCueIntervals
        randomHeadDirection
        defaultFeatureDetectors
        pullVelocityFromAnimal
        pullFeaturesFromAnimal
        updateFeatureDetectors
        clockwiseVelocity
        counterClockwiseVelocity
        directions
        positions
        currentDirection
        simulatedCurrentDirection
        unitCirclePosition
        simulatedUnitCirclePosition
        minimumVelocity
        minimumRunVelocity
        linearVelocity
        distanceTraveled
        markers
        features
        nFeatures
        showFeatures
        justOriented
        vertices
        lastVertices
        axisOfRotation
        width
        length
        lastX
        lastY
        lastDegrees
        shape
        lastShape
        placed
        x 
        y
        subplotAxes
        axesSet
        skipFirstPlot
        move
        velocityUnitsConversion
        nGridOrientations
        gridDirectionBiasIncrement
        nGridGains
        baseGain
        gridSize
        motionInputWeights
        showHippocampalFormationECIndices
        placeMatchThreshold
        settleToPlace
        whiskerLength
        rightWhiskerTouching
        leftWhiskerTouching
%         includeHeadDirectionFeatureInput
        sparseOrthogonalizingNetwork
        separateMecLec
        hdsPullsFeatureWeightsFromLec
        twoCuesOnly
        keepRunnerForReporting
        orientOnPlace
        nStabilizationSteps
        simulatedMotion
        hdsMinimumVelocity
        hdsAnimalVelocityCalibration   
        simulatedDistanceTraveled
        xSimulated
        ySimulated
        ripples
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
            obj.nCueIntervals = obj.nHeadDirectionCells;
            obj.randomHeadDirection = true; 
            % these three probably move together, driving HDS  
            obj.pullVelocityFromAnimal = true;
            obj.pullFeaturesFromAnimal = true;
            obj.defaultFeatureDetectors = true; 
%             obj.includeHeadDirectionFeatureInput = true;
            obj.updateFeatureDetectors = false; 
            obj.nFeatures = 3; 
            obj.motorCortex = MotorCortex(obj); 
            obj.width = 0.05; 
            obj.length = 0.2;
            obj.whiskerLength = 0.1; 
            obj.rightWhiskerTouching = false; 
            obj.leftWhiskerTouching = false;
            obj.placed = 0; 
            obj.axesSet = 0;
            obj.minimumRunVelocity = 0.1; 
            obj.distanceTraveled = 0; 
            obj.simulatedDistanceTraveled = 0; 
            obj.skipFirstPlot = 1; 
            obj.controller = SimpleController(obj); % default; overridden by ExperimentController
            obj.move = 1; % 1=turn, 0=run
            obj.linearVelocity = 0;
            obj.velocityUnitsConversion = 1000; % GridChartNetworks expects m/ms
            obj.nGridOrientations = 2; 
            obj.gridDirectionBiasIncrement = pi/4;             
            obj.nGridGains = 2; 
            obj.baseGain = 1500; 
            obj.gridSize = [10,9]; 
            obj.motionInputWeights = false; 
            obj.x = 0;
            obj.y = 0; 
            obj.xSimulated = 0; 
            obj.ySimulated = 0; 
            obj.showHippocampalFormationECIndices = false;
            obj.placeMatchThreshold = 0;
            obj.settleToPlace = false; 
            obj.sparseOrthogonalizingNetwork = false; 
            obj.separateMecLec = false;
            obj.hdsPullsFeatureWeightsFromLec = false; 
            obj.keepRunnerForReporting = false;
            obj.twoCuesOnly = false;
            obj.orientOnPlace = false; 
            obj.nStabilizationSteps = 3; 
            obj.simulatedMotion = false; 
            obj.hdsMinimumVelocity = pi/20; 
            obj.hdsAnimalVelocityCalibration = 1.0; 
            obj.ripples = 4; % default
        end
        function build(obj)
            obj.hippocampalFormation = HippocampalFormation();
            obj.hippocampalFormation.animal = obj; 
            obj.hippocampalFormation.defaultFeatureDetectors = obj.defaultFeatureDetectors; 
            obj.hippocampalFormation.pullVelocity = obj.pullVelocityFromAnimal;
            obj.hippocampalFormation.pullFeatures = obj.pullFeaturesFromAnimal;
            obj.hippocampalFormation.updateFeatureDetectors = obj.updateFeatureDetectors;
%             obj.hippocampalFormation.includeHeadDirectionFeatureInput = obj.includeHeadDirectionFeatureInput;
            obj.hippocampalFormation.nFeatures = obj.nFeatures; 
            obj.hippocampalFormation.randomHeadDirection = obj.randomHeadDirection;
            obj.hippocampalFormation.nHeadDirectionCells = obj.nHeadDirectionCells; 
            obj.hippocampalFormation.nCueIntervals = obj.nCueIntervals;
            obj.hippocampalFormation.showIndices = obj.showHippocampalFormationECIndices; 
            obj.hippocampalFormation.visual = obj.visual; 
            obj.hippocampalFormation.sparseOrthogonalizingNetwork = obj.sparseOrthogonalizingNetwork; 
            obj.hippocampalFormation.separateMecLec = obj.separateMecLec;
            obj.hippocampalFormation.twoCuesOnly = obj.twoCuesOnly; 
            obj.hippocampalFormation.hdsPullsFeatureWeightsFromLec = obj.hdsPullsFeatureWeightsFromLec; 
            obj.hippocampalFormation.h = obj.h; 
            obj.hippocampalFormation.nGridOrientations = obj.nGridOrientations; 
            obj.hippocampalFormation.gridDirectionBiasIncrement = obj.gridDirectionBiasIncrement;             
            obj.hippocampalFormation.nGridGains = obj.nGridGains; 
            obj.hippocampalFormation.baseGain = obj.baseGain; 
            obj.hippocampalFormation.gridSize = obj.gridSize;            
            obj.hippocampalFormation.motionInputWeights = obj.motionInputWeights; 
            obj.hippocampalFormation.placeMatchThreshold = obj.placeMatchThreshold;
            obj.hippocampalFormation.settleToPlace = obj.settleToPlace;
            obj.hippocampalFormation.hdsMinimumVelocity = obj.hdsMinimumVelocity; 
            obj.hippocampalFormation.hdsAnimalVelocityCalibration = obj.hdsAnimalVelocityCalibration; 
            obj.hippocampalFormation.build();  
            obj.headDirectionSystem = obj.hippocampalFormation.headDirectionSystem; 
            obj.buildInitialVertices(); 
            obj.controller.build(); 
            obj.motorCortex.keepRunnerForReporting = obj.keepRunnerForReporting; 
            obj.motorCortex.ripples = obj.ripples; 
%             obj.setChildTimekeeper(obj); 
        end
        function setChildTimekeeper(obj, timekeeper) 
           obj.setTimekeeper(timekeeper); 
           obj.hippocampalFormation.setChildTimekeeper(timekeeper);  
        end
        function buildInitialVertices(obj)
            obj.vertices = [0 0+obj.width; 0 0-obj.width; 0+obj.length 0]; 
            obj.lastVertices = [0 0+obj.width; 0 0-obj.width; 0+obj.length 0]; 
            obj.axisOfRotation = [0 0 0; 0 0 1];
%             obj.x = 0;
%             obj.y = 0; 
            obj.lastX = 0; 
            obj.lastY = 0;
            obj.lastDegrees = 0;
            if ishandle(obj.h) 
                figure(obj.h);
%                 obj.shape = antenna.Polygon('Vertices', obj.vertices);     
                disp('figure(obj.h)'); 
            end
             obj.shape = antenna.Polygon('Vertices', obj.vertices); 
             obj.lastShape = antenna.Polygon('Vertices', obj.lastVertices); 
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
        end
        function stabilizeActivation(obj)
            for ii = 1:obj.nStabilizationSteps
                obj.step();            
%                 disp(['HDS: ', num2str(obj.hippocampalFormation.headDirectionSystem.getMaxActivationIndex()) ]); 
            end
        end

        %% Single time step 
        function  step(obj)
            step@System(obj); 
            obj.hippocampalFormation.step();
%             obj.hippocampalFormation.stepHds();
%             obj.hippocampalFormation.stepMec();            
            disp(['Animal   time: ',num2str(obj.getTime()),' currentDirection: ',num2str(obj.currentDirection),' x: ',num2str(obj.x),' y: ',num2str(obj.y)]); 
            disp(['Animal:  simulatedCurrentDirection: ',num2str(obj.simulatedCurrentDirection),' xSimulated: ',num2str(obj.xSimulated),' ySimulated: ',num2str(obj.ySimulated)]); 
            disp(obj.vertices); 
        end
        function checkPlaced(obj)
           if (~obj.placed)  
                error('Animal:NotPlaced', ...
                    'animal must be placed before it can move (turn or run):  place(...)') ;
           end
        end
        function turn(obj, clockwiseness, relativeSpeed)
            obj.checkPlaced(); 
            obj.move = 1; 
                if (clockwiseness == 1) || (clockwiseness == -1)
                    if obj.simulatedMotion
                        % calculateSimulatedPositionFromSimulatedDistanceTraveled
                        obj.simulatedCurrentDirection = obj.simulatedCurrentDirection + (clockwiseness * (relativeSpeed * obj.minimumVelocity));
                    else
                        obj.currentDirection = obj.currentDirection + (clockwiseness * (relativeSpeed * obj.minimumVelocity));
                        obj.calculateVertices();
                    end
                    obj.hippocampalFormation.updateTurnAndLinearVelocity((clockwiseness * relativeSpeed), 0); 

                    obj.controller.step(); 

                else
                    error('Animal:clockwiseness', ...
                        'turn(clockwiseness, relativeSpeed) clockwiseness must be 1 (CCW) or -1 (CW).') ;
                end
        end

        function turnDone(obj)
            obj.hippocampalFormation.headDirectionSystem.updateTurnVelocity(0); 
        end
        function runDone(obj)
            obj.hippocampalFormation.updateLinearVelocity(0); 
        end
        function run(obj, relativeSpeed)
            obj.checkPlaced(); 
            obj.move = 0; 
            distance = relativeSpeed * obj.minimumRunVelocity;
            obj.linearVelocity = distance / obj.velocityUnitsConversion;                             
            if obj.simulatedMotion
                obj.distanceTraveled = 0; 
                obj.simulatedDistanceTraveled = distance; 
                obj.calculateSimulatedPositionFromSimulatedDistanceTraveled();
                obj.hippocampalFormation.addNextPlaceToSimulatedRunPlaces(); 
                % can't add place directly here, cause HF not yet called 

            else
                obj.distanceTraveled = distance; 
                obj.calculateVertices();
                if obj.motorCortex.navigateFirstSimulatedRun
                    obj.hippocampalFormation.evaluateSuccessfulRetrace(); 
                end
            end
            obj.hippocampalFormation.updateTurnAndLinearVelocity(0, obj.linearVelocity); 

            obj.controller.step(); 

        end
        % TODO:  should this be called by place? 
        function orientAnimal(obj, direction)
            obj.currentDirection = direction; 
            obj.simulatedCurrentDirection = direction; 
            updateUnitCirclePosition(obj); 
            obj.justOriented = 1;
%             obj.calculateVertices(); 
        end
        function updateOrientation(obj)
            if obj.justOriented                
                obj.justOriented = 0; 
            else
%                 obj.currentDirection = obj.directions(1) + ... 
%                     obj.clockwiseVelocity + obj.counterClockwiseVelocity;
                obj.updateUnitCirclePosition();                 
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
            obj.hippocampalFormation.lecSystem.environment = obj.environment; 
            obj.environment.setPosition([x y]); 
            obj.x = obj.environment.position(1); 
            obj.y = obj.environment.position(2); 
            obj.currentDirection = radians; 
            obj.resetSimulatedPositionAndDirectionToPhysicalPosition(); 
            obj.environment.calculateGridSquare([obj.x, obj.y]); 
            obj.calculateAxisOfRotation(); 
            obj.translateShape();
            obj.calculateVertices(); 
            obj.lastShape.Vertices = obj.updateVerticesFromShape(); 
            if obj.orientOnPlace
               obj.motorCortex.orient(true);    
            end
        end
        function setAxes(obj, axes)
           obj.subplotAxes = axes;
           obj.axesSet = 1; 
        end
        function calculateAxisOfRotation(obj)
%             obj.x = obj.environment.position(1); 
%             obj.y = obj.environment.position(2); 
            obj.axisOfRotation = [obj.x obj.y 0; obj.x obj.y 1];
        end
        function calculatePositionFromDistanceTraveled(obj)
            obj.updateUnitCirclePosition();
            deltaX = obj.distanceTraveled * obj.unitCirclePosition(1); 
            deltaY = obj.distanceTraveled * obj.unitCirclePosition(2); 
            obj.x = obj.x + deltaX;
            obj.y = obj.y + deltaY;
            obj.environment.setPosition([obj.x, obj.y]); 
            obj.environment.calculateGridSquare([obj.x, obj.y]); 
            obj.resetSimulatedPositionAndDirectionToPhysicalPosition(); 
        end
        function resetSimulatedPositionOnlyToPhysicalPosition(obj)
            obj.xSimulated = obj.x; 
            obj.ySimulated = obj.y;
        end              
        function resetSimulatedPositionAndDirectionToPhysicalPosition(obj)
            obj.resetSimulatedPositionOnlyToPhysicalPosition();
            obj.simulatedCurrentDirection = obj.currentDirection; 
        end      
        function calculateSimulatedPositionFromSimulatedDistanceTraveled(obj)
            obj.updateSimulatedUnitCirclePosition();
            deltaX = obj.simulatedDistanceTraveled * obj.simulatedUnitCirclePosition(1); 
            deltaY = obj.simulatedDistanceTraveled * obj.simulatedUnitCirclePosition(2); 
            obj.xSimulated = obj.xSimulated + deltaX;
            obj.ySimulated = obj.ySimulated + deltaY;
            obj.environment.calculateGridSquare([obj.xSimulated, obj.ySimulated]); 
        end
        function rotateShape(obj)
            radians = obj.currentDirection; 
            obj.calculateAxisOfRotation();
            % degrees needs to be difference between current and last
            degrees = radians * 180 / pi;
            obj.shape = rotate(obj.shape, degrees - obj.lastDegrees, obj.axisOfRotation(1,1:3), obj.axisOfRotation(2,1:3)); 
            obj.lastDegrees = degrees; 
        end
        function translateShape(obj)
            obj.shape = translate(obj.shape, [obj.x - obj.lastX, obj.y - obj.lastY, 0]);   
            obj.lastX = obj.x; 
            obj.lastY = obj.y; 
%             obj.shape = translate(obj.shape, [obj.x-obj.lastX, obj.y-obj.lastY,0]);            
        end
        function translateShapeByDistanceTraveled(obj)
            obj.calculatePositionFromDistanceTraveled();  
            obj.translateShape();
        end
        function calculateVertices(obj)
            obj.lastShape.Vertices = obj.updateVerticesFromShape();
            if (obj.move)  % 1 = turn
                obj.rotateShape(); 
            else  % 0 = run
                obj.translateShapeByDistanceTraveled(); 
            end
            obj.vertices = obj.updateVerticesFromShape();
            obj.calculateWhiskersTouching(); 
        end
        function distance = vertexDistance(obj, point)
            obj.environment.setPosition(point); 
            distance = obj.environment.closestWallDistance();
        end
        function calculateWhiskersTouching(obj) 
            obj.rightWhiskerTouching = false;
            obj.leftWhiskerTouching = false;
            currentPosition = obj.environment.position; 
%             leftSide = obj.vertices(1,:); 
%             obj.environment.setPosition(leftSide); 
%             leftDistance = obj.environment.closestWallDistance();
            leftDistance = obj.vertexDistance(obj.vertices(1,:)); 
            rightDistance = obj.vertexDistance(obj.vertices(2,:)); 
%             rightSide = obj.vertices(2,:); 
%             obj.environment.setPosition(rightSide); 
%             rightDistance = obj.environment.closestWallDistance();
            noseDistance = obj.vertexDistance(obj.vertices(3,:)); 
%             nose = obj.vertices(3,:); 
%             obj.environment.setPosition(nose); 
%             noseDistance = obj.environment.closestWallDistance();
            if (noseDistance <= obj.whiskerLength)
               if (rightDistance < leftDistance) 
                  obj.rightWhiskerTouching = true;  
                  disp('right whisker touching');          
               end
               if (leftDistance < rightDistance)
                  obj.leftWhiskerTouching = true;     
                  disp('left whisker touching');          
               end
               if (leftDistance == rightDistance)
                  obj.rightWhiskerTouching = true;     
                  obj.leftWhiskerTouching = true;     
                  disp('both whiskers touching');          
               end      
            end
            obj.environment.setPosition(currentPosition); 
            if obj.rightWhiskerTouching || obj.leftWhiskerTouching
               behavior = obj.motorCortex.currentPlan;   
               if isa(behavior, 'Behavior')
                   place = [behavior.behaviorStatus.behaviorPrefix, 'ObjectSensed'];
    %                disp(place);
                   behavior.behaviorStatus.markPlace(place);                 
               end
            end
        end        
        function vertices=updateVerticesFromShape(obj)
            temp = obj.shape.Vertices; 
            vertices = [temp(1,1:2); temp(2,1:2); temp(3,1:2)];                    
        end
        function distance = closestWallDistance(obj)
            distance = obj.environment.closestWallDistance(); 
        end
        function updateUnitCirclePosition(obj)
            obj.unitCirclePosition = [cos(obj.currentDirection) sin(obj.currentDirection)];
        end
        function updateSimulatedUnitCirclePosition(obj)
            obj.simulatedUnitCirclePosition = [cos(obj.simulatedCurrentDirection) sin(obj.simulatedCurrentDirection)];
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
            figure(obj.h);
            plot(obj.lastShape, 'Color','white','LineWidth',3); 
            plot(obj.shape, 'Color',[0.65 0.65 0.65],'LineWidth',3);            
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
