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
           disp('somestuff'); 
        end
        function header = getHeader(obj)
           header = '"seed","tag","pipeTag","step","placeId","simulated","turn/step","placeRecognized","retracedTrajectory","successfulRetrace","gridSquare"';
        end
        function diaryFile = getDiaryFile(obj)
           diaryFile = [obj.filepath,'diary_',obj.formattedDateTime,'.txt'];  
        end
        function stepFile = getStepFile(obj)
           stepFile = [obj.filepath,'step_',obj.formattedDateTime,'.csv'];   
        end
        function time = getTime(obj)
           time = obj.getTimekeeper().time;  
           % deal with initial race conditions if timekeeper hasn't stepped
           % yet.  not ideal; should really deal with the races...
           if time == 0
               time = 1; 
           end
        end
        function  step(obj)
        end
    end
end
