% NavigationStatus:  base class for NavigationStatusXxxxx
classdef NavigationStatus < handle 

    properties
        motorCortex
        lastStatus
        next
        updateAll
        moving
    end
    methods 
        function obj = NavigationStatus(motorCortex, updateAll, lastStatus)
            obj.motorCortex = motorCortex; 
            obj.updateAll = updateAll; 
            obj.lastStatus = lastStatus; 
        end
        function navigationStatus = immediateTransition(obj, next)
            obj.next = next; 
%             immediateStatus = next; 
%             immediateStatus.lastStatus = obj;
            navigationStatus = next.nextStatus(); 
            obj.setStatus(navigationStatus); 
        end
        function setStatus(obj, next)
            endStatus = next;
            while (~isempty(endStatus.next))
                endStatus = endStatus.next; 
            end
%             next.lastStatus = last; 
            obj.motorCortex.navigationStatus = endStatus;    
        end
        function debug(obj)
            obj.motorCortex.debugSteps = obj.motorCortex.debugSteps + 1;
            disp([class(obj),' debugSteps: ',num2str(obj.motorCortex.debugSteps)]);            
        end
    end
end