clear all;
%% Load image 2 and convert it to gray-scale %%
% im2_rgb = imread('images\im2.jpg');
im2 = imread('images\im2.jpg');
% im2 = im2_rgb;
% im2 = rgb2gray(im2_rgb);
% im2 = imresize(im2,1/10);
im2 = double(im2) / 255;
figure('Name','Initial Image');
imshow(im2);

%% Matlab %%
tic;
rot = imrotate(im2,54,'bilinear','loose');
time = toc;
figure('Name','Matlab Rotation 1');
imshow(rot);

tic;
rot2 = imrotate(im2,213,'bilinear','loose');
time2 = toc;
figure('Name','Matlab Rotation 2');
imshow(rot2);
%% My Rotation %%
tic;
my_rot = myImgRotation(im2,54*pi/180);
my_time = toc;
figure('Name','My Rotation 1');
imshow(my_rot);

tic;
my_rot2 = myImgRotation(im2,213*pi/180);
my_time2 = toc;
figure('Name','My Rotation 2');
imshow(my_rot2);

%% Calculate Error %%
error = imresize(rot,[size(my_rot,1) size(my_rot,2)],'bilinear') - my_rot;
error_value = sum(error(:))/sum(sum(sum((error~=0))));

error2 = imresize(rot2,[size(my_rot2,1) size(my_rot2,2)],'bilinear') - my_rot2;
error2_value = sum(error2(:))/sum(sum(sum((error2~=0))));
