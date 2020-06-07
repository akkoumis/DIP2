clear all;
%% Load image 2 and convert it to gray-scale %%
im2_rgb = imread('images\im2.jpg');
im2 = rgb2gray(im2_rgb);
im2 = imresize(im2,1/10);
im2 = double(im2) / 255;
figure('Name','Initial Image - Grayscale');
imshow(im2);

%% Matlab %%
rot = imrotate(im2,54,'bilinear','loose');
figure('Name','Matlab Rotation');
imshow(rot);


%% My Rotation %%
my_rot = myImgRotation(im2,54*pi/180);
figure('Name','My Rotation');
imshow(my_rot);

