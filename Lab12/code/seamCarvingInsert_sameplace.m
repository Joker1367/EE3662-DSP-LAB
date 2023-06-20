function output = seamCarvingInsert(image, insertsize)

%% Perform seam carving and record indexes
% Duplicate image 
image_duplicate = image;
[h,w,ch] = size(image);


% Create a container to record the seam index
seamIndex = zeros(h, 1, 'uint32');
seamDirection = 0;

%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
%%%%%%%%%%%%%%%%%%
% Use a for loop to delete each seam
% with your "calcEnergy", "findOptSeam", "reduceImageByIndexArray"
energy = calcEnergy(image_duplicate);
seamIndex(:, 1) = findOptSeam(energy, seamDirection);

%% Insert seams
output = image;
% Use a for loop to add each seam
% with your "enlargeImageByIndexArray"

%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
%%%%%%%%%%%%%%%%%%
for i=1:insertsize
    output = enlargeImageByIndexArray(output, seamIndex);
end
%%%%%%%%%%%%%%%%%%
% END OF YOUR CODE
%%%%%%%%%%%%%%%%%%

end
