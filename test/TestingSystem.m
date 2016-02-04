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
        function build(obj)
        end
        %% Single time step 
        function  step(obj)
            step@System(obj); 
        end
        function plot(obj)
        end  
    end
end
