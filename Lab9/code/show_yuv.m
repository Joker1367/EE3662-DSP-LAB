function [I_Y_rgb, I_U_rgb, I_V_rgb] = show_yuv(I)
% Convert Y,U and V back to RGB individually,
% and show converted images.

    I = im2double(I);

    % RGB channel
    Y = I(:, :, 1);
    U = I(:, :, 2);
    V = I(:, :, 3);

    % yuv to rgb matrix
    matrix = [1 -0.00093 1.401687;
              1 -0.3437 -0.71417;
              1 1.77216 0.00099];

    R_Y = matrix(1,1).*Y;
    G_Y = matrix(2,1).*Y;
    B_Y = matrix(3,1).*Y;

    I_Y_rgb(:, :, 1) = R_Y;
    I_Y_rgb(:, :, 2) = G_Y;
    I_Y_rgb(:, :, 3) = B_Y;

    R_U = matrix(1,2).*(U-128/255);
    G_U = matrix(2,2).*(U-128/255);
    B_U = matrix(3,2).*(U-128/255);

    I_U_rgb(:, :, 1) = R_U;
    I_U_rgb(:, :, 2) = G_U;
    I_U_rgb(:, :, 3) = B_U;

    R_V = matrix(1,3).*(V-128/255);
    G_V = matrix(2,3).*(V-128/255);
    B_V = matrix(3,3).*(V-128/255);

    I_V_rgb(:, :, 1) = R_V;
    I_V_rgb(:, :, 2) = G_V;
    I_V_rgb(:, :, 3) = B_V;
    
    figure('name', 'Y  (Grayscale)'),
    imshow(I_Y_rgb);

    figure('name', 'U'),
    imshow(I_U_rgb);

    figure('name', 'V'),
    imshow(I_V_rgb);

    I_rgb = I_Y_rgb + I_U_rgb + I_V_rgb;
    figure('name', 'Original RGB')
    imshow(I_rgb)

end
