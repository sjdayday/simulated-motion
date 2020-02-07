% NavigationStatusSimulatedRandom:  motor cortex state for simulated random
% navigation
classdef NavigationStatusSimulatedRandom < NavigationStatus 

    properties
        steps
        behavior
    end
    methods 
        function obj = NavigationStatusSimulatedRandom(motorCortex, updateAll, lastStatus)
            obj = obj@NavigationStatus(motorCortex, updateAll, lastStatus);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            obj.steps = obj.motorCortex.randomSteps();
            if (obj.steps == 0)
                obj.moving = false; 
                navigationStatus = obj.immediateTransition(NavigationStatusFinal(obj.motorCortex, obj.updateAll, obj)); 
            elseif (obj.motorCortex.pendingSimulationOff) 
                obj.moving = false; 
                navigationStatus = ...
                    obj.immediateTransition(NavigationStatusPendingSimulationOff(obj.motorCortex, obj.updateAll, obj));                                 
%                 navigationStatus = obj.immediateTransition(NavigationStatusPendingSimulationOn(obj.motorCortex));                 
            else
%                 obj.motorCortex.simulatedMove(obj.steps);
%                 obj.behavior = obj.motorCortex.turnOrRun(obj.steps);
                obj.moving = true; 
                obj.buildBehavior(obj.steps); 
                obj.motorCortex.updateSimulatedBehaviorHistory(obj.behavior, obj.steps);               
                navigationStatus = NavigationStatusSettle(obj.motorCortex, obj.updateAll, obj); 
                obj.setStatus(navigationStatus);                 
            end 
        end
        function buildBehavior(obj, steps)
            if (isempty(obj.behavior)) % default, else overridden for testing
               obj.behavior = obj.motorCortex.turnOrRun(steps);
            end
        end
    end
end

%               obj.simulationSettleRequired = true;  
%               behavior = obj.turnOrRun(steps);
%               obj.simulatedBehaviorHistory = [obj.simulatedBehaviorHistory; [behavior steps obj.clockwiseness]];                
%               disp('obj.simulatedBehaviorHistory: '); 
%               disp(obj.simulatedBehaviorHistory);             



%           disp('nextRandomSimulatedNavigation'); 
%            if (obj.pendingSimulationOn)
%               disp('simulation on'); 
%               obj.simulationOn();  
%               obj.pendingSimulationOn = false; 
%            end
%            steps = obj.randomSteps(); 
%            if (steps == 0)
%               disp('no remaining steps...exiting'); 
%               obj.navigation.behaviorStatus.finish = true;
%               obj.navigation.behaviorStatus.waitForInput(false); 
%               obj.navigation.behaviorStatus.isDone = true;
%            else
%                if (obj.simulationSettleRequired)
%                     disp('simulationSettleRequired, about to settle'); 
%                     obj.simulationSettleRequired = false; 
%                     % to settle, must be in simulation...
%                     turned = obj.settlePhysical(); 
%                     if (~turned)
% %                         if (obj.simulatedMotion)                        
%                         % ...but if pending off, next move should not be simulated; exit to real 
%                         if ((obj.simulatedMotion) && (~obj.pendingSimulationOff))
%                             disp(['simulated move, about to turn or run ',num2str(steps)]); 
%                             obj.simulatedMove(steps);                    
%                         else
%                             obj.nextRandomNavigation(); 
%                         end
%                     end
%                else
%                    disp(['not simulationSettleRequired, simulated move, about to turn or run ',num2str(steps)]); 
%                    obj.simulatedMove(steps);
%                end
%            end