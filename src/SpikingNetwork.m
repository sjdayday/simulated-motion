% SpikingNetwork class:  models a simple spiking network
% Modified from "Matlab for Neuroscientists (2nd edition)", Wallisch, et al.
% Chapter 29  spiking_network.m
% original variables:  u, v, a, b, c, d, I
% membranePotential (v)
% recovery (u)
% externalInput (I)
% recoveryRate (a)
% subthresholdFluctuationSensitivity (b)
% membranePotentialReset (c)
% recoveryReset (d)

classdef SpikingNetwork < handle
    properties
        nExcitatoryNeurons
        nInhibitoryNeurons
        recoveryRate
        subthresholdFluctuationSensitivity
        membranePotentialReset
        recoveryReset 
        recoveryResetRange
        maximumPotential
        recoveryRateList
        subthresholdFluctuationSensitivityList
        membranePotentialResetList
        recoveryResetList
        membranePotentialList
        recoveryList
        network
        totalMilliseconds
        firings
    end
    methods
        function obj = SpikingNetwork()
            %The number of excitatory neurons in the network.  The mammalian cortex has
            %about 4 times as many excitatory nerons as inhibitory ones.
%             Ne=800;                Ni=200;
            obj.nExcitatoryNeurons = 800;
            obj.nInhibitoryNeurons = 200;
            obj.recoveryRate = 0.02;
            obj.subthresholdFluctuationSensitivity = 0.2;
            obj.membranePotentialReset = -65;
            obj.recoveryReset = 8; 
            obj.recoveryResetRange = 6;
            obj.maximumPotential = 30;
            obj.totalMilliseconds = 1000; 
        end
        % buildNetwork must be called after constructor is called and any 
        % properties are overridden. 
        function buildNetwork(obj)
            re=rand(obj.nExcitatoryNeurons,1);         
            ri=rand(obj.nInhibitoryNeurons,1); 
            %This will set the RecoveryRate for all excitatory neurons to 0.02 and the
            %RecoveryRate for inhibitory neurons to a random number between 0.02 and 0.1
            obj.recoveryRateList = [obj.recoveryRate*ones(obj.nExcitatoryNeurons,1);...
                obj.recoveryRate+(0.1-obj.recoveryRate)*ri];
            %SubthresholdFluctuationSensitivity to range from 0.2-0.25
            obj.subthresholdFluctuationSensitivityList = ...
                [obj.subthresholdFluctuationSensitivity*ones(obj.nExcitatoryNeurons,1); ...
                (obj.subthresholdFluctuationSensitivity+0.05)-0.05*ri];
            %This will allow the spike reset membrane potential to range between -65
            %and -50
            obj.membranePotentialResetList =[obj.membranePotentialReset+15*re.^2; ...
                obj.membranePotentialReset*ones(obj.nInhibitoryNeurons,1)];
            %This will allow the recovery reset value to range between 2 and 8
            obj.recoveryResetList =[obj.recoveryReset-(obj.recoveryResetRange*re.^2); ...
                (obj.recoveryReset-obj.recoveryResetRange)*ones(obj.nInhibitoryNeurons,1)];
            totalNeurons = obj.nExcitatoryNeurons + obj.nInhibitoryNeurons;
            obj.network=[0.5*rand(totalNeurons,obj.nExcitatoryNeurons), ...
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
            obj.membranePotentialList=obj.membranePotentialReset*ones(totalNeurons,1); 
            obj.recoveryList=obj.subthresholdFluctuationSensitivityList.* ... 
                obj.membranePotentialList;                
        end
        function firings = runNetwork(obj)
            %Firings will be a two-column matrix.  
            %The first column will indicate the time (1-1000) 
            %that a neuron’s membrane potential crossed 30, and 
            %the second column %will be a number between 1 and Ne+Ni 
            %that identifies which neuron fired at that %time.
            %firings=[];
            firings=[];           % spike timings
        

            for t=1:obj.totalMilliseconds          % simulation of 1000 ms 
               %Create some random input external to the network
               externalInput=[5*randn(obj.nExcitatoryNeurons,1); ... 
                   2*randn(obj.nInhibitoryNeurons,1)]; % e.g., thalamic input 
               %Determine which neurons crossed threshold at the 
               %current time step t. 
               fired=find(obj.membranePotentialList>=obj.maximumPotential); % indices of spikes
               if ~isempty(fired)  
                  %Add the times of firing and the neuron number to firings. 
                  %TODO consider pre-allocating in blocks
                  firings=[firings; t+0*fired, fired];
                  %Reset the neurons that fired to the spike reset membrane potential and   
                  %recovery variable.
                  obj.membranePotentialList(fired)=obj.membranePotentialResetList(fired);  
                  obj.recoveryList(fired)=obj.recoveryList(fired)+obj.recoveryResetList(fired);
                  %strengths of all other neurons that fired in the last time step connected to that 
                  %neuron.
                  externalInput=externalInput+sum(obj.network(:,fired),2);
               end;
               %Move the simulation forward using Euler’s method, twice in
               %small increments.
               obj.membranePotentialList=obj.membranePotentialList+ ... 
                   0.5*(0.04*obj.membranePotentialList.^2+5*obj.membranePotentialList+ ... 
                   140-obj.recoveryList+externalInput);
               obj.membranePotentialList=obj.membranePotentialList+ ... 
                   0.5*(0.04*obj.membranePotentialList.^2+5*obj.membranePotentialList+ ... 
                   140-obj.recoveryList+externalInput);
               obj.recoveryList=obj.recoveryList+obj.recoveryRateList.* ... 
                   (obj.subthresholdFluctuationSensitivityList.* ... 
                   obj.membranePotentialList-obj.recoveryList);   
            end;
            obj.firings = firings; 
        end
        function plot(obj)
            %Plot the raster plot of the network activity.
            plot(obj.firings(:,1),obj.firings(:,2),'.');
        end
    end
end