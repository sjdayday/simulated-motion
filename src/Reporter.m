% System interface:  all systems implement System
classdef Reporter < handle 

    properties
        filepath
        formattedDateTime
        time
        timekeeper
        seed
        tag
        pipeTag
        animal
        stepFileId
    end
    methods 
        function obj = Reporter(filepath, formattedDateTime, seed, tag, pipeTag, animal)
            obj.time = 0; 
            obj.filepath = filepath; 
            obj.formattedDateTime = formattedDateTime;
            obj.seed = seed; 
            obj.tag = tag; 
            obj.pipeTag = pipeTag; 
            obj.animal = animal;
        end
        function setTimekeeper(obj, timekeeper) 
           obj.timekeeper = timekeeper; 
        end
        function timekeeper = getTimekeeper(obj) 
           timekeeper = obj.timekeeper;  
        end
        function buildFiles(obj)
           set(0,'diaryFile',obj.getDiaryFile()); 
           diary on; 
           disp(get(0,'diaryFile'));  
%            matrix2 = [100;200;300];
           fid = fopen( obj.getStepFile(), 'w' );
% for jj = 1 : length( matrix1 )
%            fprintf( fid, '%s,%d\n', matrix1{jj}, matrix2(jj) );
           fprintf( fid, '%s\n', obj.getHeader() );
% end
           fclose( fid );
           obj.stepFileId = fopen( obj.getStepFile(), 'a' );
        end
        function header = getHeader(obj)
           header = '"seed","step","placeId","simulated","turn/run","placeRecognized","retracedTrajectory","successfulRetrace","gridSquare"';
        end
        function diaryFile = getDiaryFile(obj)
           diaryFile = [obj.filepath,obj.formattedDateTime,'_diary.txt'];  
        end
        function stepFile = getStepFile(obj)
           stepFile = [obj.filepath,obj.formattedDateTime,'_step.csv'];   
        end
        function writeRecord(obj, step, placeId, simulated, turnRun, placeRecognized, retracedTrajectory, successfulRetrace, gridSquare)
           fprintf( obj.stepFileId, '%d,%d,%s,%d,%d,%d,%d,%d,%d\n', obj.seed,step,placeId,simulated,turnRun,placeRecognized,retracedTrajectory,successfulRetrace,gridSquare);
%             12,'[19 108]',1,2,0,1,0,75);  
        end
        function closeStepFile(obj)
           fclose(obj.stepFileId);  
        end
        function time = getTime(obj)
           time = obj.getTimekeeper().time;  
           % deal with initial race conditions if timekeeper hasn't stepped
           % yet.  not ideal; should really deal with the races...
           if (time == 0)
               time = 1; 
           end
        end
        function  step(obj)
        end
    end
end
