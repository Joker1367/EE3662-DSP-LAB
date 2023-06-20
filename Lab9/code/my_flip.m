% input1---source image: I
% input2---flip direction: type (0: horizontal, 1: vertical, 2: both)
% output---flipped image: I_flip

function I_flip = my_flip(I, type)

    % RGB channel
    R = I(:, :, 1);
    G = I(:, :, 2);
    B = I(:, :, 3);

    % get height, width, channel of image
    [height, width, channel] = size(I);

    % initial r, g, b array for flipped image using zeros()
    R_flip = zeros(height, width, 'uint8'); 
    G_flip = zeros(height, width, 'uint8');
    B_flip = zeros(height, width, 'uint8');

    %%  horizontal flipping
    if type == 0
        %%% your code here %%%
        % assign pixels from R, G, B to R_flip, G_flip, B_flip
        for i = 1 : height
            for j = 1 : width
                R_flip(i, j) = R(i, width + 1 - j);
                G_flip(i, j) = G(i, width + 1 - j);
                B_flip(i, j) = B(i, width + 1 - j);
            end
        end
    end


    %% vertical flipping
    if type == 1
        %%% your code here %%%
        % assign pixels from R, G, B to R_flip, G_flip, B_flip
        for i = 1 : width
            for j = 1 : height
                R_flip(j, i) = R(height + 1 - j, i);
                G_flip(j, i) = G(height + 1 - j, i);
                B_flip(j, i) = B(height + 1 - j, i);
            end
        end
    end

    %% flip both
    if type == 2
        %%% your code here %%%
        % assign pixels from R, G, B to R_flip, G_flip, B_flip
        for i = 1 : height
            for j = 1 : width
                R_flip(i, j) = R(height + 1 - i, width + 1 - j);
                G_flip(i, j) = G(height + 1 - i, width + 1 - j);
                B_flip(i, j) = B(height + 1 - i, width + 1 - j);
            end
        end
    end
    
    % save R_flip, G_flip, B_flip to output image
    I_flip(:, :, 1) = R_flip;
    I_flip(:, :, 2) = G_flip;
    I_flip(:, :, 3) = B_flip;
end

