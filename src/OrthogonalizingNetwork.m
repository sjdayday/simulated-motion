% OrthogonalizingNetwork class:  models a network of neurons that
% orthogonalizes its inputs by spreading them across a large network of 
% neurons and then recombining them into an output of the same size as the
% original input. 
% See: 
% McNaughton, B. L., & Nadel, L. (1990). "Hebb-Marr networks and the neurobiological
% representation of action in space" Neuroscience and connectionist theory, 1-63.
classdef OrthogonalizingNetwork < handle
    properties
        nNeurons
        nSynapses
        wiringInput
        wiringOutput
        network     
        weightType
        rebuildConnections
    end
    methods
        function obj = OrthogonalizingNetwork(synapses, neurons)
            obj.nSynapses = synapses;
            obj.nNeurons = neurons;
            obj.weightType = 'binary';  % weights are 0 or 1
            obj.wiringInput = OrthogonalizingWiring([synapses neurons]); 
            obj.wiringOutput = OrthogonalizingWiring([neurons synapses]); 
            obj.rebuildConnections = false;
        end
        % buildNetwork must be called after constructor is called and any 
        % properties are overridden. 
        function buildNetwork(obj)
            obj.network = zeros(obj.nSynapses,obj.nNeurons); 
            obj.wiringInput.rebuildConnections = obj.rebuildConnections; 
            obj.wiringOutput.rebuildConnections = obj.rebuildConnections;
        end
        function fired = step(obj, input)
            verifyInputs(obj,input); 
            internal = obj.wiringInput.connect(input);
            fired = obj.wiringOutput.connect(internal);
        end
        function retrieved = read(obj, inputX)
            retrieved = zeros(1,obj.nNeurons); 
            verifyInputs(obj,inputX,[]); 
            totalActivation = sum(inputX);
            product = inputX*obj.network;
            if totalActivation > 0
                retrieved = fix(product/totalActivation); 
            end
        end
        function verifyInputs(obj,input)
            if (length(input) ~= obj.nSynapses) 
                    strSynapses = num2str(obj.nSynapses); 
                    error(['OrthogonalizingNetwork:stepInputWrongLength', ...
                    'Input must be of same length as nSynapses: ', strSynapses, ...
                    ' but was ', num2str(length(input))]) ;
            end
        end
%         function plot(obj)
%         end
    end
end