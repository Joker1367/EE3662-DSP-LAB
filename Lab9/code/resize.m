% resize image with input scale 
% input1---source image: I
% input2---resize scale
% output---resized image 

function I_res = resize(I, scale)

    % RGB channel
    R(:, :) = I(:, :, 1);
    G(:, :) = I(:, :, 2);
    B(:, :) = I(:, :, 3);

    % get height, width, channel of image
    [height, width, channel] = size(I);

    %% create new image
    % step1. calculate new width and height, if they are not integer, use
    % "ceil()" or "floor()" to help get the largest width and height.
    height_new = floor(height * scale);
    width_new  = floor(width * scale);

    % step2. initial r, g, b array for the new image
    R_res = uint8(zeros(height_new, width_new));
    G_res = uint8(zeros(height_new, width_new));
    B_res = uint8(zeros(height_new, width_new));

    %% backward warping using nearest-neighborhood interpolation
    % for each pixel on the resized image, find the correspond r, g, b value 
    % from the source image, and save to R_res, G_res, B_res.
    for y_new = 1 : height_new
        for x_new = 1 : width_new

            % step3. scale the new pixel (y_new, x_new) back to get (y_old, x_old)
            x_old = x_new / scale;
            y_old = y_new / scale;

            % step 3. Find the nearest pixel.
            % Hint: Use the round() function to calculate 
            % x_nearest and y_nearest
            x_nearest = round(x_old);
            y_nearest = round(y_old);

            % Assign pixels from (y_nearest, x_nearest) to (y_new, x_new)
            if y_nearest >= 1 && y_nearest <= height && x_nearest >= 1 && x_nearest <= width
                R_res(y_new, x_new) = R(y_nearest, x_nearest);
                G_res(y_new, x_new) = G(y_nearest, x_nearest);
                B_res(y_new, x_new) = B(y_nearest, x_nearest);
            else
                R_res(y_new, x_new) = 0;
                G_res(y_new, x_new) = 0;
                B_res(y_new, x_new) = 0;
            end
        end
    end

    % save R_rot, G_rot, B_rot to output image
    I_res(:, :, 1) = R_res;
    I_res(:, :, 2) = G_res;
    I_res(:, :, 3) = B_res;
end
