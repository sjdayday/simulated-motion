% Animal class:  model movement and depiction of the physical animal
classdef Environment < System

    properties
        walls
        nWalls
        cues
        nCues
        position
        distanceIntervals
        center
        relativeDistanceInterval
    end
    methods
        function obj = Environment()
            obj = obj@System(); 
            obj.walls = []; 
            obj.nWalls = 0; 
            obj.cues = []; 
            obj.nCues = 0; 
            obj.position = [0 0]; 
            obj.distanceIntervals = 8;
            obj.center = [0 0]; 
            obj.relativeDistanceInterval = 0;           
        end
        function build(obj)
            maxDistance = calculateMaxDistanceFromCenter(obj);
            obj.relativeDistanceInterval=maxDistance/obj.distanceIntervals; 
        end
        function max = calculateMaxDistanceFromCenter(obj)
            max = 0; 
        end
        function addWall(obj, startPosition, endPosition)
            wall = [startPosition, endPosition]; 
%             rows = size(obj.walls,1); 
            obj.walls = [obj.walls;wall];
            obj.nWalls = size(obj.walls,1); 
        end
        function addCue(obj, cuePosition)
            obj.cues = [obj.cues;cuePosition]; 
            obj.nCues = size(obj.cues,1); 
        end
        function setPosition(obj, position)
           obj.position = position;  
        end
        function distance = closestWallDistance(obj)
            distances = zeros(1,obj.nWalls);  
            for ii = 1:obj.nWalls;
                currentDistance = distanceToWall(obj,ii);
                distances(ii) = currentDistance; 
            end
            distance = min(distances); 
        end
        function distance = distanceToWall(obj, index)
            q1 = [obj.walls(index,1), obj.walls(index,2)]; 
            q2 = [obj.walls(index,3), obj.walls(index,4)];
            % thanks to Roger Stafford: 
            %http://www.mathworks.com/matlabcentral/newsreader/view_thread/164048
            distance = abs(det([q2-q1;obj.position-q1]))/norm(q2-q1);            
        end
        function distance = cueDistance(obj, cueIndex)
           distance = pointDistance(obj, obj.position, obj.cues(cueIndex,:));   
        end
        function distance = pointDistance(obj, startPoint, endPoint)
           x = endPoint(1);  
           y = endPoint(2); 
           px = startPoint(1); 
           py = startPoint(2); 
           distance = sqrt((x-px)^2 + (y-py)^2);             
        end
        %% Single time step 
        function plot(obj)
            figure(obj.h)
            if obj.firstPlot
                direction = 0; 
                orientAnimal(obj, direction);
                setupMarkers(obj); 
                obj.firstPlot = 0;
            end
            if obj.showFeatures
                hold on
                plot(.9192,.9192, ...
                'o','MarkerFaceColor','blue','MarkerSize',5,'MarkerEdgeColor','blue');
                plot(-1.3,0, ...
                'o','MarkerFaceColor','blue','MarkerSize',5,'MarkerEdgeColor','blue');
            end            
            hold off; 
            axis manual;
            updateOrientation(obj);
        end        
    end
end
