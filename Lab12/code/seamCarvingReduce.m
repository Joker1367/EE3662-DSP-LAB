function output = seamCarvingReduce(image, reduceSize, seamDirection)
    output = image;
    for reduceCnt = 1:reduceSize
        energy = calcEnergy(output);
        optSeamIndexArray = findOptSeam(energy, seamDirection);
        output = reduceImageByIndexArray(output, optSeamIndexArray, seamDirection);
    end
end
