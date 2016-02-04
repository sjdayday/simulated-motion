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
        gridSize
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
            obj.nGridGains = 1; 
            obj.gridSize = [10,9];
            obj.nFeatures = 1; 
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
            obj.nGrids = obj.nGridOrientations + obj.nGridGains - 1; 
            gridLength = obj.gridSize(1,1) * obj.gridSize(1,2); 
            obj.mecOutput = zeros(1,obj.nGrids * gridLength); 
            obj.nMecOutput = length(obj.mecOutput); 
        end
        function buildLec(obj)
            featureLength = obj.distanceUnits + obj.nHeadDirectionCells; 
            obj.featureOutput = zeros(1, obj.nFeatures * featureLength); 
            if obj.rewardInput 
               obj.reward = zeros(1,5);  
            end
            obj.nLecOutput = length(obj.featureOutput) + length(obj.reward); 
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