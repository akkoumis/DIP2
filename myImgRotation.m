function rotImg = myImgRotation(img , angle)
%MYIMGROTATION Summary of this function goes here
%   Detailed explanation goes here

T = [cos(angle) sin(angle); -sin(angle) cos(angle)]; % Transform Matrix for rotation.

max_X = size(img,2);
max_Y = size(img,1);

% corners = [0 max_X 0 max_X; 0 0 max_Y max_Y];
corners = [0 max_X-1 0 max_X-1; 0 0 max_Y-1 max_Y-1];
new_corners = T * corners;
% x_shift = min(0,min(new_corners(1,:)));
x_shift = floor(min(new_corners(1,:)));
y_shift = floor(min(new_corners(2,:)));

% rot_max_X = max_X-x_shift;
% rot_max_Y = max_Y-y_shift;
rot_max_X = ceil(max(new_corners(1,:)))-floor(min(new_corners(1,:)));
rot_max_Y = ceil(max(new_corners(2,:)))-floor(min(new_corners(2,:)));
rotImg = zeros(rot_max_Y,rot_max_X);

for i=1:rot_max_Y
    for j=1:rot_max_X
        indices = (T')*[j+x_shift;i+y_shift];
        if(indices(1)>=1 && indices(1)<=max_X && indices(2)>=1 && indices(2)<=max_Y)
            rotImg(i,j)=img(floor(indices(2)),floor(indices(1)));
        end
    end
end

end

