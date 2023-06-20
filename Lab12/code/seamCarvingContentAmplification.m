function output = seamCarvingContentAmplification(image)
    % Hint
    % To perform content amplification,
    % enlarge the image with standard scaling
    % Then, use seamCarvingReduce() with vertical and horizontal
    % seams to reduce the image back to original size

    % Record input size
    [h_input, w_input, ch] = size(image);
    
    % Enlarge image with standard scaling
    enlarged_image = imresize(image, 1.4);
    [h_enlarge, w_enlarge, ch] = size(enlarged_image);

    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    output = enlarged_image;
    row_diff = h_enlarge - h_input;
    col_diff = w_enlarge - w_input;
    
    output = seamCarvingReduce(output, col_diff, 0);
    output = seamCarvingReduce(output, row_diff, 1);
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%
end
