function [optSeamIndexArray, seamEnergy] = findOptSeam(energy, seamDirection)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Following paper by Avidan and Shamir `07
% Finds optimal seam by the given energy of an image
% Returns mask with 0 mean a pixel is in the seam
% You only need to implement vertical seam. For
% horizontal case, just using the same function by 
% giving energy for the transpose image I'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% seam_direction 0 => vertical
% seam_direction 1 => horzontal

if seamDirection == 0  % Find vertical seam
    % Find M for vertical seams
    
    M = energy; % Initialize M as energy
    [h, w] = size(M);

    % Add one column of padding in vertical dimension 
    % to avoid handling border elements
    M = padarray(M, [0 1], realmax('double'));
    %disp(size(M));

    % For all rows starting from second row, fill in the minimum 
    % energy for all possible seam for each (i,j) in M, which
    % M[i, j] = e[i, j] + min(M[i-1, j-1], M[i-1, j], M[i-1, j+1]).

    % Note that we initialize M as e, so it can be written as
    % M[i, j] = M[i, j] + min(M[i-1, j-1], M[i-1, j], M[i-1, j+1])

    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    for row = 2 : h
        for col = 2 : w + 1
            M(row, col) = M(row, col) + min(M(row - 1, col - 1 : col + 1));
        end
    end
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%
    
    [h, w] = size(M);

    % Find the minimum element in the last row of M
    [val, idx] = min(M(h,:));
    seamEnergy = val;

    % Initial for optimal seam mask
    optSeamIndexArray = zeros(h, 1, 'uint32');

    % Traverse back the path of seam with minimum energy
    % and update optimal seam index array
    optSeamIndexArray(end) = idx; % Initialize
    %disp([h, w]);
    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    for row = h - 1 : -1 : 1        
        [val, next] = min(M(row, idx - 1 : idx + 1));
        idx = idx + next - 2;
        optSeamIndexArray(row) = idx;
    end

    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%
    % Minus 1 because we pad M previously
    
    optSeamIndexArray = optSeamIndexArray - 1;
    
else  % Find horizontal seam
    M = energy; % Initialize M as energy
    [h, w] = size(M);

    % Add one column of padding in vertical dimension 
    % to avoid handling border elements
    M = padarray(M', [0 1], realmax('double'))';

    % For all rows starting from second row, fill in the minimum 
    % energy for all possible seam for each (i,j) in M, which
    % M[i, j] = e[i, j] + min(M[i-1, j-1], M[i-1, j], M[i-1, j+1]).

    % Note that we initialize M as e, so it can be written as
    % M[i, j] = M[i, j] + min(M[i-1, j-1], M[i-1, j], M[i-1, j+1])

    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    for col = 2 : w
        for row = 2 : h + 1
            M(row, col) = M(row, col) + min(M(row - 1 : row + 1, col - 1));
        end
    end
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%

    [h, w] = size(M);

    % Find the minimum element in the last row of M
    [val, idx] = min(M(:, w));
    seamEnergy = val;

    % Initial for optimal seam mask
    optSeamIndexArray = zeros(w, 1, 'uint32');

    % Traverse back the path of seam with minimum energy
    % and update optimal seam index array
    optSeamIndexArray(end) = idx; % Initialize
    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    for col = w - 1 : -1 : 1
        tmp = idx;
        [val, idx] = min(M(tmp - 1 : tmp + 1, col));
        idx = idx + tmp - 2;
        optSeamIndexArray(col) = idx;
    end
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%
    % Minus 1 because we pad M previously
    
    optSeamIndexArray = optSeamIndexArray - 1;
end
end
