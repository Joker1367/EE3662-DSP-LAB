function maskReduced = reduceMaskByIndexArray(mask, seamIndexArray, seamDirection)

if seamDirection == 0
    [h,w,ch] = size(mask);
    maskReduced = false(h, w-1, ch);
    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    for i = 1 : h
        idx = seamIndexArray(i);
        %disp(idx);
        for j = 1 : ch
            if idx == 1
                maskReduced(i, :, j) = mask(i, 2 : w, j);
            elseif idx == w
                maskReduced(i, :, j) = mask(i, 1 : w - 1, j);
            else
                maskReduced(i, :, j) = horzcat(mask(i, 1 : idx - 1, j), mask(i, idx + 1 : w, j));
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
    [h,w,ch] = size(mask);
    maskReduced = false(h - 1, w, ch);
    for i = 1 : w
        idx = seamIndexArray(i);
        %disp(idx);
        for j = 1 : ch
            if idx == 1
                maskReduced(:, i, j) = mask(2 : h, i, j);
            elseif idx == h
                maskReduced(:, i, j) = mask(1 : h - 1, i, j);
            else
                maskReduced(:, i, j) = vertcat(mask(1 : idx - 1, i, j), mask(idx + 1 : h, i, j));
            end
        end
    end
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%
end

end
