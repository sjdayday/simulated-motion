% NavigationStatusFinal:  motor cortex state when steps are exhausted; 
% set flags for shutdown
classdef NavigationStatusFinal < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusFinal(motorCortex, updateAll, lastStatus)
            obj = obj@NavigationStatus(motorCortex, updateAll, lastStatus);
        end
        function navigationStatus = nextStatus(obj)
            obj.moving = false; 
            obj.debug(); 
            obj.motorCortex.exitNavigation(); 
            navigationStatus = NavigationStatusFinal(obj.motorCortex, obj.updateAll, obj); 
            obj.setStatus(navigationStatus); 
        end
    end
end
