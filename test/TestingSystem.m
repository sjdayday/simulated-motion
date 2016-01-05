%% TestSystem class:  test System behavior without other dependencies
classdef TestingSystem < System 

    properties
        testProperty
%         time
    end
    methods
        function obj = TestingSystem()
            obj.testProperty = 2; 
        end
        function buildWeights(obj)
        end
        %% Single time step 
        function  step(obj)
%             obj.time = obj.time+1;
        end
        function plot(obj)
        end        
    end
end
