% SpikingNetwork class:  models a simple spiking network
% Modified from "Matlab for Neuroscientists (2nd edition)", Wallisch, et al.
% Chapter 29  spiking_network.m
% original variables:  u, v, a, b, c, d, I
% membranePotential (v)
% recovery (u)
% externalInput (I)
% RecoveryRate (a)
% SubthresholdFluctuationSensitivity (b)
% MembranePotentialReset (c)
% RecoveryReset (d)

classdef SpikingNetwork
    properties
        nExcitatoryNeurons
        nInhibitoryNeurons
        RecoveryRate
        SubthresholdFluctuationSensitivity
        MembranePotentialReset
        BaselinePotential 
        RecoveryReset 
        RecoveryResetRange
        MaximumPotential
        
    end
    methods
        function obj = SpikingNetwork()
            obj.nExcitatoryNeurons = 800;
            obj.nInhibitoryNeurons = 200;
            obj.RecoveryRate = 0.02;
            obj.SubthresholdFluctuationSensitivity = 0.2;
            obj.MembranePotentialReset = -65;
            obj.BaselinePotential = -65; 
            obj.RecoveryReset = 8; 
            obj.RecoveryResetRange = 6;
            obj.MaximumPotential = 30; 
        end
        function firings = runNetwork(obj)
            %The number of excitatory neurons in the network.  The mammalian cortex has
            %about 4 times as many excitatory nerons as inhibitory ones.
%             Ne=800;                Ni=200;
            re=rand(obj.nExcitatoryNeurons,1);         
            ri=rand(obj.nInhibitoryNeurons,1); 
            %This will set the RecoveryRate for all excitatory neurons to 0.02 and the
            %RecoveryRate for inhibitory neurons to a random number between 0.02 and 0.1
            RecoveryRateList = [obj.RecoveryRate*ones(obj.nExcitatoryNeurons,1);...
                obj.RecoveryRate+(0.1-obj.RecoveryRate)*ri];
            %This will allow b to range from 0.2-0.25
            SubthresholdFluctuationSensitivityList = ...
                [obj.SubthresholdFluctuationSensitivity*ones(obj.nExcitatoryNeurons,1); ...
                (obj.SubthresholdFluctuationSensitivity+0.05)-0.05*ri];
            %This will allow the spike reset membrane potential to range between -65
            %and -50
            MembranePotentialResetList =[obj.MembranePotentialReset+15*re.^2; ...
                obj.MembranePotentialReset*ones(obj.nInhibitoryNeurons,1)];
            %This will allow the recovery reset value to range between 2 and 8
            RecoveryResetList =[obj.RecoveryReset-(obj.RecoveryResetRange*re.^2); ...
                (obj.RecoveryReset-obj.RecoveryResetRange)*ones(obj.nInhibitoryNeurons,1)];
            totalNeurons = obj.nExcitatoryNeurons + obj.nInhibitoryNeurons;
            S=[0.5*rand(totalNeurons,obj.nExcitatoryNeurons), ...
                -rand(totalNeurons,obj.nInhibitoryNeurons)]; 

            %The following code can be used for the project when asked to create a
            %sparser weight matrix.
            %Choose a percent of connections to turn off.
            %percent_off=0.7; This is an extreme example with 70% of the connections
            %abolished.
            %connections=randperm((Ne+Ni)^2);
            %connections=connections(1:(floor(percent_off*length(connections))));
            %for i=1:length(connections)
            %    S(connections(i))=0;
            %end;

            %The initial values for v and u
            membranePotential=obj.BaselinePotential*ones(totalNeurons,1);  % Initial values of v
            recovery=SubthresholdFluctuationSensitivityList.*membranePotential;               % Initial values of u
            %Firings will be a two-column matrix.  
            %The first column will indicate the time (1-1000) 
            %that a neuron’s membrane potential crossed 30, and 
            %the second column %will be a number between 1 and Ne+Ni 
            %that identifies which neuron fired at that %time.
            %firings=[];
            firings=[];           % spike timings
        

            for t=1:1000          % simulation of 1000 ms 
               %Create some random input external to the network
               externalInput=[5*randn(obj.nExcitatoryNeurons,1); ... 
                   2*randn(obj.nInhibitoryNeurons,1)]; % thalamic input 
               %Determine which neurons crossed threshold at the 
               %current time step t. 
               fired=find(membranePotential>=obj.MaximumPotential); % indices of spikes
               if ~isempty(fired)  
                  %Add the times of firing and the neuron number to firings. 
                  firings=[firings; t+0*fired, fired];
                  %Reset the neurons that fired to the spike reset membrane potential and   
                  %recovery variable.
                  membranePotential(fired)=MembranePotentialResetList(fired);  
                  recovery(fired)=recovery(fired)+RecoveryResetList(fired);
                  %strengths of all other neurons that fired in the last time step connected to that 
                  %neuron.
                  externalInput=externalInput+sum(S(:,fired),2);
               end;
               %Move the simulation forward using Euler’s method.
               membranePotential=membranePotential+0.5*(0.04*membranePotential.^2+5*membranePotential+140-recovery+externalInput);
               membranePotential=membranePotential+0.5*(0.04*membranePotential.^2+5*membranePotential+140-recovery+externalInput);
               recovery=recovery+RecoveryRateList.*(SubthresholdFluctuationSensitivityList.*membranePotential-recovery);   
            end;
            %Plot the raster plot of the network activity.
            plot(firings(:,1),firings(:,2),'.');
        end
    end
end