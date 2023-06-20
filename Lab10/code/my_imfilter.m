function output = my_imfilter(image, filter)
% This function is intended to behave like the built-in function imfilter()
% See 'help imfilter' or 'help conv2'. Terms like "filtering" and
% "convolution" can be used interchangeably, as they are basically the same
% thing.

% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' or 'help imfilter', you see that they have
% several options to deal with boundaries. Therefore, You should pad the input image with zeros, 
% and return a filtered image which matches the input resolution. 

% Built-in functions like imfilter, filter2, conv2 are forbidden to use. 
% Simply loop over all the pixels and do the actual computation.

% Potentially useful MATLAB functions: padarray()

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%
[height, width, channel] = size(image);
[row, col] = size(filter);
pad_row = (row - 1) / 2;
pad_col = (col - 1) / 2;

image = padarray(image, [pad_row pad_col], 0, 'both');
%disp(size(image));

output = zeros(height, width, channel);

for i = 1 : height
    for j = 1 : width
        for c = 1 : channel
            output(i, j, c) = sum(filter .* image(i:i + row - 1, j:j + col - 1, c), 'all');
        end
    end
end
%%%%%%%%%%%%%%%%
% Your code end
%%%%%%%%%%%%%%%%
