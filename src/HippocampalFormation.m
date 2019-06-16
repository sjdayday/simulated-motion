% HippocampalFormation class:  extends System
% models the functions of the hippocampus and entorhinal cortex
classdef HippocampalFormation < System 

    properties
%         wiring
%         currentInputX
        animal
        nHeadDirectionCells
        nGrids
        nGridOrientations
        nGridGains
        grids
        nX
        nY
        baseGain
        gridSize
        gridDirectionBiasIncrement
        gridLength
        gridExternalVelocity
        motionInputWeights
        nFeatures
        distanceUnits
        rewardInput
        reward
        placeSystem
        placeOutput
        mecOutput
        nMecOutput
        headDirectionSystem
        currentHeadDirection
        featureOutput
        lecSystem
        lecOutput
        nLecOutput
        linearVelocity
        angularVelocity
        defaultFeatureDetectors
        updateFeatureDetectors
        randomHeadDirection
        pullVelocity
        pullFeatures
        visual
        h
        placeList
        placeListDisplay
        placePositionMap
        nPlaceIndices
        nearThreshold
        lastPositionPlaceRow
        showIndices
        placeMatchThreshold
    end
    methods
        function obj = HippocampalFormation()
            obj = obj@System(); 
            obj.nHeadDirectionCells = 12; 
            obj.nGridOrientations = 1; 
            obj.gridDirectionBiasIncrement = pi/6;
            obj.nGridGains = 1; 
            obj.gridSize = [10,9];
            obj.motionInputWeights = false; 
            obj.nFeatures = 1; 
            obj.baseGain = 1000; 
            obj.distanceUnits = 5; 
            obj.rewardInput = false; 
            obj.reward = [];
            obj.angularVelocity = 0; 
            obj.linearVelocity = 0; 
            obj.gridExternalVelocity = true; 
            obj.defaultFeatureDetectors = true; 
            obj.randomHeadDirection = true; 
            obj.pullVelocity = true; 
            obj.pullFeatures = true; 
            obj.visual = false; 
            obj.animal = Animal();
            obj.loadFixedRandom();
            obj.currentHeadDirection = 1;
            obj.placePositionMap = containers.Map('KeyType','char','ValueType','any');
            obj.nearThreshold = 0.2;
            obj.placeList = []; 
            obj.placeListDisplay = [];
            obj.updateFeatureDetectors = false; 
            obj.showIndices = false; 
            obj.placeMatchThreshold = 0;
         end
        function build(obj)
            calculateSizes(obj); 
            buildLec(obj); 
            rebuildHeadDirectionSystem(obj); 
%             buildHeadDirectionSystem(obj); 
            buildGrids(obj); 
%             buildLec(obj); 
            buildPlaceSystem(obj);
            % TODO: setTimekeeper for placesystem 
        end
        function calculateSizes(obj)
            obj.nGrids = obj.nGridOrientations * obj.nGridGains; 
            grids(1,obj.nGrids) = GridChartNetwork();
            obj.grids = grids; 
            obj.nX = obj.gridSize(1,1);
            obj.nY = obj.gridSize(1,2);
            obj.gridLength = obj.nX * obj.nY; 
            obj.nMecOutput = obj.nGrids * obj.gridLength; 
%             featureLength = obj.distanceUnits + obj.nHeadDirectionCells; 
%             obj.featureOutput = zeros(1, obj.nFeatures * featureLength); 
%             if obj.rewardInput 
%                obj.reward = zeros(1,5);  
%             end
%             obj.nLecOutput = length(obj.featureOutput) + length(obj.reward); 
            numberOfLecIndices = 3; % defaults to number of features in 2 cued environment
            obj.nPlaceIndices = obj.nGrids + numberOfLecIndices; 
            nPosition = 2; % [animal.x animal.y] 
            obj.lastPositionPlaceRow = zeros(1,(nPosition+obj.nPlaceIndices)); % position + place            
        end
        function rebuildHeadDirectionSystem(obj) 
            tempMap = []; 
            if not(isempty(obj.headDirectionSystem))
                if not(isempty(obj.headDirectionSystem.eventMap))
                    tempMap = obj.headDirectionSystem.eventMap; 
                end                
            end
            buildHeadDirectionSystem(obj); 
%             obj.headDirectionSystem = HeadDirectionSystem(obj.nHeadDirectionCells);
%             obj.headDirectionSystem.animal = obj;
            if not(isempty(tempMap))
                obj.headDirectionSystem.eventMap = tempMap; 
            end
%             obj.headDirectionSystem.initializeActivation(obj.randomHeadDirection); 
            if obj.visual
                obj.headDirectionSystem.h = obj.h; 
%                 obj.hippocampalFormation.headDirectionSystem.h = obj.h; 
            end
            obj.setChildTimekeeper(obj); 
        end
        function setChildTimekeeper(obj, timekeeper) 
           obj.setTimekeeper(timekeeper); 
           obj.headDirectionSystem.setChildTimekeeper(timekeeper);
        end

        function buildHeadDirectionSystem(obj)
            obj.headDirectionSystem = HeadDirectionSystem(obj.nHeadDirectionCells);  % only here to keep tests passing
            obj.headDirectionSystem.animal = obj.animal; 
%             obj.headDirectionSystem.nHeadDirectionCells = obj.nHeadDirectionCells;  
            obj.headDirectionSystem.initializeActivation(obj.randomHeadDirection);
            obj.headDirectionSystem.pullVelocity = obj.pullVelocity; 
            obj.headDirectionSystem.pullFeatures = obj.pullFeatures; 
            if not(obj.defaultFeatureDetectors)
                obj.headDirectionSystem.nFeatureDetectors = obj.nMecOutput + obj.nLecOutput;             
            end
            obj.headDirectionSystem.build(); 
        end
        function initializeGridActivation(obj)
           for ii = 1:obj.nGrids
              obj.grids(ii).initializeActivation();  
           end
        end
        function buildGrids(obj) 
            gain = obj.baseGain; 
            index = 0; 
            for ii = 1:obj.nGridGains
                bias = 0; 
                for jj = 1:obj.nGridOrientations
                    kk = index*obj.nGridOrientations+jj; 
                    obj.grids(1,kk) = GridChartNetwork(obj.nX, obj.nY); 
                    obj.grids(1,kk).inputDirectionBias = bias; 
                    obj.grids(1,kk).inputGain = gain;
                    obj.grids(1,kk).externalVelocity = obj.gridExternalVelocity; 
                    obj.grids(1,kk).motionInputWeights = obj.motionInputWeights; 
                    bias = bias + obj.gridDirectionBiasIncrement;
                    if obj.visual
                         obj.grids(1,kk).h = obj.h; 
                    end
                end
                gain = gain * 1.42; 
                index = index + 1; 
            end
        end
        function buildLec(obj)
            obj.lecSystem = LecSystem();
%             obj.lecSystem.distanceUnits = obj.distanceUnits;
            obj.lecSystem.nHeadDirectionCells = obj.nHeadDirectionCells;
            obj.lecSystem.nFeatures = obj.nFeatures; 
%             if obj.rewardInput 
%                 obj.lecSystem.rewardUnits = 5;
%             else
%                 obj.lecSystem.rewardUnits = 0; 
%             end
            obj.lecSystem.build(); 
            obj.nLecOutput = obj.lecSystem.nOutput;
            
            obj.lecOutput = zeros(1, obj.nLecOutput) ;
        end
        function buildPlaceSystem(obj)
            disp(['MEC: ',num2str(obj.nMecOutput), 'LEC: ', num2str(obj.nLecOutput)]);  
            obj.placeSystem = PlaceSystem(obj.nMecOutput, obj.nLecOutput);
            obj.placeSystem.matchThreshold = obj.placeMatchThreshold;
        end
        function step(obj)
            step@System(obj); 
            obj.stepHds(); 
            obj.stepMec(); 
            obj.stepLec(); 
            obj.stepPlace(); 
        end
        function stepHds(obj)
            obj.headDirectionSystem.step(); 
        end
        function stepMec(obj)
            obj.mecOutput = zeros(1,obj.nMecOutput); 
            index = 0; 
            obj.updateCurrentHeadDirection();
            v =  calculateCartesianVelocity(obj);
            for ii = 1:obj.nGrids
                obj.grids(1,ii).updateVelocity(v(1),v(2)); 
                obj.grids(1,ii).step(); 
                max = obj.grids(1,ii).getMaxActivationIndex(); 
                obj.mecOutput(1,index+max) = 1; 
                index = index + obj.gridLength;     
            end 
            if obj.showIndices
                disp(['MEC output: ',mat2str(find(obj.mecOutput == 1))]);
            end
        end
        function stepLec(obj)
            obj.lecSystem.buildCanonicalView(obj.currentHeadDirection); 
            obj.lecOutput = obj.lecSystem.lecOutput; 
%             disp(['length lecOutput: ', num2str(length( obj.lecOutput))]);
            if obj.showIndices
                disp(['LEC output: ',mat2str(find(obj.lecOutput == 1))]);
            end

        end
        function stepPlace(obj)
           placeRecognized = obj.placeSystem.placeRecognized([obj.mecOutput, obj.lecOutput]); 
           disp(['Place recognized: ',num2str(placeRecognized)]);                     
           obj.placeOutput = obj.placeSystem.step(obj.mecOutput, obj.lecOutput);
           obj.addPositionAndPlaceIfDifferent(); 
           if obj.updateFeatureDetectors
               obj.headDirectionSystem.setFeaturesDetected(obj.placeOutput); 
           end
           if obj.showIndices
                disp(['Place output: ',mat2str(find(obj.placeOutput == 1))]);
           end

        end
        function result = savePositionForPlace(obj, position, placeId)
           placeKey = mat2str(placeId,2);
           try 
               previousPosition = obj.getPositionForPlace(placeKey);  
               result = obj.positionNearOrFarFromPreviousPosition(position, previousPosition);
           catch EX
               obj.placePositionMap(placeKey) = position; 
               result = 2;  
           end
        end
        function near = positionNearOrFarFromPreviousPosition(obj, position, previousPosition)
            distance = sqrt((position(1)-previousPosition(1))^2 + (position(2)-previousPosition(2))^2); 
            near = double(distance <= obj.nearThreshold); 
        end
        function addPositionAndPlaceIfDifferent(obj) 
           placeRow = obj.addOutputToPlacesList(); 
           position = [obj.animal.x obj.animal.y];
           positionPlaceRow = [position placeRow]; 
           allSame = min(positionPlaceRow == obj.lastPositionPlaceRow); 
           if ~allSame
             obj.saveForDisplay(position, placeRow, positionPlaceRow);
           end
           obj.lastPositionPlaceRow = positionPlaceRow; 
        end
        function saveForDisplay(obj, position, placeRow, positionPlaceRow)
           result = obj.savePositionForPlace(position, placeRow);             
           obj.placeListDisplay = [obj.placeListDisplay; [result positionPlaceRow]]; 
        end
        function position = getPositionForPlace(obj, placeIdString)
           position = obj.placePositionMap(placeIdString); 
        end
        function row = addOutputToPlacesList(obj)
           row = zeros(1,obj.nPlaceIndices);  
           indices = obj.placeSystem.outputIndices(); 
           len = length(row); 
           if length(row) > length(indices)
               len = length(indices); 
           end
           for ii = 1:len
                row(1,ii) = indices(1,ii); 
           end
           obj.placeList = [obj.placeList; row]; 
%            obj.placeList = [obj.placeList; obj.placeSystem.outputIndices()]; 
        end
        function updateTurnVelocity(obj, velocity)
            obj.angularVelocity = obj.headDirectionSystem.updateTurnVelocity(velocity);
            % HDS calls updateAngularVelocity
            % angularVelocity=radians per time step; negative velocity = clockwise 
        end
        function updateLinearVelocity(obj, velocity)
            obj.linearVelocity = velocity; % meters per time step (ms?)
        end
        function updateTurnAndLinearVelocity(obj, turnVelocity, linearVelocity)
            if (turnVelocity == 0) || (linearVelocity == 0)
                updateTurnVelocity(obj, turnVelocity); 
                updateLinearVelocity(obj, linearVelocity);
            else
                error('HippocampalFormation:VelocitiesNonZero', ...
                    'updateTurnAndLinearVelocity() requires one argument to be zero; cannot both be turning and running simultaneously.') ;
            end
        end
        function updateCurrentHeadDirection(obj)
            obj.currentHeadDirection = obj.headDirectionSystem.getMaxActivationIndex();   
        end
        function cartesianVelocity =  calculateCartesianVelocity(obj)
            radians = (obj.currentHeadDirection/obj.nHeadDirectionCells)*(2*pi); 
            x = cos(radians); 
            y = sin(radians); 
            cartesianVelocity = [x*obj.linearVelocity, y*obj.linearVelocity]; 
        end
        function trimmedPlaceList = trimPlaceListDisplay(obj)
           s = size(obj.placeListDisplay);
           if s(1) > 20
              trimmedPlaceList =  obj.placeListDisplay((s(1)-19):end,:);   
           else
              trimmedPlaceList =  obj.placeListDisplay;    
           end
        end
        function plotPlaces(obj)
           figure(obj.h) 
           axis off
           offset = 0; 
           trimmedPlaceListDisplay = obj.trimPlaceListDisplay();
           dims = size(trimmedPlaceListDisplay); 
           for ii = 1:dims(1)
               result = trimmedPlaceListDisplay(ii,1); 
               row = trimmedPlaceListDisplay(ii,2:dims(2));
               placeMat = mat2str(row(3:end));
               positionPlaceLine = ['x: ', num2str(row(1),3), ...
                   'y: ', num2str(row(2),3), ...
                   'p: ', placeMat(2:end-1)]; 
               if result == 0
                   color = 'r'; 
               elseif result == 1
                   color = [0,0.5,0]; 
               elseif result == 2
                   color = 'b'; 
               end
               text(0,1-offset,positionPlaceLine,'Color',color);
               offset = 0.05 * ii; 
           end
        end
        function plot(~)
            
        end

    end
end