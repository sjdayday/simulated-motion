%% TestSystem class:  test System behavior without other dependencies
classdef TestingSystem < System 

    properties
        testProperty
        eventMap
        time
    end
    methods
        function obj = TestingSystem()
            obj.testProperty = 2;
            obj.eventMap = containers.Map('KeyType','double','ValueType','char');
            obj.time = 0; 
        end
        function buildWeights(obj)
        end
        %% Single time step 
        function  step(obj)
            obj.time = obj.time+1;
            events(obj); 
        end
        function events(obj)
            if obj.eventMap.isKey(obj.time)
               eval(obj.eventMap(obj.time));  
%                disp([obj.time,obj.eventMap(obj.time)]); 
            end
        end
        function plot(obj)
        end  
        function addEvent(obj, time, event)
            obj.eventMap(time) = event; 
        end
    end
end
