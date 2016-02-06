% PlaceSystem class:  extends AutoassociativeNetwork
% models the functions of the hippocampus:  Dentate Gyrus and CA3
classdef HippocampalFormation < System 

    properties
%         wiring
%         currentInputX
        nHeadDirectionCells
        nGrids
        nGridOrientations
        nGridGains
        grids
        baseGain
        gridSize
        gridDirectionBiasIncrement
        gridLength
        nFeatures
        distanceUnits
        rewardInput
        reward
        placeSystem
        mecOutput
        nMecOutput
        headDirectionSystem
        featureOutput
        nLecOutput
    end
    methods
        function obj = HippocampalFormation()
            obj = obj@System(); 
            obj.nHeadDirectionCells = 12; 
            obj.nGridOrientations = 1; 
            obj.gridDirectionBiasIncrement = pi/6;
            obj.nGridGains = 1; 
            obj.gridSize = [10,9];
            obj.nFeatures = 1; 
            obj.baseGain = 1000; 
            obj.distanceUnits = 5; 
            obj.rewardInput = false; 
            obj.reward = []; 
        end
        function build(obj)
            obj.headDirectionSystem = HeadDirectionSystem(obj.nHeadDirectionCells); 
            buildGrids(obj); 
            buildLec(obj); 
            obj.placeSystem = PlaceSystem(obj.nMecOutput, obj.nLecOutput); 
        end
            
        function buildGrids(obj) 
            obj.nGrids = obj.nGridOrientations * obj.nGridGains; 
            grids(1,obj.nGrids) = GridChartNetwork();
            obj.grids = grids; 
            nX = obj.gridSize(1,1);
            nY = obj.gridSize(1,2);
            obj.gridLength = nX * nY; 
            obj.nMecOutput = obj.nGrids * obj.gridLength; 
            gain = obj.baseGain; 
            index = 0; 
            for ii = 1:obj.nGridGains
                bias = 0; 
                for jj = 1:obj.nGridOrientations
                    kk = index*obj.nGridOrientations+jj; 
                    obj.grids(1,kk) = GridChartNetwork(nX, nY); 
                    obj.grids(1,kk).inputDirectionBias = bias; 
                    obj.grids(1,kk).inputGain = gain; 
                    bias = bias + obj.gridDirectionBiasIncrement;
                end
                gain = gain * 1.42; 
                index = index + 1; 
            end
        end
        function buildLec(obj)
            featureLength = obj.distanceUnits + obj.nHeadDirectionCells; 
            obj.featureOutput = zeros(1, obj.nFeatures * featureLength); 
            if obj.rewardInput 
               obj.reward = zeros(1,5);  
            end
            obj.nLecOutput = length(obj.featureOutput) + length(obj.reward); 
        end
        function step(obj)
            obj.mecOutput = zeros(1,obj.nMecOutput); 
            index = 0; 
            for ii = 1:obj.nGrids
                obj.grids(1,ii).step(); 
                max = obj.grids(1,ii).getMaxActivationIndex(); 
                obj.mecOutput(1,index+max) = 1; 
                index = index + obj.gridLength;     
            end
        end

%         %% Single time step 
% %         step(obj)
%         plot(obj)
% %         addEvent(obj, time, event)
% 
        function plot(obj)
            
        end

    end
end