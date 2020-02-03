% NavigationStatusSettle:  motor cortex state to settle internal representation 
% back to previous physical place following a simulated turn or run
% this only reverses a Run, and transitions immediately to a next status
classdef NavigationStatusSettle < NavigationStatus 

    properties
        steps
        clockwiseness
    end
    methods 
        function obj = NavigationStatusSettle(motorCortex, updateAll)
            obj = obj@NavigationStatus(motorCortex, updateAll);
        end
        function navigationStatus = nextStatus(obj)
            obj.debug(); 
            if obj.updateAll
                obj.motorCortex.settleBasic(); 
            end
            obj.steps = obj.motorCortex.turnDistance; 
            obj.clockwiseness = obj.motorCortex.clockwiseness * -1; 
            obj.motorCortex.clockwiseness = obj.clockwiseness; 
            if ((obj.steps > 0) && (obj.clockwiseness ~= 0))
                navigationStatus = ... 
                    obj.immediateTransition(NavigationStatusSettleReverseTurn(obj.motorCortex, obj.steps, obj.clockwiseness, obj.updateAll)); 
            elseif obj.motorCortex.pendingSimulationOff 
                navigationStatus = ...
                    obj.immediateTransition(NavigationStatusPendingSimulationOff(obj.motorCortex, obj.updateAll));                 
            else
                navigationStatus = obj.immediateTransition(NavigationStatusSimulatedRandom(obj.motorCortex, obj.updateAll)); 
            end
        end
    end
end

%         function turned = reverseSimulatedTurn(obj)
%             turned = false;
%             if ((obj.turnDistance > 0) && (obj.clockwiseness ~= 0))
%                turned = true; 
%                disp(['reverse simulated turn; turnDistance: ',num2str(obj.turnDistance)]);                  
%                obj.clockwiseness = obj.clockwiseness * -1; 
%                obj.turn(); 
%                obj.simulatedBehaviorHistory = [obj.simulatedBehaviorHistory; [obj.reverseSimulatedTurnBehavior obj.turnDistance obj.clockwiseness]];
%                disp('obj.simulatedBehaviorHistory: '); 
%                disp(obj.simulatedBehaviorHistory);
%             end            
%         end



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