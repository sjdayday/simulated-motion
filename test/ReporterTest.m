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
            reporter.buildFiles(); 
            testCase.assertEqual(reporter.getHeader(), ...
                '"seed","step","placeId","simulated","turn/run","placeRecognized","retracedTrajectory","successfulRetrace","gridSquare"'); 
            testCase.assertEqual(reporter.getDiaryFile(), ...
                '../test/logs/2020-01-19--16-00-55_diary.txt'); 
            testCase.assertEqual(reporter.getStepFile(), ...
                '../test/logs/2020-01-19--16-00-55_step.csv'); 
            reporter.writeRecord(12,'[19 108]',1,2,0,1,0,75); 
            reporter.closeStepFile(); 
        end
    end
end