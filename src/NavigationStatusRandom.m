% NavigationStatusRandom:  motor cortex state for random physical
% navigation
classdef NavigationStatusRandom < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusRandom(motorCortex)
            obj = obj@NavigationStatus(motorCortex);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.steps = obj.motorCortex.randomSteps();
            if (obj.steps == 0)
                navigationStatus = obj.immediateTransition(NavigationStatusFinal(obj.motorCortex)); 
            elseif (obj.motorCortex.pendingSimulationOn) 
                navigationStatus = obj.immediateTransition(NavigationStatusPendingSimulationOn(obj.motorCortex));                 
            else
                obj.behavior = obj.motorCortex.turnOrRun(obj.steps);
                navigationStatus = NavigationStatusRandom(obj.motorCortex); 
            end
            obj.motorCortex.navigationStatus = navigationStatus;  
        end
    end
end

%            if (obj.pendingSimulationOn)
%               disp('simulation on'); 
%               obj.simulationOn();  
%               obj.pendingSimulationOn = false; 
%            end



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
