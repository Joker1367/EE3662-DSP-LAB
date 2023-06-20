function imageEnlarged = enlargeImageByIndexArray(image, seamIndexArray)
    [h,w,ch] = size(image);
    imageEnlarged = zeros(h, w+1, ch);

    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    for row = 1 : h
        idx = seamIndexArray(h);
        for j = 1 : ch
            new = (image(row, idx, j) + image(row, idx - 1, j)) / 2;
            imageEnlarged(row, :, j) = [image(row, 1 : idx - 1, j), new, image(row, idx : w, j)];
        end
    end
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%
end
