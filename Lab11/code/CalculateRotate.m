% parameters
% corner response related
sigma = 2;
n_x_sigma = 6;
alpha = 0.04;       % empirical chosen as 0.04 to get calculate each element of R (corner response)

% maximum suppression related
threshold = 20;     % should be between 0 and 1000
r = 6;

%%
% filter kernels
dx = [-1 0 1; -1 0 1; -1 0 1];              % horizontal gradient filter 
dy = dx';                                   % vertical gradient filter
g = fspecial('gaussian', max(1, fix(2 * n_x_sigma*sigma)), sigma); % Gaussien Filter: filter size 2*n_x_sigma*sigma

%% load image
frame1 = imread('../data/img_1.jpg');
frame2 = imread('../data/img_2.jpg');

%% Find corners in frame1 and frame2
% [Your Code here]
[I1, r1, c1] = FindCorners(frame1, dx, dy, g, threshold, r, alpha);
[I2, r2, c2] = FindCorners(frame2, dx, dy, g, threshold, r, alpha);

%% Display the detected corners in frame1
% To show these two images, please refer to MyHarrisCornerDetector.m
% [Your Code here]
figure(1);
imshow(I1);
hold on;
plot(c1,r1,'or');


%% Display the detected corners in frame2
% [Your Code here]
figure(2);
imshow(I2);
hold on;
plot(c2,r2,'or');

%% Calculate rotation: use arctan between leftmost and bottommost point
% [Your Code here]
l1 = 1;
b1 = 1;
l2 = 1;
b2 = 1;

for i = 1 : 4
    if(c1(i) < c1(l1))
        l1 = i;
    end
    if(c2(i) < c2(l2))
        l2 = i;
    end
    if(r1(i) < r1(b1))
        b1 = i;
    end
    if(r2(i) < r2(b2))
        b2 = i;
    end
end

theta1 = atan((r1(l1) - r1(b1)) / (c1(b1) - c1(l1)));
theta2 = atan((r2(l2) - r2(b2)) / (c2(b2) - c2(l2)));
degree = theta1 - theta2;

degree = degree*180/pi;                   % convert radian to degree
fprintf("Rotation Degree: %d \n", degree);
