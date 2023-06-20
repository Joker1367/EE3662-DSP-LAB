% My Harris detector
% The code calculates
% the Harris Feature/Interest Points (FP or IP) 

% When you execute the code, the test image file will open
% then the code will print out and display the feature points.
% You can control the number of FPs by changing some parameters e.g. threshold

%%%
% corner: significant change in all direction for a sliding window
%%%

%%
% parameters
% corner response related
sigma = 2;
n_x_sigma = 6;
alpha = 0.04;       % empirical chosen as 0.04 to get calculate each element of R (corner response)
len = floor(2 * n_x_sigma*sigma);

% maximum suppression related
%threshold = 20;     % should be between 0 and 1000
threshold = -0.01;   % Edge detection
r = 6;

%%
% filter kernels
dx = [1 0 -1; 2 0 -2; 1 0 -1];      % horizontal gradient filter 
dy = dx';                           % vertical gradient filter

% Prewitt filter
% dx = [1 0 -1; 1 0 -1; 1 0 -1];      % horizontal gradient filter 
% dy = dx';                           % vertical gradient filter

% Scharr filter
% dx = [3 0 -3; 10 0 -10; 3 0 -3] / 3;      % horizontal gradient filter 
% dy = dx';                           % vertical gradient filter

g = fspecial('gaussian', max(1, len), sigma); % Gaussien Filter: filter size 2*n_x_sigma*sigma
%g = ones(len, len);
% g = hann(len)*hann(len)';
% Y = fft2(g);
% imagesc(abs(fftshift(Y)))


%% load 'Im.jpg'
frame = imread('../data/maze.jpg');

%% Call FindCorners function
[I, r1, c1] = FindCorners(frame, dx, dy, g, threshold, r, alpha);
[I, r1, c1] = FindEdge(frame, dx, dy, g, threshold, r, alpha);

%% Display
figure1 = figure;
imshow(I);
hold on;
plot(c1,r1,'or');
%exportgraphics(figure1, '../results/satellite_corner.jpg');
