%% LecSystem class:  simple model of Lateral Entorhinal Cortex (LEC)
classdef LecSystem < System 

    properties
        distanceUnits
        nHeadDirectionCells
        nFeatures
        rewardUnits
        reward
        nOutput
        featureOutput
    end
    methods
        function obj = LecSystem()
            obj = obj@System(); 
            obj.distanceUnits = 8;
            obj.nHeadDirectionCells = 60;
            obj.nFeatures = 3; 
            obj.rewardUnits = 5; 
            obj.build();            
        end
        function build(obj)
            featureLength = obj.distanceUnits + obj.nHeadDirectionCells; 
            obj.featureOutput = zeros(1, obj.nFeatures * featureLength); 
            obj.reward = zeros(1,obj.rewardUnits);  
            obj.nOutput = length(obj.featureOutput) + obj.rewardUnits; 

        end
        %% Single time step 
        function  step(obj)
            step@System(obj); 
        end
        function plot(obj)
        end  
    end
end
