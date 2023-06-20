% rotate image clockwised around the center point (1,1) with a radius degrees 
% input1---source image: I
% input2---rotation degrees: radius (ex: pi/6)
% output---rotated image: I_rot

function I_rot = rotation_forward(I, radius)

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


    %% Forward warping   
    for i = 1 : height
        for j = 1 : width

            % step5. shift the new pixel (y_new, x_new) back, and rotate -radius
            % degree to get (y_old, x_old)
            new_coord = matrix * [j; i];
            x_new = round(new_coord(1) + x_shift);
            y_new = round(new_coord(2) + y_shift);
            
            % Slpatting
            x1 = floor(x_new);
            x2 = ceil(x_new);
            y1 = floor(y_new);
            y2 = ceil(y_new);
           

            if ((x1 >= 1) && (x1 <= width_new) && (x2 >= 1) && (x2 <= width_new) && (y1 >= 1) && ...
                (y1 <= height_new)&& (y2 >= 1) && (y2 <= height_new))
                R_rot(y1, x1) = R(i, j);
                R_rot(y1, x2) = R(i, j);
                R_rot(y2, x1) = R(i, j);
                R_rot(y2, x2) = R(i, j);

                G_rot(y1, x1) = G(i, j);
                G_rot(y1, x2) = G(i, j);
                G_rot(y2, x1) = G(i, j);
                G_rot(y2, x2) = G(i, j);

                B_rot(y1, x1) = B(i, j);
                B_rot(y1, x2) = B(i, j);
                B_rot(y2, x1) = B(i, j);
                B_rot(y2, x2) = B(i, j);
            end
        end
    end

    % save R_rot, G_rot, B_rot to output image
    I_rot(:, :, 1) = R_rot;
    I_rot(:, :, 2) = G_rot;
    I_rot(:, :, 3) = B_rot;
end