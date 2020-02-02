% NavigationStatusFinal:  motor cortex state when steps are exhausted; 
% set flags for shutdown
classdef NavigationStatusFinal < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusFinal(motorCortex)
            obj = obj@NavigationStatus(motorCortex);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.motorCortex.exitNavigation(); 
            navigationStatus = NavigationStatusFinal(obj.motorCortex); 
        end
    end
end
