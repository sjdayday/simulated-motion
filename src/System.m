% System interface:  all systems implement System
classdef System < handle 

    properties
%         time
    end
    methods (Abstract)
        buildWeights(obj)
        %% Single time step 
        step(obj)
        plot(obj)
    end
end
