% OrthogonalizingNetwork class:  models a network of neurons that
% orthogonalizes its inputs by spreading them across a large network of 
% neurons and then recombining them into an output of the same size as the
% original input. 
% See: 
% McNaughton, B. L., & Nadel, L. (1990). "Hebb-Marr networks and the neurobiological
% representation of action in space" Neuroscience and connectionist theory, 1-63.
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
classdef OrthogonalizingNetwork < handle
    properties
        nNeurons
        nSynapses
        wiring
        network     
        weightType
    end
    methods
        function obj = OrthogonalizingNetwork(synapses, neurons)
            obj.nSynapses = synapses;
            obj.nNeurons = neurons;
            obj.weightType = 'binary';  % weights are 0 or 1
            obj.wiring = OrthogonalizingWiring([synapses neurons]); 
        end
        % buildNetwork must be called after constructor is called and any 
        % properties are overridden. 
        function buildNetwork(obj)
            obj.network = zeros(obj.nSynapses,obj.nNeurons); 
%             buildWeightFunction(obj);
        end
%         function buildWeightFunction(obj)
%             switch obj.weightType
%                 case 'binary'
% 
%                 otherwise
%                     error('HebbMarrNetwork:invalidWeightType', ['Invalid weight type: ', obj.weightType, '\n']); 
%             end
% %             obj.weightFunction
%         end
        function fired = step(obj, input)
            verifyInputs(obj,input); 
            % inputY 
            firedIndices = find(input == 1);
            for ii = firedIndices
                    obj.network(ii,ii) = 1;  % rows are synapses, cols are principal cells
            end
            fired = input;
        end
        function retrieved = read(obj, inputX)
            retrieved = zeros(1,obj.nNeurons); 
            verifyInputs(obj,inputX,[]); 
            % inputY 
            totalActivation = sum(inputX);
            product = inputX*obj.network;
            if totalActivation > 0
                retrieved = fix(product/totalActivation); 
            end
        end
        function verifyInputs(obj,input)
            if (length(input) ~= obj.nSynapses) 
                    error('OrthogonalizingNetwork:stepInputWrongLength', ...
                    ['Input must be of same length as nSynapses; was %d.\n'], ...
                    length(input)) ;
            end
        end
        function plot(obj)
            %Plot the raster plot of the network activity.
            %X=time in milliseconds, Y=neuron that fired
%             plot(obj.firings(:,1),obj.firings(:,2),'.');
        end
    end
end