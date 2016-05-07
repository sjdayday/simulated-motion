%% TestingExperimentController class:  testing ExperimentController with minimal dependencies
classdef TestingMotorExecutions < handle

    properties
        testingExecutions
    end
        
    methods
        function obj = TestingMotorExecutions()
            buildExecutions(obj); 
        end
        function buildExecutions(obj)
            % F N A B H A R N
            % F:  Found Reward Away
            % N:  Found Reward Home
            % A:  Motor Plan A
            % B:  Motor Plan B
            % H:  Motor Plan Home
            % A:  Motor Plan Away
            % R:  Rewarding 
            % N:  Not rewarding            
            xIn = [
                0 1 1 0 0 0 0 1;
                0 1 1 0 0 0 1 0;
                1 0 0 0 1 0 1 0;
                0 1 0 1 0 0 1 0;
                0 1 0 1 0 0 1 0;
                0 1 1 0 0 0 0 1;
                1 0 0 1 0 0 0 1;
                1 0 1 0 0 0 1 0;
                0 1 0 1 0 0 0 1;
                0 1 0 1 0 0 0 1;
                0 1 0 1 0 0 1 0;
                0 1 0 1 0 0 0 1;
                0 1 0 1 0 0 1 0;
                1 0 0 0 1 0 1 0;
                0 1 0 0 1 0 0 1;
                1 0 0 0 1 0 1 0;
                0 1 0 0 1 0 0 1;
                0 1 1 0 0 0 0 1;
                1 0 0 0 1 0 1 0;
                0 1 1 0 0 0 0 1;
                0 1 1 0 0 0 0 1;
                0 1 0 0 1 0 0 1;
                0 1 0 0 1 0 0 1;
                1 0 0 0 1 0 1 0;
                0 1 0 0 1 0 0 1;
                1 0 0 0 1 0 1 0;
                0 1 0 0 1 0 0 1;
                1 0 0 0 1 0 1 0;
                0 1 0 0 0 1 1 0;
                1 0 0 0 0 1 0 1;
                0 1 0 0 0 1 0 1;
                1 0 0 0 0 1 0 1;
                0 1 0 0 1 0 0 1;
                0 1 0 0 1 0 0 1;
                0 1 1 0 0 0 0 1;
                1 0 0 0 1 0 1 0;
                0 1 1 0 0 0 0 1;
                0 1 0 0 1 0 0 1;
                1 0 0 0 0 1 0 1;
                0 1 0 0 0 1 0 1;
                0 1 0 0 0 1 1 0;
                0 1 0 0 0 1 1 0;
                1 0 0 0 0 1 0 1;
                1 0 0 0 0 1 0 1;
                0 1 0 0 0 1 1 0;
                1 0 0 0 0 1 0 1;
                1 0 0 0 0 1 0 1;
                0 1 0 1 0 0 0 1;
                0 1 0 1 0 0 0 1;
                1 0 1 0 0 0 0 1;
                1 0 0 0 1 0 1 0;
                1 0 0 0 1 0 1 0;
                0 1 0 0 0 1 1 0;
                0 1 0 0 0 1 1 0;
                1 0 0 0 0 1 0 1;
                0 1 0 0 0 1 1 0;
                1 0 0 0 0 1 0 1;
                1 0 1 0 0 0 1 0;
                1 0 1 0 0 0 0 1;
                0 1 0 0 1 0 0 1;
                1 0 0 0 0 1 0 1;
                0 1 0 0 0 1 0 1;
                1 0 1 0 0 0 1 0;
                1 0 1 0 0 0 0 1;
                1 0 0 1 0 0 0 1;
                1 0 1 0 0 0 1 0;
                1 0 1 0 0 0 0 1;
                1 0 1 0 0 0 1 0;
                0 1 1 0 0 0 0 1;
                0 1 1 0 0 0 0 1;
                0 1 0 1 0 0 0 1;
                1 0 0 1 0 0 0 1;
                1 0 0 1 0 0 0 1;
                1 0 0 1 0 0 0 1;
                1 0 0 1 0 0 0 1;
                1 0 0 1 0 0 1 0;
                1 0 0 1 0 0 0 1;
                1 0 0 1 0 0 0 1;
                1 0 1 0 0 0 0 1;
                1 0 0 1 0 0 1 0;
                ];
            xxInUnit = xIn';
            obj.testingExecutions = repmat(xxInUnit,1,20);
%             
%             simIn = xxIn(1:6,:);
%             simTg = xxIn(7:8,:);
%             locIn = xxIn(1:2,:);
%             locTg = xxIn(3:8,:);
%             planA = xxIn(1:2,:); 
%             planB = xxIn(7:8,:); 
%             planIn = [planA;planB]; 
%             planTg = xxIn(3:6,:);
        end
        function execution = randomMotorExecution(obj)
           execution = obj.testingExecutions(:,randi(length(obj.testingExecutions)));  
        end
                   
    end
end
