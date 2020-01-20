classdef ReporterTest < AbstractTest
    methods (Test)
        function testPlaceSystemCreatedWithDGConnectedToCA3(testCase)
            seed = uint32(123456); 
            tag = '0123EF456';
            pipeTag = 'v1.2.1'; 
            formattedDateTime = char(datetime(2020,1,19,16,0,55, 'Format','yy-MM-dd--HH-mm-ss')); 
            animal = Animal(); 
            filepath = '../test/logs/';
            reporter = Reporter(filepath, formattedDateTime, seed, tag, pipeTag, animal); 
            reporter.buildFiles(); 
            testCase.assertEqual(reporter.getHeader(), ...
                '"seed","tag","pipeTag","step","placeId","simulated","turn/step","placeRecognized","retracedTrajectory","successfulRetrace","gridSquare"'); 
            testCase.assertEqual(reporter.getDiaryFile(), ...
                '../test/logs/diary_20-01-19--16-00-55.txt'); 
            testCase.assertEqual(reporter.getStepFile(), ...
                '../test/logs/step_20-01-19--16-00-55.csv'); 

        end
    end
end