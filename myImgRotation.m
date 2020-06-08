function rotImg = myImgRotation(img , angle)
%MYIMGROTATION - Rotate given image (img) by angle radians, counterclockwise
%   At first we calculate the corners the initial image in the cartesian
%   coordinate system and, then, rotate those using the calculated, from math
%   theory, transform matrix T. Given the rotated corners, we can calculate
%   how much to shift the image and expand the canvas, in order to fit the
%   rotated image. Then we project each pixel from the rotated image to the
%   original and calculate its value, in the rotated one, using bilinear
%   interpolation. That scales to each channel of the image (Greyscale, RGB).
%   
%   img is the initial image.
%   angle quantifies the counter-clockwise rotation (in radians).

T = [cos(angle) sin(angle); -sin(angle) cos(angle)]; % Transform Matrix for Rotation.

max_X = size(img,2); % Number of columns of initial image.
max_Y = size(img,1); % Number of rows of initial image.
no_of_channels = size(img,3); % Number of channels (1-Greyscale, 3-RGB).

corners = [0 max_X 0 max_X; 0 0 max_Y max_Y]; % The coordinates of the four corners of the image, in a cartesian coordinate system.
new_corners = T * corners; % Rotate those corners, in the cartesian coordinate system, as [x_i' y_i']' = T * [x_i y_i'], for i=1..4.

x_shift = floor(min(new_corners(1,:))); % Calculate shift in x-axis, to reposition image in positive quarter-plane.
y_shift = floor(min(new_corners(2,:))); % Calculate shift in y-axis, to reposition image in positive quarter-plane.

rot_max_X = ceil(max(new_corners(1,:)))-floor(min(new_corners(1,:))); % Calculate the number of columns of rotated image.
rot_max_Y = ceil(max(new_corners(2,:)))-floor(min(new_corners(2,:))); % Calculate the number of rows of rotated image.
rotImg = zeros(rot_max_Y,rot_max_X,no_of_channels);

for i=1:rot_max_Y
    for j=1:rot_max_X
        indices = (T')*[j+x_shift;i+y_shift]; % Project (x,y) pair from rotated image to initial, as [x y]' = inv(T) * [x' y']' = T' * [x' y']'.
        if(indices(1)>=1 && indices(1)<=max_X && indices(2)>=1 && indices(2)<=max_Y) % Check if (x,y) fall inside the boundries of initial image.
            floor_indices = floor(indices);
            alpha = indices(1) - floor_indices(1); % Calculate alpha coefficient, for bilinear interpolation equation.
            beta = indices(2) - floor_indices(2); % Calculate beta coefficient, for bilinear interpolation equation.
            for k=1:no_of_channels
                up_left_value = img(floor_indices(2),floor_indices(1),k);
                up_right_value = 0;
                down_left_value = 0;
                down_right_value = 0;
                if (floor_indices(1)<max_X)
                    up_right_value = img(floor_indices(2),floor_indices(1)+1,k);
                end
                if (floor_indices(2)<max_Y)
                    down_left_value = img(floor_indices(2)+1,floor_indices(1),k);
                end
                if (floor_indices(1)<max_X && floor_indices(2)<max_Y)
                    down_right_value = img(floor_indices(2)+1,floor_indices(1)+1,k);
                end
                
                % Bilinear Interpolation Equation (explained in the report).
                rotImg(i,j,k)= (1-alpha)*(1-beta)*up_left_value+(1-alpha)*beta*down_left_value+alpha*(1-beta)*up_right_value+alpha*beta*down_right_value;
            end
        end
    end
end

end

