%% cpcompare: cortical processing comparison test
close all
clear all
simulationCost = 0.01; % was 0.1
for ii = 1:1
    for jj = 1:1
        motorCortex = TestingMotorExecutions; 
        cortex = Cortex(motorCortex);  
        cortex.loadNetworks(10); % was 20 
        planCorticalProcess = PlanCorticalProcess(cortex,1,2);     

        simCorticalProcess = SimulationCorticalProcess(cortex,simulationCost,1,2,10); 
        simCorticalProcess.predictionThreshold = 0.5; 
        steps = 70; 
        % use what planCorticalProcess knows about motor plans to suggest one to
        % simulate
        simCorticalProcess.planCorticalProcess = planCorticalProcess; 
        simCorticalProcess.usePlanCorticalProcess = 1;
        for kk = 1:steps
            planCorticalProcess.currentRepresentation = 'FoundRewardAway';
            simCorticalProcess.currentRepresentation = 'FoundRewardAway';                
            planCorticalProcess.process(); 
            simCorticalProcess.process(); 
            planCorticalProcess.currentRepresentation = 'FoundRewardHome';
            simCorticalProcess.currentRepresentation = 'FoundRewardHome';                
            planCorticalProcess.process(); 
            simCorticalProcess.process(); 
            simResults = simCorticalProcess.results; 
            planResults = planCorticalProcess.results;
            save 'savedResults' simResults planResults
            display(['sim rebuilds: ',num2str(cortex.simulationNetworkRebuildCount)]);     
            display(['plan rebuilds: ',num2str(cortex.planNetworkRebuildCount)]);     
            display(['round: ',num2str(kk)]); 
        end
        figure; 
        subplot(121); 
        plot(1:steps*2, simResults); 
        title({'simulation: ',sprintf('cost = %d',simulationCost)})
        subplot(122);  
        plot(1:steps*2, planResults); 
        title('plan');
    end
    simulationCost = simulationCost + 0.02; 
end