% Animal class:  model movement and depiction of the physical animal
classdef Animal < handle 

    properties
        firstPlot
        h
        clockwiseVelocity
        counterClockwiseVelocity
        directions
        currentDirection
        minimumVelocity
        markers
        time
        features
    end
    methods
        function obj = Animal()
            obj.directions = zeros(1,3);
            obj.markers = gobjects(3,1); 
            obj.firstPlot = 1; 
            obj.minimumVelocity = pi/20; 
            obj.clockwiseVelocity = 0; 
            obj.counterClockwiseVelocity = 0; 
            obj.time = 0; 
            obj.features = []; 
        end
        %% Single time step 
        function  step(obj)
            obj.time = obj.time+1;
%             if obj.time == 3
%                 obj.features = [30 52]; 
%             end
%             if obj.time == 10
%                 obj.features = []; 
%             end
            if obj.time == 5
                obj.clockwiseVelocity = -obj.minimumVelocity; 
            end
            if obj.time == 18
                obj.clockwiseVelocity = 0; 
            end
            if obj.time == 25
                obj.counterClockwiseVelocity = obj.minimumVelocity*2; 
            end
            if obj.time == 37
                obj.counterClockwiseVelocity = 0; 
            end
        end
        function setupMarkers(obj)
            hold on;
            obj.markers(3) = plot(1,0, ...
                'o','MarkerFaceColor',[0.75 0.75 0.75],'MarkerSize',10,'MarkerEdgeColor',[0.75 0.75 0.75]);
            obj.markers(2) = plot(1,0, ...
                'o','MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',10,'MarkerEdgeColor',[0.5 0.5 0.5]);
            obj.markers(1) = plot(1,0, ...
                'o','MarkerFaceColor','black','MarkerSize',10,'MarkerEdgeColor','black');
            plot(.9192,.9192, ...
                'o','MarkerFaceColor','blue','MarkerSize',5,'MarkerEdgeColor','blue');
            plot(-1.3,0, ...
                'o','MarkerFaceColor','blue','MarkerSize',5,'MarkerEdgeColor','blue');
            drawnow;
            pause(1);
        end
        function movingMarkerUpdate(obj)
            obj.markers(1).XData = cos(obj.currentDirection); 
            obj.markers(1).YData = sin(obj.currentDirection); 
            obj.markers(2).XData = cos(obj.directions(1)); 
            obj.markers(2).YData = sin(obj.directions(1)); 
            obj.markers(3).XData = cos(obj.directions(2)); 
            obj.markers(3).YData = sin(obj.directions(2));
            obj.directions(3) = obj.directions(2);  
            obj.directions(2) = obj.directions(1);  
            obj.directions(1) = obj.currentDirection;  
            drawnow;
        end
        function notMovingMarkerUpdate(obj)
            obj.markers(1).XData = cos(obj.currentDirection); 
            obj.markers(1).YData = sin(obj.currentDirection); 
            obj.markers(2).XData = cos(obj.currentDirection); 
            obj.markers(2).YData = sin(obj.currentDirection); 
            obj.markers(3).XData = cos(obj.currentDirection); 
            obj.markers(3).YData = sin(obj.currentDirection);
            obj.directions(3) = obj.directions(2);  
            obj.directions(2) = obj.directions(1);  
            obj.directions(1) = obj.currentDirection;  
            drawnow;            
        end
        function plot(obj)
            figure(obj.h)
            if obj.firstPlot
                setupMarkers(obj);
%                 obj.h = figure('color','w');
%                 drawnow
                obj.firstPlot = 0;
            end

            hold on; 
            hold off; 
            axis manual;
%             minSpeed = pi/100; 
%             s = 5;
%             v = minSpeed*s; 
%             vv = -v*2;
            obj.currentDirection = obj.directions(1) + ... 
                obj.clockwiseVelocity + obj.counterClockwiseVelocity;
            if obj.currentDirection == obj.directions(1)
               notMovingMarkerUpdate(obj);  
            else
               movingMarkerUpdate(obj); 
            end
%             pos = zeros(1,10); 
%             lastPos = 0; 
%             for t = 1:10
%                 pos(t) = lastPos + v; 
%                 pp.XData = cos(pos(t)); 
%                 pp.YData = sin(pos(t)); 
%                 pp1.XData = cos(lastPos); 
%                 pp1.YData = sin(lastPos); 
% 
%                 lastPos = pos(t);
%                 drawnow
%                 pause(1);
%             end
        end        
    end
end
