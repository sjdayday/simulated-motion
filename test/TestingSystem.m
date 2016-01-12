%% TestSystem class:  test System behavior without other dependencies
classdef TestingSystem < System 

    properties
        testProperty
    end
    methods
        function obj = TestingSystem()
            obj = obj@System(); 
            obj.testProperty = 2;
        end
        function buildWeights(obj)
        end
        %% Single time step 
        function  step(obj)
            obj.time = obj.time+1;
            events(obj); 
        end
        function plot(obj)
        end  
%         function addEvent(obj, time, event)
%             obj.eventMap(time) = event; 
%         end
    end
end
