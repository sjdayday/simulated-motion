% GridChartNetwork class:  model a network of grid cells as a single chart
% From code by eric zilli - 20110829 - v1.01:
% http://senselab.med.yale.edu/ModelDb/showModel.cshtml?model=144006&file=/grid%20models%20package%20v1.007/GuanellaEtAl2007.m
% Zilli, E. A. (2012). Models of grid cell spatial firing published 2005?2011. 
% Frontiers in neural circuits, 6.
% This was Eric's implementation of: 
% Guanella, Kiper, and Verschure 2007's twisted torus attractor model
% Guanella, A., Kiper, D., & Verschure, P. (2007). 
% A model of grid cells based on a twisted torus topology. 
% International journal of neural systems, 17(04), 231-240.
classdef GridChartNetwork < handle 

    properties
        nX 
        nY
        nCells
        inputGain
        inputDirectionBias
        weightStdDev 
        peakSynapticStrength
        shiftInhibitoryTail
        normalizedWeight
        positiveHorizontalWeights
        negativeHorizontalWeights
        positiveVerticalWeights
        negativeVerticalWeights
        horizonalWeightInputVector
        verticalWeightInputVector
        maxMotionWeight
        sigmaMotionWeight
        motionWeightOffset
        dt
        % stabilizationTime 
        velocity
        activation
        watchCell
        nSpatialBins
        minX
        maxX
        minY
        maxY
        occupancy 
        spikes 
        spikeCoords
        spikeind
        directionInput 
        jX
        jY
        iX
        iY
        weights
        position
        velocities
        time
        firstPlot
        h
        gh
        Ahist
        AhistAll
        motionInputWeights
        squaredPairwiseDists
    end
    methods
        function obj = GridChartNetwork(nX, nY)
            % number of cells in X direction; suggest 10*k, k positive int
            obj.nX = nX; 
            % number of cells in Y direction; suggest 9*k 
            obj.nY = nY; % number of cells in y direction
            obj.nCells = nX*nY;
            % grid spacing is approx 1.02 - 0.48*log2(alpha), pg 236
            obj.inputGain = 30; % alpha
            obj.inputDirectionBias = 0; % beta--(grid orientation), radians
            obj.weightStdDev = 0.24; % 0.24 sigma--exponential weight std. deviation
            obj.peakSynapticStrength = 0.3; % 0.3 I 
            % T--shift so tail of exponential weights turn inhibitory
            obj.shiftInhibitoryTail = 0.05;
            % tau--relative weight of normalized vs. full-strength synaptic inputs
            obj.normalizedWeight = 0.8; % 0.8 
            obj.dt = 20; % time step in milliseconds
            % obj.stabilizationTime = 80; % no-velocity time for pattern to form, ms
            obj.velocity = [0; 0]; % v--velocity, m/ms  
            obj.firstPlot = 1; % first call to plot opens the figure
%             obj.gh = [];  % override 
            obj.time = 0; % time step 
            obj.maxMotionWeight = 1; 
            obj.sigmaMotionWeight = 2; 
            obj.horizonalWeightInputVector = obj.maxMotionWeight* ...
                (normpdf(0:obj.nY-1,0,obj.sigmaMotionWeight)+ ...
                normpdf(0:obj.nY-1,obj.nX,obj.sigmaMotionWeight));
            obj.verticalWeightInputVector = obj.maxMotionWeight* ...
                (normpdf(0:obj.nX-1,0,obj.sigmaMotionWeight)+ ...
                normpdf(0:obj.nX-1,obj.nX,obj.sigmaMotionWeight));
            obj.motionWeightOffset = 1; 
            obj.motionInputWeights = 0; 
            obj.squaredPairwiseDists = []; 
            buildNetwork(obj);
%             obj.Ahist = zeros(10000,1); 
%             obj.AhistAll = zeros(1000, obj.nCells); 

        end
        function buildNetwork(obj)
            % A--activation of each cell
            obj.activation = rand(1,obj.nCells)/sqrt(obj.nCells); 
            % which cell's spatial activity will be plotted?
            obj.watchCell = round(obj.nCells/2-obj.nY/2); 
            obj.nSpatialBins = 60;
            obj.minX = -0.90; 
            obj.maxX = 0.90; % m
            obj.minY = -0.90; 
            obj.maxY = 0.90; % m
            obj.occupancy = zeros(obj.nSpatialBins);
            obj.spikes = zeros(obj.nSpatialBins);
            obj.spikeCoords = zeros(2000,2);
            obj.spikeind = 1;
            obj.directionInput = [cos(obj.inputDirectionBias) ...
                -sin(obj.inputDirectionBias); ... 
                sin(obj.inputDirectionBias) ... 
                cos(obj.inputDirectionBias)]; % R
            buildWeightMatrix(obj);
            loadTrajectory(obj);
        end
        function buildWeightMatrix(obj) 
            %% Comments from Zilli: 
            %% Make x a 2-by-ncells vector of the 2D cell positions on the neural sheet
            x = ((1:obj.nX) - 0.5)/obj.nX;
            y = sqrt(3)/2*((1:obj.nY) - 0.5)/obj.nY;
            [X,Y] = meshgrid(x,y);
            % x's first row is the x coordinates and second row the y coordinates
            x = [reshape(X,1,[]); reshape(Y,1,[])];

            % Weight matrix variables
            % We compute the weight matrix in one big vectorized step, so we need
            % to eventually make a big matrix where entry i,j is the distance between
            % cells i and j. To do this, we'll make four big matrices (that we reshape
            % into vectors for later). We will calculate the distance from i to j
            % along the X axis and Y axis separately, so we need the x coordinates for
            % each cell i, ix, as well as the x coordinates for each cell j, jx, and
            % similarly the y axes. The i and j matrices must have the coordinates
            % arranged in different directions (jx has the same x coordinate in each
            % column and ix the same coordinate in each row). Then ix-jx calculates
            % each pairwise distance of x coordinates, and similarly iy-jy.
            [jx,ix] = meshgrid(x(1,:),x(1,:));
            [jy,iy] = meshgrid(x(2,:),x(2,:));
            obj.jX = reshape(jx,1,[]);
            obj.iX = reshape(ix,1,[]);
            obj.jY = reshape(jy,1,[]);
            obj.iY = reshape(iy,1,[]);
            obj.weights = ones(obj.nCells); % W 
            
%                     positiveHorizontalWeights
%         negativeHorizontalWeights
%         positiveVerticalWeights
%         negativeVerticalWeights
%         horizonalWeightInputVector
%         verticalWeightInputVector
%         maxMotionWeight
%         sigmaMotionWeight
            [obj.positiveHorizontalWeights, obj.negativeHorizontalWeights] = ... 
                buildMotionWeights(obj, obj.horizonalWeightInputVector);

%             buildMotionWeights(obj, obj.positiveHorizontalWeights, ... 
%                 obj.negativeHorizontalWeights, obj.horizonalWeightInputVector);
            % negative weights first because after transposition,
            % "increasing" means moving the row to the left (negative)
%             buildMotionWeights(obj, obj.negativeVerticalWeights, ... 
%                 obj.positiveVerticalWeights, obj.verticalWeightInputVector);
            [obj.negativeVerticalWeights, obj.positiveVerticalWeights] = ...
                buildMotionWeights(obj, obj.verticalWeightInputVector);
        end
        function [positiveWeights, negativeWeights] = buildMotionWeights(obj, inputVector)
            positiveWeights = toeplitz(inputVector); 
            negativeWeights = positiveWeights ; 
            positiveWeights = ... 
                [positiveWeights((1+obj.motionWeightOffset):end,:); ...
                positiveWeights(1:obj.motionWeightOffset,:)];
            negativeWeights = ... 
                [negativeWeights((end-obj.motionWeightOffset+1):end,:); ...
                negativeWeights(1:end-obj.motionWeightOffset,:)];  
        end
        function loadTrajectory(obj)
          load 'data/HaftingTraj_centimeters_seconds.mat' pos;  
          obj.position = pos; 
          %load data/HaftingTraj_centimeters_seconds.mat pos;
          % our time units are in ms so:
          obj.position(3,:) = obj.position(3,:)*1e3; % s to ms
          % interpolate down to simulation time step
          obj.position = [interp1(obj.position(3,:),obj.position(1,:), ...
                0:obj.dt:obj.position(3,end));
                interp1(obj.position(3,:),obj.position(2,:), ... 
                0:obj.dt:obj.position(3,end));
                interp1(obj.position(3,:),obj.position(3,:), ... 
                0:obj.dt:obj.position(3,end))];
          obj.position(1:2,:) = obj.position(1:2,:)/100; % cm to m
          obj.velocities = [diff(obj.position(1,:)); ...
                diff(obj.position(2,:))]/obj.dt; % m/s
        end
        function buildSquaredPairwiseDists(obj)
            if obj.motionInputWeights == false
                % Compute the pairwise distances of cells with the second cell shifted
                % in each of seven directions, then for each point pick the smallest
                % distance out of the seven shifted points.
                clear obj.squaredPairwiseDists;
                obj.squaredPairwiseDists = ... 
                  (obj.iX-obj.jX +0 +obj.inputGain*obj.velocity(1)).^2 + ... 
                  (obj.iY-obj.jY +0 +obj.inputGain*obj.velocity(2)).^2;
                obj.squaredPairwiseDists(2,:) = ... 
                  (obj.iX-obj.jX -0.5 +obj.inputGain*obj.velocity(1)).^2 + ...
                  (obj.iY-obj.jY +sqrt(3)/2 +obj.inputGain*obj.velocity(2)).^2;
                obj.squaredPairwiseDists(3,:) = ... 
                  (obj.iX-obj.jX -0.5 +obj.inputGain*obj.velocity(1)).^2 + ... 
                  (obj.iY-obj.jY -sqrt(3)/2 +obj.inputGain*obj.velocity(2)).^2;
                obj.squaredPairwiseDists(4,:) = ...
                  (obj.iX-obj.jX +0.5 +obj.inputGain*obj.velocity(1)).^2 + ... 
                  (obj.iY-obj.jY +sqrt(3)/2 +obj.inputGain*obj.velocity(2)).^2;
                obj.squaredPairwiseDists(5,:) = ... 
                  (obj.iX-obj.jX +0.5 +obj.inputGain*obj.velocity(1)).^2 + ... 
                  (obj.iY-obj.jY -sqrt(3)/2 +obj.inputGain*obj.velocity(2)).^2;
                obj.squaredPairwiseDists(6,:) = ... 
                  (obj.iX-obj.jX -1 +obj.inputGain*obj.velocity(1)).^2 + ... 
                  (obj.iY-obj.jY +0 +obj.inputGain*obj.velocity(2)).^2;
                obj.squaredPairwiseDists(7,:) = ... 
                  (obj.iX-obj.jX +1 +obj.inputGain*obj.velocity(1)).^2 + ... 
                  (obj.iY-obj.jY +0 +obj.inputGain*obj.velocity(2)).^2;
                obj.squaredPairwiseDists = min(obj.squaredPairwiseDists);
                obj.squaredPairwiseDists = reshape(obj.squaredPairwiseDists,obj.nCells,obj.nCells)';
            else
                if obj.time == 1
                    clear obj.squaredPairwiseDists;
                    obj.squaredPairwiseDists = ... 
                      (obj.iX-obj.jX +0 ).^2 + ... 
                      (obj.iY-obj.jY +0 ).^2;
                    obj.squaredPairwiseDists(2,:) = ... 
                      (obj.iX-obj.jX -0.5 ).^2 + ...
                      (obj.iY-obj.jY +sqrt(3)/2 ).^2;
                    obj.squaredPairwiseDists(3,:) = ... 
                      (obj.iX-obj.jX -0.5 ).^2 + ... 
                      (obj.iY-obj.jY -sqrt(3)/2 ).^2;
                    obj.squaredPairwiseDists(4,:) = ...
                      (obj.iX-obj.jX +0.5 ).^2 + ... 
                      (obj.iY-obj.jY +sqrt(3)/2 ).^2;
                    obj.squaredPairwiseDists(5,:) = ... 
                      (obj.iX-obj.jX +0.5 ).^2 + ... 
                      (obj.iY-obj.jY -sqrt(3)/2 ).^2;
                    obj.squaredPairwiseDists(6,:) = ... 
                      (obj.iX-obj.jX -1 ).^2 + ... 
                      (obj.iY-obj.jY +0 ).^2;
                    obj.squaredPairwiseDists(7,:) = ... 
                      (obj.iX-obj.jX +1 ).^2 + ... 
                      (obj.iY-obj.jY +0 ).^2;
                    obj.squaredPairwiseDists = min(obj.squaredPairwiseDists);
                    obj.squaredPairwiseDists = reshape(obj.squaredPairwiseDists,obj.nCells,obj.nCells)';
                    
                end
            end

        end
        function horizontalInput = calculateHorizontalInput(obj)
            % build the input one row at a time; more efficient
            % suggestions welcomed!
            activationMatrix = reshape(obj.activation,obj.nX,obj.nY);
            horizontalInput = zeros(obj.nX,obj.nY); 
            horizontalVelocity = obj.velocity(1,1); 
            if horizontalVelocity >= 0 
                horizontalWeights = obj.positiveHorizontalWeights;
            else
                horizontalWeights = obj.negativeHorizontalWeights;
            end
            for ii = 1:obj.nY
                horizontalInput(ii,:) = activationMatrix(ii,:) * ...
                    abs(horizontalVelocity) * horizontalWeights;
            end
        end
        function verticalInput = calculateVerticalInput(obj)
            % transpose so that vertical changes processed by row
            activationMatrix = reshape(obj.activation,obj.nX,obj.nY);
            transposedActivation = activationMatrix'; 
            verticalInput = zeros(obj.nY,obj.nX); 
            verticalVelocity = obj.velocity(2,1); 
            if verticalVelocity >= 0 
                verticalWeights = obj.positiveVerticalWeights;
            else
                verticalWeights = obj.negativeVerticalWeights;
            end
            for ii = 1:obj.nY
                verticalInput(ii,:) = transposedActivation(ii,:) * ...
                    abs(verticalVelocity) * verticalWeights;
            end
            verticalInput = verticalInput'; 
%             build the shifted matrix one row at a time: 
% aa = [0 0 0 1 0 0 0 1 2 1 0 1 2 3 2 0 0 1 2 1 0 0 0 1 0];
% bb = reshape(aa,5,5)
% ww = [0 1 2 1 0; 0 0 1 2 1; 1 0 0 1 2; 2 1 0 0 1; 1 2 1 0 0];
% ww
% bb
% zz = zeros(5)
% zz(1,:) = bb(1,:) * ww;
% zz(2,:) = bb(2,:) * ww;
% zz(3,:) = bb(3,:) * ww;
% zz(4,:) = bb(4,:) * ww;
% zz(5,:) = bb(5,:) * ww;
% bbt = bb?
% zz = zeros(5)
% zz(1,:) = bbt(1,:) * ww;
% zz(2,:) = bbt(2,:) * ww;
% zz(3,:) = bbt(3,:) * ww;
% zz(4,:) = bbt(4,:) * ww;
% zz(5,:) = bbt(5,:) * ww;
% zz?

        end
        function buildVelocity(obj)
              obj.velocity = obj.velocities(:,obj.time); % m/s            
              % to change the grid orientation, this model rotates the velocity input
              obj.velocity = obj.directionInput*obj.velocity;
        end
        function  step(obj)
            obj.time = obj.time+1;
            buildVelocity(obj);
            %% Generate new weight matrix for current velocity

            buildSquaredPairwiseDists(obj);
        
%               clockwiseInput =
%               obj.uActivation*(obj.clockwiseVelocity*obj.clockwiseWeights);
%               % from HDS
              % Weights have an excitatory center that peaks at 
              % I-T (peakSynapticStrength-shiftInhibitoryTail) and if T>0, the
              % weights are inhibitory for sufficiently high distances; specifically,
              % for distance > sigma*sqrt(-log(T/I)).
              % self-activation
%             activationFunction(obj); 
%             clockwiseInput = obj.uActivation*(obj.clockwiseVelocity*obj.clockwiseWeights); 
%             counterClockwiseInput = obj.uActivation*(obj.counterClockwiseVelocity*obj.counterClockwiseWeights); 
%             featureInput = obj.featuresDetected * obj.featureWeights; 
%             synapticInput = obj.rate*obj.wHeadDirectionWeights*obj.dx + ...
%                 clockwiseInput + counterClockwiseInput + featureInput; 
             
            obj.weights = obj.peakSynapticStrength * ... 
            exp(-obj.squaredPairwiseDists/obj.weightStdDev^2) - ... 
            obj.shiftInhibitoryTail;

            synapticInput = obj.activation*obj.weights';

              % Activity based on the synaptic input.
              % Notice synapticInput/sum(activation) is equivalent to 
              % (activation/sum(activation))*weights', so the second
              % term is normalizedWeight times the synaptic inputs that would occur if the total
              % activity were normalized to 1. The first term is (1-normalizedWeight) times
              % the full synaptic activity. normalizedWeight is between 0 and 1 and weights
              % whether the input is completely normalized (normalizedWeight=1) or completely
              % "raw" or unnormalized (normalizedWeight=0).
            obj.activation = (1-obj.normalizedWeight)*synapticInput + ... 
              obj.normalizedWeight*(synapticInput/sum(obj.activation));

              % Save activity of one cell for nostalgia's sake
%               obj.Ahist(obj.time) = obj.activation(1,1);
%               obj.AhistAll(obj.time,:) = obj.activation; 
              % Zero out negative activities
            obj.activation(obj.activation<0) = 0;
            saveStatistics(obj); 
        end

        function saveStatistics(obj)
          % Save firing field information
%               if useRealTrajectory
            if obj.activation(obj.watchCell)>0
              if obj.spikeind==size(obj.spikeCoords,1)
                % allocate space for next 1000 spikes:
                obj.spikeCoords(obj.spikeind+1000,:) = [0 0];
                obj.spikeCoords(obj.spikeind+1,:) = ...
                    [obj.position(1,obj.time) obj.position(2,obj.time)];
              else
                obj.spikeCoords(obj.spikeind+1,:) = ... 
                    [obj.position(1,obj.time) obj.position(2,obj.time)];
              end
              obj.spikeind = obj.spikeind+1;
            end
            xindex = round((obj.position(1,obj.time)-obj.minX) / ...
                (obj.maxX-obj.minX)*obj.nSpatialBins)+1;
            yindex = round((obj.position(2,obj.time)-obj.minY) / ...
                (obj.maxY-obj.minY)*obj.nSpatialBins)+1;
            obj.occupancy(yindex,xindex) = obj.occupancy(yindex,xindex) + obj.dt;
            obj.spikes(yindex,xindex) = obj.spikes(yindex,xindex) + obj.activation(obj.watchCell);
        end
        function plotActivation(obj)
            figure(obj.h);
            imagesc(reshape(obj.activation,obj.nY,obj.nX));
            axis square
            title('Population activity')
            set(gca,'ydir','normal')            
        end
        function plotRateMap(obj)
            figure(obj.h);
            imagesc(obj.spikes./obj.occupancy);
            axis square
            set(gca,'ydir','normal')
            t = obj.time*obj.dt; 
            title({sprintf('t = %.1f ms',t),'Rate map'});
        end
        function plotTrajectory(obj)
            figure(obj.h);
            plot(obj.position(1,1:obj.time),obj.position(2,1:obj.time));
            hold on;
            if ~isempty(obj.spikeCoords)
                plot(obj.spikeCoords(2:obj.spikeind,1), ... 
                obj.spikeCoords(2:obj.spikeind,2),'r.')
            end
            title({'Trajectory (blue)','and spikes (red)'})
            axis square
        end
        function plotAll(obj, rowIndex)
            figure(obj.h);
            subplot(obj.gh(rowIndex,1));
            plotActivation(obj);
            subplot(obj.gh(rowIndex,2));
            plotRateMap(obj)
            subplot(obj.gh(rowIndex,3));
            plotTrajectory(obj)
            drawnow
        end        
        function plot(obj)
            if obj.firstPlot
                obj.h = figure('color','w');
                drawnow
                obj.firstPlot = 0;
                obj.gh = gobjects(1,3); 
                obj.gh(1,1) = subplot(1,3,1); 
                obj.gh(1,2) = subplot(1,3,2); 
                obj.gh(1,3) = subplot(1,3,3);                 
            end
            plotAll(obj,1); 
%             figure(obj.h);
%             subplot(131);
%             plotActivation(obj);
%             subplot(132);
%             plotRateMap(obj)
%             subplot(133);
%             plotTrajectory(obj)
            drawnow
        end        
    end
end
