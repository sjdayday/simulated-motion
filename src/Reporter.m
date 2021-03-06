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
        step
        placeId
        placeRecognized
        turnOrRun
        simulated
        gridSquarePercent
        saturationPercent
        retracedTrajectory
        successfulRetrace
        sparsePlaceId
        ripples
        grids
        headDirectionCells
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
            obj.turnOrRun = 0; 
            obj.simulated = false; 
            obj.gridSquarePercent = 0.0;
            obj.successfulRetrace = false; 
            obj.buildParameterFields();
        end
        function setTimekeeper(obj, timekeeper) 
           obj.timekeeper = timekeeper; 
        end
        function timekeeper = getTimekeeper(obj) 
           timekeeper = obj.timekeeper;  
        end
        function buildFiles(obj)
            obj.buildDiaryFile(); 
            obj.buildStepFile(); 
        end
        function buildDiaryFile(obj)
           % diary file appears to be buffered; writes at least on diary off 
           diary off;
           set(0,'diaryFile',obj.getDiaryFile()); 
           diary on; 
%            disp(get(0,'diaryFile'));  
           disp(['rng seed: ',num2str(obj.seed)]);              
%            diary off; % forces write
        end
        function buildStepFile(obj)
           fid = fopen( obj.getStepFile(), 'w' );
           fprintf( fid, '%s\n', obj.getHeader() );
           fclose( fid );
           obj.stepFileId = fopen( obj.getStepFile(), 'a' );            
        end
        function header = getHeader(obj)
           header = '"seed","step","placeId","simulated","turn/run","placeRecognized","retracedTrajectory","successfulRetrace","gridSquarePercent","saturationPercent","sparsePlaceId","ripples","grids","headDirectionCells","tag","pipeTag"';
        end
        function diaryFile = getDiaryFile(obj)
           diaryFile = [obj.filepath,obj.formattedDateTime,'_diary.txt'];  
        end
        function stepFile = getStepFile(obj)
           stepFile = [obj.filepath,obj.formattedDateTime,'_step.csv'];   
        end
        function buildStepFields(obj) 
           obj.step = obj.animal.getTime(); 
           obj.placeId = obj.animal.hippocampalFormation.printPlaceOutputIndices(); 
           obj.placeRecognized = obj.animal.hippocampalFormation.placeRecognized;
           obj.turnOrRun = obj.animal.motorCortex.currentBehavior; 
           obj.simulated = obj.animal.simulatedMotion; 
           obj.gridSquarePercent = obj.animal.environment.gridSquarePercent();
           obj.saturationPercent = obj.animal.hippocampalFormation.placeSystem.saturation(); 
           obj.retracedTrajectory = obj.animal.motorCortex.navigateFirstSimulatedRun; 
           obj.successfulRetrace = obj.animal.motorCortex.successfulRetrace; 
        end
        function reportStep(obj)
            obj.buildStepFields(); 
            obj.writeRecord(obj.step, obj.placeId, obj.simulated, obj.turnOrRun, obj.placeRecognized, ...
                obj.retracedTrajectory, obj.successfulRetrace, obj.gridSquarePercent, obj.saturationPercent);
        end
        function writeRecord(obj, step, placeId, simulated, turnOrRun, placeRecognized, retracedTrajectory, successfulRetrace, gridSquarePercent, saturationPercent)
           fprintf( obj.stepFileId, '%d,%d,%s,%d,%d,%d,%d,%d,%f,%f,%d,%d,%d,%d,%s,%s\n', obj.seed,step,placeId,simulated,turnOrRun,placeRecognized,retracedTrajectory,successfulRetrace,gridSquarePercent,saturationPercent,obj.sparsePlaceId,obj.ripples,obj.grids,obj.headDirectionCells,obj.tag,obj.pipeTag);
%             12,'[19 108]',1,2,0,1,0,75);  
        end
        function buildParameterFields(obj)
            obj.sparsePlaceId = obj.animal.sparseOrthogonalizingNetwork; 
            obj.ripples = obj.animal.ripples; 
            obj.grids = obj.animal.hippocampalFormation.nGrids; 
            obj.headDirectionCells = obj.animal.nHeadDirectionCells;            
        end
        function cleanFilesForTesting(obj)
            diary off; 
            obj.deleteFile(obj.getDiaryFile()); 
            obj.deleteFile(obj.getStepFile()); 
        end
        function deleteFile(~,filename) 
           if exist(filename, 'file')==2
            delete(filename);
           end             
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
    end
end
