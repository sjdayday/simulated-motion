% HebbMarrNetwork class:  models a network of neurons that implements
% auto-association as proposed in: 
% McNaughton, B. L., & Nadel, L. (1990). "Hebb-Marr networks and the neurobiological
% representation of action in space" Neuroscience and connectionist theory, 1{63.
% The model defines three types of neurons: 
% detonator:  output from these neurons is sufficiently great that a single input neuron
%  has a high probability of causing an output neuron to fire.  Granule
%  cells in dentate gyrus have such characteristics.  Inputs from these
%  cells are termed "inputY", following the usage in the article.
% modifiable:  output from these neurons form synapses modifiable via
%  Hebb's rule.  These are "typical" excitatory connections, as found in the 
%  dendrites of hippocampal pyramidal cells.  Inputs from these cells are
%  termed "inputX".
% inhibitory:  these neurons perform an integer division of the inputs to a
%  principal cell, such that the principal cell fires only if the number of
%  inputs it has received is equal to the sum of the inputX vector.
classdef HebbMarrNetwork < handle
    properties
        nNeurons
        nSynapses
        network     
        weightType
        weightFunction
    end
    methods
        function obj = HebbMarrNetwork()
            %The number of excitatory neurons in the network.  The mammalian cortex has
            %about 4 times as many excitatory nerons as inhibitory ones.
%             Ne=800;                Ni=200;
            obj.nNeurons = 2;
            obj.nSynapses = 4;
            obj.weightType = 'binary';  % weights are 0 or 1
        end
        % buildNetwork must be called after constructor is called and any 
        % properties are overridden. 
        function buildNetwork(obj)
            obj.network = zeros(obj.nSynapses,obj.nNeurons); 
            buildWeightFunction(obj);
        end
        function buildWeightFunction(obj)
            switch obj.weightType
                case 'binary'

                otherwise
                    error('HebbMarrNetwork:invalidWeightType', ['Invalid weight type: ', obj.weightType, '\n']); 
            end
%             obj.weightFunction
        end
%         function firings = runNetwork(obj)
            %Firings will be a two-column matrix.  
            %The first column will indicate the time (1-1000) 
            %that a neuron’s membrane potential crossed 30, and 
            %the second column %will be a number between 1 and totalNeurons 
            %that identifies which neuron fired at that time.
%             firings=[];           % spike timings

%             for t=1:obj.totalMilliseconds          % simulation of 1000 ms 
%                %Create some random input external to the network
%                externalInput=[5*randn(obj.nExcitatoryNeurons,1); ... 
%                    2*randn(obj.nInhibitoryNeurons,1)]; % e.g., thalamic input 
%                fired = step(obj, externalInput);
%                if ~isempty(fired)
%                    %Add the times of firing and the neuron number to firings.
%                    %TODO performance: consider pre-allocating in blocks
%                    firings=[firings; t+0*fired, fired];
%                end;
%             end;
%             obj.firings = firings; 
%         end
        function fired = step(obj, inputX, inputY)
            verifyInputs(obj,inputX,inputY); 
            % inputY 
            firedIndices = find(inputY == 1);
            inputxIndices = find(inputX == 1); 
            for ii = firedIndices
                for jj = inputxIndices
                    obj.network(jj,ii) = 1;  % rows are synapses, cols are principal cells
                end
            end
            fired = inputY;
           %Determine which neurons crossed threshold at the 
           %current time step t. 
%            fired=find(obj.membranePotentialList>=obj.maximumPotential); % indices of spikes
%            if ~isempty(fired)  
%               %Reset the neurons that fired to the spike reset membrane potential and   
%               %recovery variable.
%               obj.membranePotentialList(fired)=obj.membranePotentialResetList(fired);  
%               obj.recoveryList(fired)=obj.recoveryList(fired)+obj.recoveryResetList(fired);
%               %strengths of all other neurons that fired in the last time step connected to that 
%               %neuron.
%               externalInput=externalInput+sum(obj.network(:,fired),2);
%            end;
%            %Move the simulation forward twice, using Euler’s method, in
%            %small increments....except this generates huge (10^3)
%            %increases; is that plausible? 
%            obj.membranePotentialList=obj.membranePotentialList+ ... 
%                0.5*(0.04*obj.membranePotentialList.^2+5*obj.membranePotentialList+ ... 
%                140-obj.recoveryList+externalInput);
%            obj.membranePotentialList=obj.membranePotentialList+ ... 
%                0.5*(0.04*obj.membranePotentialList.^2+5*obj.membranePotentialList+ ... 
%                140-obj.recoveryList+externalInput);
%            obj.recoveryList=obj.recoveryList+obj.recoveryRateList.* ... 
%                (obj.subthresholdFluctuationSensitivityList.* ... 
%                obj.membranePotentialList-obj.recoveryList);   
% 
        end
        function verifyInputs(obj,inputX,inputY)
            if (length(inputX) ~= obj.nSynapses) || ...
                ((length(inputY) ~= obj.nNeurons) && (~isempty(inputY)))
                    error('HebbMarrNetwork:stepInputsWrongLength', ...
                    ['InputX must be of same length as nSynapses; was %d.\n' ... 
                    'InputY must be the same length as nNeurons, or empty; was %d.'], length(inputX), length(inputY)) ;
            end
        end
        function plot(obj)
            %Plot the raster plot of the network activity.
            %X=time in milliseconds, Y=neuron that fired
%             plot(obj.firings(:,1),obj.firings(:,2),'.');
        end
    end
end