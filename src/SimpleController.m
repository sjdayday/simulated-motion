%% SimpleController class:  default controller for Animal
%  
classdef SimpleController < System 

    properties
        animal
    end
    methods
        function obj = SimpleController(animal)
            obj.animal = animal;
        end
        function setChildTimekeeper(obj, timekeeper) 
           obj.setTimekeeper(timekeeper); 
           obj.animal.setChildTimekeeper(timekeeper);  
        end
        function step(obj)            
           step@System(obj); 
           % no events
           obj.animal.step(); 
        end
        function build(obj)
           obj.setChildTimekeeper(obj); 
        end
        function plot(obj)
        end
    end
end
