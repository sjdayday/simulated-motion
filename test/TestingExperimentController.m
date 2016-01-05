%% TestingExperimentController class:  testing ExperimentController with minimal dependencies
classdef TestingExperimentController < ExperimentController 

    properties
        testingSystem
        testingSystemPropertyMap
    end
        
    methods
        function obj = TestingExperimentController()
            obj = obj@ExperimentController(); 
            obj.testingSystem = TestingSystem(); 
            obj.testingSystemPropertyMap = containers.Map(); 
            addSystemProperty(obj, obj.testingSystemPropertyMap, ... 
                'testProperty', obj.testingSystem); 
        end
        function rebuildTestingSystem(obj) 
             obj.testingSystem = TestingSystem(); 
        end
        
        function value = getTestingSystemProperty(obj, property)
            value = getSystemProperty(obj, obj.testingSystemPropertyMap, property);
        end
        function iterateTestingSystemForPropertyRanges(obj)
            obj.statisticsHeader = {'iteration', 'testProperty'}; 
            obj.statisticsDetail = zeros(1,2); 
            for aa = getTestingSystemProperty(obj, 'testProperty'): ...
                 getTestingSystemProperty(obj, 'testProperty.increment'): ...
                 getTestingSystemProperty(obj, 'testProperty.max')
                 rebuildTestingSystem(obj);
                 updateSystemWithPropertyValue(obj, obj.testingSystem, ...
                     'testProperty', aa); 
                 runSystem(obj,obj.testingSystem);
                 obj.statisticsDetail(obj.iteration,:) = [obj.iteration, aa]; 
            end
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
