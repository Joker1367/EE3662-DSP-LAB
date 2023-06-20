% rotate image clockwised around the center point (1,1) with a radius degrees 
% input1---source image: I
% input2---rotation degrees: radius (ex: pi/6)
% output---rotated image: I_rot

function I_rot = rotation_nearest(I, radius)

    % RGB channel
    R(:, :) = I(:, :, 1);
    G(:, :) = I(:, :, 2);
    B(:, :) = I(:, :, 3);

    % get height, width, channel of image
    [height, width, channel] = size(I);

    %% create new image
    % step1. record image vertices, and use rotation matrix to get new vertices.
    matrix = [cos(radius) -sin(radius) ; sin(radius) cos(radius)];
    vertex = [0 0 width width; 0 height 0 height];
    new_vertex = matrix * vertex;
    
    disp(new_vertex);

    % step2. find min x, min y, max x, max y, use "min()" & "max()" function is ok
    min_x = min(new_vertex(1, :));
    max_x = max(new_vertex(1, :));
    min_y = min(new_vertex(2, :));
    max_y = max(new_vertex(2, :));

    % step3. consider how much to shift the image to the positive axis
    x_shift = 0 - min_x;
    y_shift = 0 - min_y;

    % step4. calculate new width and height, if they are not integer, use
    % "ceil()" & "floor()" to help get the largest width and height.
    width_new = ceil(max_x) - floor(min_x);
    height_new = ceil(max_y) - floor(min_y);

    % step5. initial r, g, b array for the new image
    R_rot = zeros(height_new, width_new, 'uint8');
    G_rot = zeros(height_new, width_new, 'uint8');
    B_rot = zeros(height_new, width_new, 'uint8');

    %% backward warping using nearest-neighborhood interpolation
    % for each pixel on the resized image, find the correspond r, g, b value 
    % from the source image, and save to R_res, G_res, B_res.
    inverse_matrix = [cos(radius) sin(radius) ; -sin(radius) cos(radius)];
    for y_new = 1 : height_new
        for x_new = 1 : width_new

            % step3. scale the new pixel (y_new, x_new) back to get (y_old, x_old)
            x_old = x_new - x_shift;
            y_old = y_new - y_shift;
            old_coord = inverse_matrix * [x_old; y_old];
            x_old = old_coord(1);
            y_old = old_coord(2);

            % step 3. Find the nearest pixel.
            % Hint: Use the round() function to calculate 
            % x_nearest and y_nearest
            x_nearest = round(x_old);
            y_nearest = round(y_old);

            % Assign pixels from (y_nearest, x_nearest) to (y_new, x_new)
            if y_nearest >= 1 && y_nearest <= height && x_nearest >= 1 && x_nearest <= width
                R_rot(y_new, x_new) = R(y_nearest, x_nearest);
                G_rot(y_new, x_new) = G(y_nearest, x_nearest);
                B_rot(y_new, x_new) = B(y_nearest, x_nearest);
            else
                R_rot(y_new, x_new) = 0;
                G_rot(y_new, x_new) = 0;
                B_rot(y_new, x_new) = 0;
            end
        end
    end


    % save R_rot, G_rot, B_rot to output image
    I_rot(:, :, 1) = R_rot;
    I_rot(:, :, 2) = G_rot;
    I_rot(:, :, 3) = B_rot;
end