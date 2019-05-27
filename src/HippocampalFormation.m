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
        randomHeadDirection
        pullVelocity
        visual
        h
        placeList
        placeListDisplay
        placePositionMap
        nPlaceIndices
        nearThreshold
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
            obj.visual = false; 
            obj.animal = Animal();
            obj.loadFixedRandom();
            obj.currentHeadDirection = 1;
            obj.placePositionMap = containers.Map('KeyType','char','ValueType','any');
            obj.nearThreshold = 0.2;
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
            obj.nPlaceIndices = obj.nGrids + 3; 
            obj.placeList = []; 
            obj.placeListDisplay = []; 
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
            if not(obj.defaultFeatureDetectors)
                obj.headDirectionSystem.nFeatureDetectors = obj.nMecOutput + obj.nLecOutput;             
            end
            obj.headDirectionSystem.build(); 
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
            obj.placeSystem = PlaceSystem(obj.nMecOutput, obj.nLecOutput);             
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
        end
        function stepLec(obj)
            obj.lecSystem.buildCanonicalView(obj.currentHeadDirection); 
            obj.lecOutput = obj.lecSystem.lecOutput; 
        end
        function stepPlace(obj)
           obj.placeOutput = obj.placeSystem.step(obj.mecOutput, obj.lecOutput);
           obj.addPositionAndOutput(); 
           obj.headDirectionSystem.featuresDetected = obj.placeOutput; 
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
        function addPositionAndOutput(obj) 
           placeIdRow = obj.addOutputToPlacesList(); 
           position = [obj.animal.x obj.animal.y];
           result = obj.savePositionForPlace(position, placeIdRow); 
           positionPlaceRow = [position placeIdRow]; 
           dims = size(obj.placeListDisplay); 
           len = dims(1); 
           if (len == 0)
               obj.placeListDisplay = [obj.placeListDisplay; positionPlaceRow]; 
           elseif len >= 1
               previousRow = obj.placeListDisplay(len,:); 
               allSame = min(positionPlaceRow == previousRow); 
               if ~allSame
                 obj.placeListDisplay = [obj.placeListDisplay; positionPlaceRow]; 
               end
           end           
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
        function plot(obj)
            
        end

    end
end