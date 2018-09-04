% System interface:  all systems implement System
classdef System < handle 

    properties
        eventMap
        time
    end
    methods 
        function obj = System()
            obj.eventMap = containers.Map('KeyType','double','ValueType','char');
            obj.time = 0; 
        end
        function addEvent(obj, time, event)
            obj.eventMap(time) = event; 
        end
        function events(obj)
%              disp(obj.eventMap.keys()); 
            if obj.eventMap.isKey(obj.time)
               eval(obj.eventMap(obj.time));
%                 disp(['System at time: ',obj.time]); 
%                 disp([obj.time,obj.eventMap(obj.time)]); 
            end
        end
        function  step(obj)
            obj.time = obj.time+1;
            events(obj); 
        end
        function loadFixedRandom(~)
           load '../rngDefaultSettings';
           rng(rngDefault);                
        end
    end
    methods (Abstract)
        build(obj)
        %% Single time step 
%         step(obj)
        plot(obj)
%         addEvent(obj, time, event)
    end
end
