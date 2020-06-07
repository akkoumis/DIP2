function rotImg = myImgRotation(img , angle)
%MYIMGROTATION Summary of this function goes here
%   Detailed explanation goes here

T = [cos(angle) sin(angle); -sin(angle) cos(angle)]; % Transform Matrix for rotation.

max_X = size(img,2);
max_Y = size(img,1);

corners = [0 max_X-1 0 max_X-1; 0 0 max_Y-1 max_Y-1];
new_corners = T * corners;

x_shift = floor(min(new_corners(1,:)));
y_shift = floor(min(new_corners(2,:)));

rot_max_X = ceil(max(new_corners(1,:)))-floor(min(new_corners(1,:)))+1; % +1 because matlab indices start at 1.
rot_max_Y = ceil(max(new_corners(2,:)))-floor(min(new_corners(2,:)))+1; % +1 because matlab indices start at 1.
rotImg = zeros(rot_max_Y,rot_max_X);

for i=1:rot_max_Y
    for j=1:rot_max_X
        indices = (T')*[j+x_shift;i+y_shift];
        if(indices(1)>=1 && indices(1)<=max_X && indices(2)>=1 && indices(2)<=max_Y)
%             rotImg(i,j)=img(floor(indices(2)),floor(indices(1)));
            floor_indices = floor(indices);
            alpha = indices(1) - floor_indices(1);
            beta = indices(2) - floor_indices(2);
            up_left_value = img(floor_indices(2),floor_indices(1));
            up_right_value = 0;
            down_left_value = 0;
            down_right_value = 0;
            if (floor_indices(1)<max_X)
                up_right_value = img(floor_indices(2),floor_indices(1)+1);
            end
            if (floor_indices(2)<max_Y)
                down_left_value = img(floor_indices(2)+1,floor_indices(1));
            end
            if (floor_indices(1)<max_X && floor_indices(2)<max_Y)
                down_right_value = img(floor_indices(2)+1,floor_indices(1)+1);
            end
            rotImg(i,j)= (1-alpha)*(1-beta)*up_left_value+(1-alpha)*beta*down_left_value+alpha*(1-beta)*up_right_value+alpha*beta*down_right_value;
        end
    end
end

end

