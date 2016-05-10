%% cpcompare: cortical processing comparison test
close all
clear all
motorCortex = TestingMotorExecutions; 
cortex = Cortex(motorCortex);  
cortex.loadNetworks(20); 
planCorticalProcess = PlanCorticalProcess(cortex,1,2);            
simCorticalProcess = SimulationCorticalProcess(cortex,0.1,1,2,10); 
for ii = 1:100
    planCorticalProcess.currentRepresentation = 'FoundRewardAway';
    simCorticalProcess.currentRepresentation = 'FoundRewardAway';                
    planCorticalProcess.process(); 
    simCorticalProcess.process(); 
    planCorticalProcess.currentRepresentation = 'FoundRewardHome';
    simCorticalProcess.currentRepresentation = 'FoundRewardHome';                
    planCorticalProcess.process(); 
    simCorticalProcess.process(); 
    simResults = cortex.simulationNeuralNetwork.results; 
    planResults = cortex.planNeuralNetwork.results;
    save 'savedResults' simResults planResults
    display(['sim rebuilds: ',num2str(cortex.simulationNetworkRebuildCount)]);     
    display(['plan rebuilds: ',num2str(cortex.planNetworkRebuildCount)]);     
    display(['round: ',num2str(ii)]); 
end
