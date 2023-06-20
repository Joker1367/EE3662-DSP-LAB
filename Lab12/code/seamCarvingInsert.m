function output = seamCarvingInsert(image, insertsize)

%% Perform seam carving and record indexes
% Duplicate image 
image_duplicate = image;
[h,w,ch] = size(image);


% Create a container to record the seam index
seamIndex = zeros(h, insertsize, 'uint32');
seamDirection = 0;

%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
%%%%%%%%%%%%%%%%%%
% Use a for loop to delete each seam
% with your "calcEnergy", "findOptSeam", "reduceImageByIndexArray"
for i=1:insertsize
    % Perform seam carving
    % ...
    energy = calcEnergy(image_duplicate);
    seamIndex(:, i) = findOptSeam(energy, seamDirection);
    image_duplicate = reduceImageByIndexArray(image_duplicate, seamIndex(:, i), seamDirection);
    % Record the seam index
    % ...
end

%%%%%%%%%%%%%%%%%%
% END OF YOUR CODE
%%%%%%%%%%%%%%%%%%

%% Update seamIndex

%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
%%%%%%%%%%%%%%%%%%

% Update seamIndex to original image
% ...
for column_ref = insertsize - 1 : -1 : 1
    for column = column_ref + 1 : insertsize
        for row = 1 : h
            if (seamIndex(row, column_ref) < seamIndex(row, column))
               seamIndex(row, column) = seamIndex(row, column) + 1;
            end
        end
    end
end

% Update seamIndex to enlarged image
% ...
for column_ref = 1 : insertsize - 1
    for column = column_ref + 1 : insertsize
        for row = 1 : h
            if (seamIndex(row, column_ref) < seamIndex(row, column))
               seamIndex(row, column) = seamIndex(row, column) + 1;
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%
% END OF YOUR CODE
%%%%%%%%%%%%%%%%%%

%% Insert seams
output = image;
% Use a for loop to add each seam
% with your "enlargeImageByIndexArray"

%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
%%%%%%%%%%%%%%%%%%
for i=1:insertsize
    % Get s_i from record
    s_i = seamIndex(:, i);

    % Enlarge image with enlargeImageByIndexArray
    %%% ...
    output = enlargeImageByIndexArray(output, s_i);
end
%%%%%%%%%%%%%%%%%%
% END OF YOUR CODE
%%%%%%%%%%%%%%%%%%

end
