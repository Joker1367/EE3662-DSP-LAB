% shear image according to the shift pixels in both x and y axises
% input1---source image: I
% input2---shift pixel in x axis: sh_x (ex: -0.8)
% input3---shift pixel in y axis: sh_y (ex: 0.2)
% output---shear image: I_shear

function I_shear = shear(I, sh_x, sh_y)

    % RGB channel
    R(:, :) = I(:, :, 1);
    G(:, :) = I(:, :, 2);
    B(:, :) = I(:, :, 3);

    % get height, width, channel of image
    [height, width, channel] = size(I);

    %% create new image
    % step1. record image vertices, and use the transformation matrix to get new vertices.
    matrix = [1 sh_x; sh_y 1];
    vertex = [0 0 width width; 0 height 0 height]; 
    new_vertex = matrix * vertex;

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
    R_shear = uint8(zeros(height_new, width_new));
    G_shear = uint8(zeros(height_new, width_new));
    B_shear = uint8(zeros(height_new, width_new));

    %% backward warping using bilinear interpolation
    % for each pixel on the shear image, find the correspond r, g, b value 
    % from the source image, and save to R_shear, G_shear, B_shear.
    inverse_matrix = inv(matrix);
    for y_new = 1 : height_new
        for x_new = 1 : width_new

            % step5. shift the new pixel (y_new, x_new) back, 
            % and reverse the shear transformation to get (y_old, x_old)
            x_old = x_new - x_shift;
            y_old = y_new - y_shift;
            old_coord = inverse_matrix * [x_old; y_old];
            x_old = old_coord(1);
            y_old = old_coord(2);

            % step6. use "ceil()" & "floor()" to get interpolation coordinates
            % x1, x2, y1, y2
            x1 = floor(x_old);
            x2 = ceil(x_old);
            y1 = floor(y_old);
            y2 = ceil(y_old);

            % step7. if (y_old, x_old) is inside of the source image, 
            % calculate r, g, b by interpolation.
            % else if (y_old, x_old) is outside of the source image, set
            % r, g, b = 0 (black).
            if (x1 >= 1) && (x1 <= width) && (x2 >= 1) && (x2 <= width) && ...
                (y1 >= 1) && (y1 <= height)&& (y2 >= 1) && (y2 <= height)
            
                r1 = R(y1, x1);
                r2 = R(y1, x2);
                r3 = R(y2, x2);
                r4 = R(y2, x1);
                
                g1 = G(y1, x1);
                g2 = G(y1, x2);
                g3 = G(y2, x2);
                g4 = G(y2, x1);
                
                b1 = B(y1, x1);
                b2 = B(y1, x2);
                b3 = B(y2, x2);
                b4 = B(y2, x1);

                % step8. calculate weight wa, wb, notice that if x1 = x2 or y1 = y2,
                % function "wa = ()/(x1-x2)" will be fail. 
                % at this situation, you need to assign a value to wa directly.
                if(x1 == x2)
                    wa = 1 / 2;
                else
                    wa = (x_old - x1) / (x2 - x1);
                end
                
                if(y1 == y2)
                    wb = 1 / 2;
                else
                    wb = (y_old - y1) / (y2 - y1);
                end

                % step9. calculate weight w1, w2, w3, w4. 
                w1 = (1 - wa) * (1 - wb);
                w2 = wa * (1 - wb);
                w3 = wa * wb;
                w4 = (1 - wa) * wb;

                % step10. calculate r, g, b with 4 neighbor points and their weights
                r = r1 * w1 + r2 * w2 + r3 * w3 + r4 * w4;
                g = g1 * w1 + g2 * w2 + g3 * w3 + g4 * w4;
                b = b1 * w1 + b2 * w2 + b3 * w3 + b4 * w4;

            else
                r = 0;
                g = 0;
                b = 0;
            end
            R_shear(y_new, x_new) = r;
            G_shear(y_new, x_new) = g;
            B_shear(y_new, x_new) = b;
        end
    end

    % save R_shear, G_shear, B_shear to output image
    I_shear(:, :, 1) = R_shear;
    I_shear(:, :, 2) = G_shear;
    I_shear(:, :, 3) = B_shear;

end
