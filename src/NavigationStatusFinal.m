% NavigationStatusFinal:  motor cortex state when steps are exhausted; 
% set flags for shutdown
classdef NavigationStatusFinal < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusFinal(motorCortex, updateAll)
            obj = obj@NavigationStatus(motorCortex, updateAll);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.motorCortex.exitNavigation(); 
            navigationStatus = NavigationStatusFinal(obj.motorCortex, obj.updateAll); 
        end
    end
end
