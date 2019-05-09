%% TestingExperimentController class:  testing ExperimentController with minimal dependencies
classdef TestingExperimentController < ExperimentController 

    properties
        testingSystem
        testingSystemPropertyMap
        testingStatisticsHeader
        testingStatisticsDetail
        testingField
    end
        
    methods
        function obj = TestingExperimentController()
            obj = obj@ExperimentController(); 
            obj.rebuildTestingSystem();
%             obj.testingSystem = TestingSystem(); 
            obj.testingSystemPropertyMap = containers.Map(); 
            addSystemProperty(obj, obj.testingSystemPropertyMap, ... 
                'testProperty', obj.testingSystem);
            obj.testingField = 0;  
        end
        function build(obj)
            build@ExperimentController(obj);
        end
        function rebuildTestingSystem(obj) 
             obj.testingSystem = TestingSystem(); 
             obj.lastSystem = obj.testingSystem ; 
        end
        
        function value = getTestingSystemProperty(obj, property)
            value = getSystemProperty(obj, obj.testingSystemPropertyMap, property);
        end
        function iterateTestingSystemForPropertyRanges(obj)
            obj.testingStatisticsHeader = {'iteration', 'testProperty'}; 
            obj.testingStatisticsDetail = zeros(1,2); 
            for aa = getTestingSystemProperty(obj, 'testProperty'): ...
                 getTestingSystemProperty(obj, 'testProperty.increment'): ...
                 getTestingSystemProperty(obj, 'testProperty.max')
                 rebuildTestingSystem(obj);
                 updateSystemWithPropertyValue(obj, obj.testingSystem, ...
                     'testProperty', aa); 
                 runSystem(obj,obj.testingSystem);
                 obj.testingStatisticsDetail(obj.iteration,:) = [obj.iteration, aa]; 
            end
%         function step(obj, system)
%            events(obj); 
%            system.step();
% %            obj.animal.step(); 
%            obj.currentStep = obj.currentStep + 1; 
% %            if obj.visual
% %                plot(obj);  
% %                pause(obj.stepPause); 
% %            end            
%         end
    %  for each parameter
    %     rebuildSystem
    %     set all the parameters 
    %     runSystem
%         function runChartSystem(obj)
%             rebuildChartSystem(obj);
%             runSystem(obj,obj.chartSystem); 
%         end
%         function runSystem(obj, system)
%             system.buildWeights(); 
%             obj.currentStep = 1;             
%             runBareSystem(obj, system); 
%         end
%         function runBareSystem(obj, system)
%             if obj.resetSeed
%                load '../rngDefaultSettings';
%                rng(rngDefault);    
%             end
%             for ii = obj.currentStep:obj.totalSteps
%                system.step(); 
%                obj.currentStep = obj.currentStep + 1; 
%             end                        
%         end
           % bump iteration 
            
            
        end
    end
end
