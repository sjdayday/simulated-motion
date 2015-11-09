% AutoassociativeHebbMarrNetwork class:  models a network of neurons that implements
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
classdef AutoassociativeNetwork < HebbMarrNetwork 

    properties
        wiring
        currentInputX
    end
    methods
        function obj = AutoassociativeNetwork(dimension)
            obj = obj@HebbMarrNetwork(dimension);
            obj.wiring = SequentialWiring(dimension); 
            obj.currentInputX = zeros(1,dimension); 
        end
        function fired = step(obj, inputX, inputY)
            if sum(inputX) == 0
                inputX = obj.currentInputX; 
            end
            fired = step@HebbMarrNetwork(obj, inputX, inputY); 
            obj.currentInputX = obj.wiring.connect(fired);
        end        
        function retrieved = read(obj, inputX)
            retrieved = zeros(1,obj.nNeurons); 
            verifyInputs(obj,inputX,[]); 
            totalActivation = sum(inputX);
            product = inputX*obj.network;
            while ((totalActivation > 0) && (sum(retrieved) == 0))
                if totalActivation > 0
                    retrieved = fix(product/totalActivation); 
                end
                totalActivation = totalActivation - 1; 
            end
        end
        function inputX = getCurrentInputX(obj)
            inputX = obj.currentInputX; 
        end
    end
end