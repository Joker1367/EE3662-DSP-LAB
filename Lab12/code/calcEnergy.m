function energy = calcEnergy(I)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sum up the energy for each channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dx = [-1 0 1; -1 0 1; -1 0 1]; % horizontal gradient filter
dy = dx'; % vertical gradient filter

[h,w,ch] = size(I);

%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
%%%%%%%%%%%%%%%%%%
Irx = imfilter(I(:, :, 1), dx);
Igx = imfilter(I(:, :, 2), dx);
Ibx = imfilter(I(:, :, 3), dx);

Iry = imfilter(I(:, :, 1), dy);
Igy = imfilter(I(:, :, 2), dy);
Iby = imfilter(I(:, :, 3), dy);

energy = abs(Irx) + abs(Iry) + abs(Igx) + abs(Igy) + abs(Ibx) + abs(Iby);
%%%%%%%%%%%%%%%%%%
% END OF YOUR CODE
%%%%%%%%%%%%%%%%%%

end

