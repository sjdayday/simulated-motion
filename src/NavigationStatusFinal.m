% NavigationStatusFinal:  motor cortex state when steps are exhausted; 
% set flags for shutdown
classdef NavigationStatusFinal < handle 

    properties
        motorCortex
        lastStatus
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusFinal(motorCortex)
            obj.motorCortex = motorCortex; 
        end
        function navigationStatus = nextStatus(obj)
%             obj.lastStatus = obj;
            obj.motorCortex.debugSteps = obj.motorCortex.debugSteps + 1;
            disp([class(obj),' debugSteps: ',num2str(obj.motorCortex.debugSteps)]);            
%             obj.motorCortex.debugSteps = obj.motorCortex.debugSteps + 1;
%             disp(['NavigationStatusFinal debugSteps: ',num2str(obj.motorCortex.debugSteps)]);
            obj.motorCortex.exitNavigation(); 
            navigationStatus = NavigationStatusFinal(obj.motorCortex); 
        end
    end
end


%            obj.debugSteps = obj.debugSteps + 1;  
%            disp(['nextRandomNavigation debugSteps: ',num2str(obj.debugSteps)]);
%            if (obj.simulationSettleRequired)
%               obj.nextRandomSimulatedNavigation(); 
%            end
%            if (obj.pendingSimulationOff)
%               disp('simulation off');  
%               obj.simulationOff(); 
%               obj.pendingSimulationOff = false; 
%            end           
%            steps = obj.randomSteps(); 
%            if (steps == 0)
%               disp('no remaining steps...exiting');  
%               obj.navigation.behaviorStatus.finish = true;
%               obj.navigation.behaviorStatus.waitForInput(false); 
%               obj.navigation.behaviorStatus.isDone = true;
%            else
%                if obj.turnAwayFromWhiskersTouching(steps)
%                    disp('turning away from whiskers touching'); 
%                    behavior = obj.turnBehavior; 
%                    obj.behaviorHistory = [obj.behaviorHistory; [behavior steps obj.clockwiseness]];                
% %                elseif (obj.simulationSettleRequired)
% %                    obj.nextRandomSimulatedNavigation(); 
%                else
%                    if (obj.navigateFirstSimulatedRun)
%                        disp('about to retraceFirstSimulatedRun');
%                        nextBehavior = obj.retraceFirstSimulatedRun(steps); 
%                        behavior = nextBehavior(1);
%                    else
%                        disp(['not navigateFirstSimulatedRun, about to turn or run ',num2str(steps)]); 
%                        behavior = obj.turnOrRun(steps);
%                    end
%                    obj.behaviorHistory = [obj.behaviorHistory; [behavior steps obj.clockwiseness]];                
%                end
%            end
%         end
