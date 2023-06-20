function [I, row, col] = FindCorners(frame, dx, dy, g, threshold, r, alpha)
%% Input
% frame: image read from source
% dx: horizontal gradient filter
% dy: vertical gradient filter
% g: Gaussian filter (filter size: 2*n_x_sigma*sigma)
% threshold: threshold for finding local maximum (0 ~ 1000)
% r: ordfilt2 neighbor range
% alpha: empirical chosen as 0.04 to calculate each element of R (corner response).

%% Output
% I: double type converted from "frame"
% row, col: the detected corners' locations

%% Convert frame to double type
I = im2double(frame);
figure;
imshow(frame);
[ymax, xmax, ch] = size(I);

%%%%%%%%%%%%%%%%%%%%%%%%%%% Interest Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%% get image gradient

% Grayscale
% [Your Code here]
Gray_scale = I(:, :, 1) * 0.299 + I(:, :, 2) * 0.587 + I(:, :, 3) * 0.114;

% calculate Ix using dx
% [Your Code here]
Ix = imfilter(Gray_scale, dx, 'same');

% calcualte Iy using dy
% [Your Code here]
Iy = imfilter(Gray_scale, dy, 'same');

%%% get all components of second moment matrix M = [[Ix2 IxIy];[IxIy Iy2]];
%%% note that Ix2 IxIy Iy2 are all Gaussian smoothed

% calculate Ix2 (element-wise multiplication of Ix)
% [Your Code here]
Ix2 = Ix .* Ix;
Ix2 = imfilter(Ix2, g, 'same');

% calculate Iy2 (element-wise multiplication of Iy)
% [Your Code here]
Iy2 = Iy .* Iy;
Iy2 = imfilter(Iy2, g, 'same');

% calculate IxIy (element-wise multiplication of Ix and Iy)
% [Your Code here]
Ixy = Ix .* Iy;
Ixy = imfilter(Ixy, g, 'same');

%% visualize IxIy
%fig = figure;
imagesc(Ixy);
%exportgraphics(fig, '../results/liberty_Ixy.jpg');

%-------------------------- Demo Check Point -----------------------------%

%%
%%% get corner response function R = det(M)-alpha*trace(M)^2

% calculate R
% [Your Code here]
R = zeros(ymax, xmax);
for i = 1 : ymax
    for j = 1 : xmax
        R(i, j) = Ix2(i, j) * Iy2(i, j) - Ixy(i, j) * Ixy(i, j) - alpha * (Ix2(i, j) + Iy2(i, j)) * (Ix2(i, j) + Iy2(i, j));
    end
end

%% make max R value to be 1000
%R = (1000 / max(R, [], "all")) * R; % be aware of if max(R) is 0 or not
% 
% % using B = ordfilt2(A,order,domain) to implment a maxfilter
sze = 2*r + 1; % domain width

%% find local maximum
%calculate MX using ordfilt2()
%[Your Code here]
MX = ordfilt2(R, 1, ones(sze, sze));

% calculate RBinary. Hint: Find which locations of MX have local maximum larger
% than the threshold. And note that, ordfilt2() let neighborhood's values change to
% local maximum.
% [Your Code here]
RBinary = zeros(ymax, xmax);
for i = 1 : ymax
    for j = 1 : xmax
        if(MX(i, j) == R(i, j) && R(i, j) < threshold)
            RBinary(i, j) = 1;
        else
            RBinary(i, j) = 0;
        end
    end
end

%disp(RBinary);

%% get location of corner points not along image's edges to avoid the the influence of padding
offe = r-1;
R = R*0;
R(offe:size(RBinary, 1) - offe, offe:size(RBinary, 2) - offe) = RBinary(offe:size(RBinary, 1) - offe, offe:size(RBinary, 2) - offe);
[row,col] = find(R);

end