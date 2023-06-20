function imageReduced = reduceImageByIndexArray(image, seamIndexArray, seamDirection)

if seamDirection == 0
    [h,w,ch] = size(image);
    imageReduced = zeros(h, w-1, ch);
    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    for i = 1 : h
        idx = seamIndexArray(i);
        %disp(idx);
        for j = 1 : ch
            if idx == 1
                imageReduced(i, :, j) = image(i, 2 : w, j);
            elseif idx == w
                imageReduced(i, :, j) = image(i, 1 : w - 1, j);
            else
                imageReduced(i, :, j) = horzcat(image(i, 1 : idx - 1, j), image(i, idx + 1 : w, j));
            end
        end
    end
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%
else
    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    [h,w,ch] = size(image);
    imageReduced = zeros(h - 1, w, ch);
    for i = 1 : w
        idx = seamIndexArray(i);
        %disp(idx);
        for j = 1 : ch
            if idx == 1
                imageReduced(:, i, j) = image(2 : h, i, j);
            elseif idx == h
                imageReduced(:, i, j) = image(1 : h - 1, i, j);
            else
                imageReduced(:, i, j) = vertcat(image(1 : idx - 1, i, j), image(idx + 1 : h, i, j));
            end
        end
    end
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%
end

end

