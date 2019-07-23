% HeadDirectionSystemForced class:  forces a head direction 
classdef HeadDirectionSystemForced < HeadDirectionSystem 

    properties
    end
    methods
        function obj = HeadDirectionSystemForced(nHeadDirectionCells)
            obj = obj@HeadDirectionSystem(nHeadDirectionCells);             
  
        end
        function forceActivation(obj, forcedDirection)
               obj.initializeActivation(true); 
               obj.uActivation(forcedDirection) = 1;             
        end
        
        function initializeActivation(obj, random)
               obj.uActivation = zeros(1,obj.nHeadDirectionCells);
        end
        function build(obj)
            obj.setChildTimekeeper(obj); 
        end
        % not necessary here, but consistent with pattern for higher-level
        % components, e.g. HippocampalFormation
        function setChildTimekeeper(obj, timekeeper) 
           obj.setTimekeeper(timekeeper);  
        end
        function setFeaturesDetected(obj, featuresDetected)
        end
        function updateFeaturesDetected(obj)
        end
        function updateFeatureWeights(obj)
        end
        function signedAngularVelocity = updateTurnVelocity(obj, velocity)
            signedAngularVelocity = obj.minimumVelocity * velocity; 
            obj.updateAngularVelocity(signedAngularVelocity);
        end
        function updateAngularVelocity(obj, velocity)
           obj.pullVelocity = false; 
           if velocity >= 0 
               obj.counterClockwiseVelocity = velocity; 
               obj.clockwiseVelocity = 0; 
           else
               obj.clockwiseVelocity = -velocity; 
               obj.counterClockwiseVelocity = 0; 
           end
        end
        function  updateVelocity(obj)
            if obj.pullVelocity 
               obj.clockwiseVelocity = -obj.animal.clockwiseVelocity * obj.animalVelocityCalibration;  
               obj.counterClockwiseVelocity = obj.animal.counterClockwiseVelocity * obj.animalVelocityCalibration;             
            % else someone is calling updateAngularVelocity(obj, velocity)
            end
        end

        %% Trappenberg sigmoidal activation function (equation 7.2)
        function activationFunction(obj)
        end
        %% Single time step 
        function  step(obj)
            step@System(obj); 
            disp('Forced'); 

        end
        function maxIndex = getMaxActivationIndex(obj)
            maxIndex = find(obj.uActivation==max(obj.uActivation)); 
        end
        function plotCircle(obj)
            figure(obj.h)
            hold on; 
            axis manual;

            if obj.firstCirclePlot
                obj.marker = plot(1,0, ...
                    'o','MarkerFaceColor','black','MarkerSize',10,'MarkerEdgeColor','black');
                drawnow;
                pause(1);
                obj.firstCirclePlot = 0;
            else
                index = obj.getMaxActivationIndex(); 
%                 index = find(obj.uActivation==max(obj.uActivation)); 
%                radians = ((obj.nHeadDirectionCells-index)/obj.nHeadDirectionCells)*2*pi; 
              radians = (index/obj.nHeadDirectionCells)*2*pi; 
                obj.marker.XData = cos(radians); 
                obj.marker.YData = sin(radians); 
                drawnow;
                
            end            

        end
        function plotActivation(obj)
            % assumes nHeadDirectionCells is 60
            figure(obj.h)
            hold off; 
            plot(obj.xAxisValues, obj.uActivation); 
            obj.xAxis = gca; 
            obj.xAxis.XTick = [0 15 30 45 60];
            obj.xAxis.XTickLabel = ... 
                {'0', '\pi/2', '\pi', '3\pi/2', '2\pi'};
            title({'Head direction activation',sprintf('t = %d',obj.getTime()+1)})
        end
        function plot(obj)
            if obj.firstPlot
                obj.h = figure('color','w');
                drawnow
                obj.firstPlot = 0;
            end
            figure(obj.h);
            plot(obj.xAxisValues, obj.uActivation); 
            obj.xAxis = gca; 
            obj.xAxis.XTick = [0 15 30 45 60 75 90 105 120];
            obj.xAxis.XTickLabel = ... 
                {'-2\pi', '-3\pi/2', '-\pi', '-\pi/2', '0', '\pi/2', '\pi', '3\pi/2', '2\pi'};
            title({'Head direction',sprintf('time = %d ',obj.getTime())});
            drawnow
        end        
    end
end
