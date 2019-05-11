% System interface:  all systems implement System
classdef System < handle 

    properties
        eventMap
        time
        timekeeper
    end
    methods 
        function obj = System()
            obj.eventMap = containers.Map('KeyType','double','ValueType','char');
            obj.time = 0; 
            obj.setTimekeeper(obj); 
        end
        function addEvent(obj, time, event)
            obj.eventMap(time) = event; 
        end
        function events(obj)
%              disp(obj.eventMap.keys()); 
            if obj.eventMap.isKey(obj.getTime())
               eval(obj.eventMap(obj.getTime()));
%                obj.eventMap.remove(obj.getTime());
%                 disp(['System at time: ',obj.time]); 
%                 disp([obj.time,obj.eventMap(obj.time)]); 
            end
        end
        function setTimekeeper(obj, timekeeper) 
           obj.timekeeper = timekeeper; 
        end
        function timekeeper = getTimekeeper(obj) 
           timekeeper = obj.timekeeper;  
        end
        function stepTime(obj) 
           if obj.timekeeper == obj
               obj.time = obj.time+1;
           end
        end
        function time = getTime(obj)
           time = obj.getTimekeeper().time;  
        end
        function  step(obj)
             stepTime(obj); 
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
