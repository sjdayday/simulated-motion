% Environment class:  models a physical arena and cues.  
% The Animal interacts with the Environment.
% This class is mostly methods that calculate distances and angles to cues
% and walls.  In the "real" animal, those calculations are done internally, 
% presumably as part of neocortical processing of sensory inputs.
% Putting that logic in a class that models the actual physical environment
% is just done for convenience in programming. 
%
% The setHeadDirection method is used by the LecSystem to develop the
% canonical representation of the animal's position in relation to
% important cues, from the animal's current internal head direction.  
% The calculation is done *as if* the animal's current internal head direction 
% were synchronized with the animal's actual physical head direction in the
% environment.  Since this is only true a small fraction of the time, the
% cueHeadDirectionOffset calculation will be off by the discrepancy between
% internal and actual head direction.  The fact of this discrepancy is
% unimportant; what is important is that it be consistent across the
% animal's interaction with a given environment. 
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
        direction
        directionIntervals
        gridSquares
        hardcodedGridDimension
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
            obj.direction = 0; 
            obj.directionIntervals = 60; 
            % gridSquares are 0.2 on a side for a 2 x 2 arena; hard-coded
            obj.hardcodedGridDimension = 0.2; 
        end
        function build(obj)
            maxDistance = calculateMaxDistanceFromCenter(obj);
            obj.relativeDistanceInterval= ... 
                (maxDistance*2)/(obj.distanceIntervals-1); 
            obj.buildGridSquares(); 
        end
        function buildGridSquares(obj)
            obj.gridSquares = zeros(10, 10);
        end
        function maxDistance = calculateMaxDistanceFromCenter(obj)
            distances = []; 
            for ii = 1:obj.nCues
               distances = [distances; centerDistance(obj, obj.cues(ii,:))];   
            end
            for jj = 1:obj.nWalls
               wall = obj.walls(jj,:); 
               distances = [distances; centerDistance(obj, [wall(1) wall(2)])];   
               distances = [distances; centerDistance(obj, [wall(3) wall(4)])];   
            end
            maxDistance = max(distances); 
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
           disp(['environment position updated: ',mat2str(position)]); 
        end
        function position = getPosition(obj)
           position = obj.position;  
        end
        function setDirection(obj, direction)
           obj.direction = direction;    
        end
        function direction = getDirection(obj)
           direction = obj.direction;    
        end        
        function [wallIndex,distance] = closestWall(obj)
            distances = zeros(1,obj.nWalls);  
            for ii = 1:obj.nWalls
                currentDistance = distanceToWall(obj,ii);
                distances(ii) = currentDistance; 
            end
            distance = min(distances); 
            wallIndex = find(distances == distance); 
        end
        function distance = closestWallDistance(obj)
            [~, distance] = closestWall(obj); 
%             distances = zeros(1,obj.nWalls);  
%             for ii = 1:obj.nWalls;
%                 currentDistance = distanceToWall(obj,ii);
%                 distances(ii) = currentDistance; 
%             end
%             distance = min(distances); 
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
        function distance = centerDistance(obj, endPoint)
           distance = pointDistance(obj, obj.center, endPoint);
        end
        function distance = pointDistance(~, startPoint, endPoint)
           x = endPoint(1);  
           y = endPoint(2); 
           px = startPoint(1); 
           py = startPoint(2); 
           distance = sqrt((x-px)^2 + (y-py)^2);             
        end
        function relativeDistance = calculateRelativeDistance(obj, distance)
            relativeDistance = fix(distance/obj.relativeDistanceInterval)+1; 
        end
        function relativeDistance = cueRelativeDistance(obj, cueIndex)
            distance = pointDistance(obj, obj.position, obj.cues(cueIndex,:)); 
            relativeDistance = calculateRelativeDistance(obj, distance);
        end
        function relativeDistance = closestWallRelativeDistance(obj)
            distance = closestWallDistance(obj); 
            relativeDistance = calculateRelativeDistance(obj, distance);
        end
        function direction = cueDirectionOffset(obj, cueIndex)
           s = size(obj.cues);
%            disp('size of obj.cues:'); 
%            disp(s);
           if s(1) < cueIndex
               direction = 0;
           else
               direction = pointDirection(obj, obj.cues(cueIndex,:));   
           end
        end
        function direction = cueDirection(obj, cueIndex)
           s = size(obj.cues);
%            disp('size of obj.cues:'); 
%            disp(s);
           if s(1) < cueIndex
               direction = 0;
           else
               direction = pointGivenDirection(obj, obj.cues(cueIndex,:), 0);   
           end
        end
        function direction = pointDirection(obj, target) 
            direction = obj.pointGivenDirection(target,obj.direction);  
        end
        function direction = pointGivenDirection(obj, target, givenDirection) 
           % thanks to Roger Stafford: 
           % originally, in mathworks newsreader:
           % http://www.mathworks.com/matlabcentral/newsreader/view_thread/151925#849830
           % archived here: 
           % https://groups.google.com/d/msg/comp.soft-sys.matlab/zNbUui3bjcA/ehyAzegIoNMJ
           % 11 Dec, 2007
           v = [target(1)-obj.position(1) target(2)-obj.position(2) 0];
           u = [cos(givenDirection) sin(givenDirection) 0];
           direction = mod(atan2(u(1)*v(2)-v(1)*u(2),u(1)*v(1)+u(2)*v(2)),2*pi);
%            direction = atan2(norm(cross(u,v)), dot(u,v)); % 3D
        end
        function direction = wallDirection(obj, wall)
           % jdbertron: line CD perpendicular to wall AB, C=obj.position 
           % http://stackoverflow.com/questions/10301001/perpendicular-on-a-line-segment-from-a-given-point
           Ax = wall(1); 
           Ay = wall(2);
           Bx = wall(3); 
           By = wall(4); 
           Cx = obj.position(1); 
           Cy = obj.position(2); 
           t=((Cx-Ax)*(Bx-Ax)+(Cy-Ay)*(By-Ay))/((Bx-Ax)^2+(By-Ay)^2); 
           Dx=Ax+t*(Bx-Ax);
           Dy=Ay+t*(By-Ay); 
           direction = pointDirection(obj, [Dx Dy]); 
        end
        function rejection = rejectionWall(obj, wall)
           b = [wall(3)-wall(1) wall(4)-wall(2)];
           disp(b); 
           a = [cos(obj.direction) sin(obj.direction)]; 
           rejection = a - (dot(a,b)/dot(b,b))*b;
           disp(mod(atan2(a(1)*b(2)-b(1)*a(2),a(1)*b(1)+a(2)*b(2)),2*pi));
        end
        function direction = closestWallDirection(obj)
            [wallIndex, ~] = closestWall(obj); 
            direction = wallDirection(obj, obj.walls(wallIndex,:)); 
        end
        function setHeadDirection(obj, headDirection)
            % TODO guard <1 or > directionIntervals
            obj.setDirection(((headDirection-1)/obj.directionIntervals)*(2*pi));  
        end
        function cueHeadDirection = cueHeadDirectionOffset(obj, index)
            cueHeadDirection = obj.headDirectionOffset(obj.cueDirectionOffset(index));
            disp(['cueHeadDirection: ',num2str(cueHeadDirection),'obj.cueDirectionOffset(index): ',...
                num2str(obj.cueDirectionOffset(index)),' for index: ',num2str(index)]); 
        end
        % head direction at this offset from current
        function headDirection = headDirectionOffset(obj, direction)
            headDirection = fix(direction/(2*pi) * obj.directionIntervals); % drop +1?
            if headDirection >= obj.directionIntervals
               headDirection = 0;  
            end
%             headDirection = min(headDirection, obj.directionIntervals); % if direction is exactly 2*pi             
        end
        % calculates which gridSquare corresponds to animal's position 
        % note that lower left in the arena, e.g., 0.1, 0.1, is upper left
        % in the matrix: (1, 1).  Also, the x position in the arena is the   
        % column in the matrix, and the y position is the row
        function calculateGridSquare(obj, position)
            column = ceil(position(1) / obj.hardcodedGridDimension); 
            row = ceil(position(2) / obj.hardcodedGridDimension); 
            if ((row > 0) && (column > 0)) 
                obj.gridSquares(row, column) = 1;
            else
                disp(['Error:  Environment.calculateGridSquare, position gives invalid grid square: ',mat2str(position)]);
            end
        end
        function arenaDisplay = showGridSquares(obj)
           arenaDisplay = flipud(obj.gridSquares); 
        end
        function total = gridSquareTotal(obj)
           total = sum(sum(obj.gridSquares));  
        end
        function percent = gridSquarePercent(obj)
           percent = obj.gridSquareTotal() / 100; 
        end
        %% Single time step 
        function plot(obj)
            figure(obj.h)
            if obj.firstPlot
                direction = 0; 
                orientAnimal(obj, direction);  % probably not used; function is in Animal
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
