% HippocampalFormation class:  extends System
% models the functions of the hippocampus and entorhinal cortex
classdef HippocampalFormation < System 

    properties
%         wiring
%         currentInputX
        animal
        nHeadDirectionCells
        nCueIntervals
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
%         includeHeadDirectionFeatureInput
        currentHeadDirection
        nFeatureDetectors
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
        hh % graphing stats
        stats
        statsCounter
        placeList
        placeListDisplay
        placePositionMap
        nPlaceIndices
        nearThreshold
        lastPositionPlaceRow
        showIndices
        placeMatchThreshold
        settleToPlace
        sparseOrthogonalizingNetwork
        separateMecLec
        hdsPullsFeatureWeightsFromLec
        orienting
        twoCuesOnly
        placeRecognized
        simulatedMotion
        hdsMinimumVelocity
        hdsAnimalVelocityCalibration
        nextPlacePendingAdditionToSimulatedRunPlaces
        pendingEvaluateSuccessfulRetrace
    end
    methods
        function obj = HippocampalFormation()
            obj = obj@System(); 
            obj.stats = []; 
            obj.statsCounter = 1;
            obj.nHeadDirectionCells = 60;
            obj.nCueIntervals = obj.nHeadDirectionCells;
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
%             obj.includeHeadDirectionFeatureInput = true; 
            obj.randomHeadDirection = true; 
            obj.pullVelocity = true; 
            obj.pullFeatures = true; 
            obj.visual = false; 
            obj.animal = Animal();
            obj.loadFixedRandom();
            obj.currentHeadDirection = 1;
            obj.placePositionMap = containers.Map('KeyType','char','ValueType','any');
            obj.nearThreshold = 0.5;
            obj.placeList = []; 
            obj.placeListDisplay = [];
            obj.updateFeatureDetectors = false; 
            obj.showIndices = false; 
            obj.placeMatchThreshold = 0;
            obj.settleToPlace = false; 
            obj.sparseOrthogonalizingNetwork = false; 
            obj.separateMecLec = false; 
            obj.hdsPullsFeatureWeightsFromLec = false; 
            obj.orienting = false; 
            obj.twoCuesOnly = false;
            obj.placeRecognized = false;
            obj.simulatedMotion = false; 
            obj.hdsMinimumVelocity = pi/20; 
            obj.hdsAnimalVelocityCalibration = 1.0;       
            obj.nextPlacePendingAdditionToSimulatedRunPlaces = false; 
         end
        function build(obj)
            calculateSizes(obj); 
            buildLec(obj); 
            rebuildHeadDirectionSystem(obj); 
%             buildHeadDirectionSystem(obj);
            obj.linkLecAndHeadDirectionSystems(); 
            buildGrids(obj);             
%             buildLec(obj); 
            buildPlaceSystem(obj);
            % TODO: setTimekeeper for placesystem 
        end
        function calculateSizes(obj)
            obj.nGrids = obj.nGridOrientations * obj.nGridGains; 
%             obj.grids(1,obj.nGrids) = GridChartNetwork();
            grids(1,obj.nGrids) = GridChartNetwork();
            obj.grids = grids; 
            obj.nX = obj.gridSize(1,1);
            obj.nY = obj.gridSize(1,2);
            obj.gridLength = obj.nX * obj.nY; 
            obj.nMecOutput = obj.nGrids * obj.gridLength; 
            numberOfLecIndices = 3; % defaults to number of features in 2 cued environment
            obj.nPlaceIndices = obj.nGrids + numberOfLecIndices; 
            obj.nLecOutput = obj.nFeatures * obj.nCueIntervals; 
            nPosition = 2; % [animal.x animal.y] 
            obj.lastPositionPlaceRow = zeros(1,(nPosition+obj.nPlaceIndices)); % position + place            
            obj.nFeatureDetectors = obj.nMecOutput + obj.nLecOutput; 
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
            obj.headDirectionSystem.nHeadDirectionCells = obj.nHeadDirectionCells; 
%             obj.headDirectionSystem.includeFeatureInput = obj.includeHeadDirectionFeatureInput; 
            obj.headDirectionSystem.initializeActivation(obj.randomHeadDirection);
            obj.headDirectionSystem.pullVelocity = obj.pullVelocity; 
            obj.headDirectionSystem.pullFeatures = obj.pullFeatures; 
            obj.headDirectionSystem.minimumVelocity = obj.hdsMinimumVelocity; 
            obj.headDirectionSystem.animalVelocityCalibration  = obj.hdsAnimalVelocityCalibration;        
            obj.headDirectionSystem.pullFeatureWeightsFromLec = obj.hdsPullsFeatureWeightsFromLec; 
            if not(obj.defaultFeatureDetectors)
                obj.headDirectionSystem.nFeatureDetectors = obj.nFeatureDetectors; % obj.nMecOutput + obj.nLecOutput;             
            end
            obj.headDirectionSystem.build(); 
        end
        function linkLecAndHeadDirectionSystems(obj)
            % LEC and HDS mutually dependent, for feature weight processing
            obj.lecSystem.headDirectionSystem = obj.headDirectionSystem;
            obj.headDirectionSystem.lec = obj.lecSystem;             
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
                    obj.grids(1,kk).nFeatureDetectors = obj.nFeatureDetectors;
                    obj.grids(1,kk).build(); 
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
            obj.lecSystem.twoCuesOnly = obj.twoCuesOnly; 
%             obj.lecSystem.distanceUnits = obj.distanceUnits;
            obj.lecSystem.nHeadDirectionCells = obj.nHeadDirectionCells;
            obj.lecSystem.nFeatures = obj.nFeatures; 
            obj.lecSystem.nFeatureDetectors = obj.nFeatureDetectors;
            obj.lecSystem.nCueIntervals = obj.nCueIntervals; 
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
            obj.placeSystem.sparseOrthogonalizingNetwork(obj.sparseOrthogonalizingNetwork, ...
                obj.separateMecLec); 
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
            obj.initializeMecOutput();
            mecOutputOffset = 0; 
            obj.updateCurrentHeadDirection();
            v =  calculateCartesianVelocity(obj);
            for ii = 1:obj.nGrids
                obj.grids(1,ii).updateVelocity(v(1),v(2)); 
                mecOutputOffset = obj.stepGrid(mecOutputOffset, ii);
                disp(['grid ',num2str(ii),': ',num2str(obj.grids(1,ii).getMaxActivation())]);
            end 
            if obj.showIndices
                disp(['MEC output: ',obj.printMecOutputIndices()]);
            end
        end
        function stepLec(obj)
%             obj.lecSystem.buildCanonicalView(obj.currentHeadDirection); 
%            if ~ obj.orienting
            if obj.simulatedMotion
                obj.lecOutput = zeros(1,obj.nLecOutput);  
            else
                obj.lecSystem.buildCanonicalCueActivationForAnimalDirection(obj.animal.currentDirection); 
                obj.lecOutput = obj.lecSystem.lecOutput; 
                
            end
            if obj.showIndices
                disp(['LEC output: ',obj.printLecOutputIndices()]);
            end
        end
        function updateSubsystemFeatureDetectors(obj)
           obj.headDirectionSystem.setFeaturesDetected(obj.placeOutput); 
           obj.lecSystem.featuresDetected = obj.placeOutput; 
           for jj = 1:obj.nGrids
              obj.grids(1,jj).featuresDetected = obj.placeOutput; 
           end            
        end
        function stepPlace(obj)
%            placeRecognized = obj.recallPlace(); 
           obj.recallPlace();            
           if  obj.orienting
               obj.placeOutput = obj.placeSystem.read([obj.mecOutput, obj.lecOutput]);
               if obj.updateFeatureDetectors
                   obj.updateSubsystemFeatureDetectors(); 
               end               
           else
               obj.placeOutput = obj.placeSystem.step(obj.mecOutput, obj.lecOutput);
               if obj.updateFeatureDetectors
                   obj.updateSubsystemFeatureDetectors(); 
               end
               if obj.placeRecognized && obj.settleToPlace
                 obj.settle();  
               else
                 obj.lecSystem.updateFeatureWeights();
                 obj.updateGridsFeatureWeights();
                 % same for HDS?  
               end 
               
           end
               % TODO:  reconcile readMode, combine with LEC featureWeights
%            obj.placeOutput = obj.placeSystem.step(obj.mecOutput, obj.lecOutput);
%            if obj.updateFeatureDetectors
%                obj.updateSubsystemFeatureDetectors(); 
%            end
%            if placeRecognized && obj.settleToPlace
%               obj.settle();  
%            else
%                % TODO:  reconcile readMode, combine with LEC featureWeights
%            if ~ obj.orienting
%                 obj.lecSystem.updateFeatureWeights();
%                 obj.updateGridsFeatureWeights();  
%            end
%               obj.updateGridsFeatureWeights();  
%            end
           obj.addPositionAndPlaceIfDifferent(); 
           if obj.showIndices
                disp(['Place output: ',obj.printPlaceOutputIndices()]);
                obj.printPlaceFieldStats(); 
           end
           if (obj.nextPlacePendingAdditionToSimulatedRunPlaces) 
              obj.animal.motorCortex.addPlaceToSimulatedRunPlaces(obj.placeOutputIndices());
              obj.nextPlacePendingAdditionToSimulatedRunPlaces = false; 
           end
           if obj.pendingEvaluateSuccessfulRetrace
              obj.animal.motorCortex.evaluateSuccessfulRetrace(obj.placeOutputIndices());  
              obj.pendingEvaluateSuccessfulRetrace = false; 
           end
        end
        function addNextPlaceToSimulatedRunPlaces(obj)
           obj.nextPlacePendingAdditionToSimulatedRunPlaces = true;  
        end
        function evaluateSuccessfulRetrace(obj)
           obj.pendingEvaluateSuccessfulRetrace = true; 
        end
        function placeRecognized = recallPlace(obj)
           placeRecognized = obj.placeSystem.recallPlace([obj.mecOutput, obj.lecOutput]); 
           disp(['Place recognized: ',num2str(placeRecognized)]);                                 
           obj.placeRecognized = placeRecognized; 
        end
        function updateGridsFeatureWeights(obj)
           for jj = 1:obj.nGrids
              obj.grids(1,jj).readMode = 0;
              obj.grids(1,jj).updateFeatureWeights(); % or update...FeatureInputs? 
           end            
        end
        function initializeMecOutput(obj)
            obj.mecOutput = zeros(1,obj.nMecOutput); 
        end
        
        function mecOutputOffset = stepGrid(obj, mecOutputOffset, ii)
            obj.grids(1,ii).step(); 
            max = obj.grids(1,ii).getMaxActivationIndex(); 
            mecOutputOffset = updateMecOutput(obj, mecOutputOffset, max); 
        end
        function mecOutputOffset = updateMecOutput(obj, mecOutputOffset, max)
            obj.mecOutput(1,mecOutputOffset+max) = 1; 
            mecOutputOffset = mecOutputOffset + obj.gridLength;                             
        end
        function indices = mecOutputIndices(obj)
           indices = obj.outputIndices(obj.mecOutput);   
        end
        function indices = lecOutputIndices(obj)
           indices = obj.outputIndices(obj.lecOutput);   
        end
        function indices = placeOutputIndices(obj)
           indices = obj.outputIndices(obj.placeOutput);   
        end
        function indices = outputIndices(~, output)
           indices = find(output == 1);    
        end
        function print = printPlaceOutputIndices(obj)
           print = mat2str(obj.placeOutputIndices());   
        end
        function print = printMecOutputIndices(obj)
           print = mat2str(obj.mecOutputIndices());   
        end
        function print = printLecOutputIndices(obj)
           print = mat2str(obj.lecOutputIndices());   
        end
        
        function settle(obj)
%            disp(['settling to: ', mat2str(obj.placeSystem.outputIndices())]); % mat2str(find(obj.placeSystem.placeId == 1))]); 
            disp(['hds features detected: ', mat2str(find(obj.headDirectionSystem.featuresDetected == 1))]); 
            disp(['grid(1) features detected: ', mat2str(find(obj.grids(1).featuresDetected == 1))]);             
% %             obj.placeSystem.placeId
            obj.setReadMode(1);
            obj.settleHds(); 
            obj.settleGrids();
            if obj.showIndices
                disp(['MEC output after settling: ',obj.printMecOutputIndices()]);
            end

            obj.setReadMode(0);            
        end
        function settleHds(obj) 
            disp('about to settle HDS'); 
            lastHdsActivation = obj.headDirectionSystem.getMaxActivationIndex(); 
            newHdsActivation = 0; 
            disp(['about to settle HDS from: ', num2str(lastHdsActivation)]);
            obj.stepHds(); 
            while newHdsActivation ~=  lastHdsActivation 
                lastHdsActivation = obj.headDirectionSystem.getMaxActivationIndex();
                disp(['settling HDS ', num2str(obj.headDirectionSystem.getMaxActivationIndex())]); 
                obj.stepHds();
                obj.stepHds(); % once more for good measure                
                obj.stepHds();
                obj.stepHds();
                newHdsActivation = obj.headDirectionSystem.getMaxActivationIndex();
            end            
        end
        function settleGrids(obj)
            obj.initializeMecOutput();
            mecOutputOffset = 0;
            for ii = 1:obj.nGrids
              newGridActivation = obj.grids(ii).settle();  
              mecOutputOffset = obj.updateMecOutput(mecOutputOffset, newGridActivation);
           end
        end
        function setReadMode(obj, mode)
            obj.headDirectionSystem.readMode = mode;
            obj.lecSystem.readMode = mode; 
% done in GCN settle
            for ii = 1:obj.nGrids
              obj.grids(ii).readMode = mode;  
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
        function counts=calculatePlaceFieldStats(obj)
           counts = zeros(1,3); 
           c = obj.placeListDisplay(:,1)';
           cc = size(find(c == 0));
           counts(1) = cc(2); 
           cc = size(find(c == 1));
           counts(2) = cc(2); 
           cc = size(find(c == 2));
           counts(3) = cc(2); 
        end
        function printPlaceFieldStats(obj)
           counts = obj.calculatePlaceFieldStats();
           ratio = counts(2)/counts(3);
           disp(['Place fields -- novel: ',num2str(counts(3)),'  near: ',num2str(counts(2)),'  far: ',num2str(counts(1)),'  near/novel ratio: ',num2str(ratio)]);
           obj.gatherStats([ratio, obj.placeSystem.saturation()]);
        end
        function gatherStats(obj, percents) 
           if obj.statsCounter == 10
                obj.stats = [obj.stats; percents]; 
                obj.graphStats(); 
                obj.statsCounter = 1; 
           else
                obj.statsCounter = obj.statsCounter + 1; 
           end
        end
        function graphStats(obj)
            % commented 2/3 for demo
%             if ishandle(obj.hh) 
%                 plot(obj.stats(:,1));
%                 hold on
%                 plot(obj.stats(:,2)); 
%             else
%                 obj.hh = figure; 
%             end
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
                   ' y: ', num2str(row(2),3), ...
                   ' p: ', placeMat(2:end-1)]; 
               if result == 0
                   color = 'r'; % red, place found, but far from previous x,y position 
               elseif result == 1
                   color = [0,0.5,0]; % green, place found, near to previous x,y position
               elseif result == 2
                   color = 'b'; % blue, new
               end
               text(0,1-offset,positionPlaceLine,'Color',color);
               offset = 0.05 * ii; 
           end
        end
        function plot(~)
            
        end

    end
end