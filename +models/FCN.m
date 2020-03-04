function model = FCN(numClasses)
    % Build a Fully Convolutional Network for semantic segmentation based on 
    % the paper https://people.eecs.berkeley.edu/~jonlong/long_shelhamer_fcn.pdf
    %
    % This function returns the layer graph object for the FCN created using a pretrained
    % GoogLeNet as the base model
    % 
    arguments
        numClasses (1,1) int8 = 11
    end
    
    baseModel = googlenet;
    baseLayerGraph = layerGraph(baseModel);
    % Remove the classifier layers
    modifiedLayerGraph = removeLayers(baseLayerGraph, { ...
        'pool5-7x7_s1', 'pool5-drop_7x7_s1', 'loss3-classifier', ...
        'prob', 'output'
    });

    %The Layers necessary for FCN
    layers = [
        convolution2dLayer(1, numClasses, 'Name', 'fcn-1')
        %TODO: Determine if activation functions are needed here
        transposedConv2dLayer(13, numClasses, 'Stride', 32, 'Name', 'fcn-upsample-2') %TODO: Ensure it matches input size?
        softmaxLayer('Name','fcn-softmax-3')
    ];

    model = addLayers(modifiedLayerGraph, layers);
    model = connectLayers(model, 'inception_5b-output', 'fcn-1');
end