% NavigationStatus:  base class for NavigationStatusXxxxx
classdef NavigationStatus < handle 

    properties
        motorCortex
        lastStatus
    end
    methods 
        function obj = NavigationStatus(motorCortex)
            obj.motorCortex = motorCortex; 
        end
        function navigationStatus = immediateTransition(obj, next)
            immediateStatus = next; 
            immediateStatus.lastStatus = obj;
            navigationStatus = immediateStatus.nextStatus(); 
            obj.setStatus(navigationStatus, immediateStatus); 
        end
        function setStatus(obj, next, last)
            next.lastStatus = last; 
            obj.motorCortex.navigationStatus = next;    
        end
        function debug(obj)
            obj.motorCortex.debugSteps = obj.motorCortex.debugSteps + 1;
            disp([class(obj),' debugSteps: ',num2str(obj.motorCortex.debugSteps)]);            
        end
    end
end