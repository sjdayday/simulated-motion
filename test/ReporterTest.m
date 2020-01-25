classdef ReporterTest < AbstractTest
    methods (Test)
        function testReporterCreatesDiaryAndStepCsvFiles(testCase)
            seed = uint32(123456); 
            tag = '0123EF456';
            pipeTag = 'v1.2.1'; 
            formattedDateTime = char(datetime(2020,1,19,16,0,55, 'Format','yyyy-MM-dd--HH-mm-ss')); 
            animal = Animal(); 
            filepath = '../test/logs/';
            reporter = Reporter(filepath, formattedDateTime, seed, tag, pipeTag, animal); 
            reporter.cleanFilesForTesting(); 
            reporter.buildFiles(); 
            testCase.assertEqual(reporter.getHeader(), ...
                '"seed","step","placeId","simulated","turn/run","placeRecognized","retracedTrajectory","successfulRetrace","gridSquarePercent"'); 
            testCase.assertEqual(reporter.getDiaryFile(), ...
                '../test/logs/2020-01-19--16-00-55_diary.txt'); 
            testCase.assertEqual(reporter.getStepFile(), ...
                '../test/logs/2020-01-19--16-00-55_step.csv'); 
            % TODO read and assert...
            reporter.writeRecord(12,'[19 108]',1,2,0,1,0,0.05); 
            reporter.writeRecord(13,'[64 110]',0,1,0,1,0,0.06); 
            reporter.closeStepFile(); 
        end
        function testBuildRecordFields(testCase)
            seed = uint32(123456); 
            tag = '0123EF456';
            pipeTag = 'v1.2.1'; 
            formattedDateTime = char(datetime(2020,1,19,16,0,55, 'Format','yyyy-MM-dd--HH-mm-ss')); 
            animal = Animal(); 
            filepath = '../test/logs/';
            reporter = Reporter(filepath, formattedDateTime, seed, tag, pipeTag, animal); 
            animal.showHippocampalFormationECIndices = true; 
            animal.pullVelocityFromAnimal = false;             
            animal.build(); 
            animal.setTimekeeper(animal); 
            environment = Environment();
            environment.addWall([0 0],[0 2]); 
            environment.addWall([0 2],[2 2]); 
            environment.addWall([0 0],[2 0]); 
            environment.addWall([2 0],[2 2]);
            
            environment.build();
            animal.place(environment, 1, 1, 0);              
            animal.step(); 
            animal.step(); 
            reporter.buildStepFields();
            testCase.assertEqual(reporter.step, 2);
            testCase.assertEqual(reporter.placeId, '[203 207 221 368]'); 
            testCase.assertEqual(reporter.placeRecognized, true); 
            testCase.assertEqual(reporter.gridSquarePercent, 0.01); 
            %  turnstep
            motorCortex = animal.motorCortex; 
            motorCortex.turnDistance = 3;
            motorCortex.counterClockwiseTurn();
            pause(0.5);             
            reporter.buildStepFields();            
            testCase.assertEqual(reporter.step, 5);
            testCase.assertEqual(reporter.turnOrRun, motorCortex.turnBehavior);
            testCase.assertEqual(reporter.gridSquarePercent, 0.01); 
            motorCortex.runSpeed = 1; 
            motorCortex.runDistance = 5; 
            motorCortex.run(); 
            pause(0.5);             
            reporter.buildStepFields();            
            testCase.assertEqual(reporter.step, 10);
            testCase.assertEqual(reporter.turnOrRun, motorCortex.runBehavior);            
            testCase.assertEqual(reporter.placeId, '[246 297 323 458]'); 
            testCase.assertEqual(reporter.placeRecognized, false); 
            testCase.assertEqual(reporter.simulated, false);
            testCase.assertEqual(reporter.gridSquarePercent, 0.04); 
            animal.motorCortex.pendingSimulationOn = true; 
            animal.motorCortex.remainingDistance = 2; 
            animal.motorCortex.nextRandomSimulatedNavigation(); 
            pause(0.5);             
            reporter.buildStepFields();            
            testCase.assertEqual(reporter.step, 12);
            testCase.assertEqual(reporter.simulated, true);
            testCase.assertEqual(reporter.gridSquarePercent, 0.05); 
%             reporter.cleanFilesForTesting(); 
%             reporter.buildFiles(); 
%             testCase.assertEqual(reporter.getHeader(), ...
%                 '"seed","step","placeId","simulated","turn/run","placeRecognized","retracedTrajectory","successfulRetrace","gridSquare"'); 
%             testCase.assertEqual(reporter.getDiaryFile(), ...
%                 '../test/logs/2020-01-19--16-00-55_diary.txt'); 
%             testCase.assertEqual(reporter.getStepFile(), ...
%                 '../test/logs/2020-01-19--16-00-55_step.csv'); 
%             % TODO read and assert...
%             reporter.writeRecord(12,'[19 108]',1,2,0,1,0,75); 
%             reporter.writeRecord(13,'[64 110]',0,1,0,1,0,76); 
%             reporter.closeStepFile(); 
        end
        
    end
end