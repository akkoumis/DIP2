clear all;
%% Load image 2 and convert it to gray-scale %%
im2_rgb = imread('images\im2.jpg');
im2 = rgb2gray(im2_rgb);
im2 = imresize(im2,1/10);
im2 = double(im2) / 255;
figure('Name','Initial Image - Grayscale');
imshow(im2);

%% Matlab %%
corners=detectHarrisFeatures(im2,'MinQuality',0.1);
figure
imshow(im2);
hold on
plot(corners);
hold off

%% My Harris Corner %%
my_corners = myDetectHarrisFeatures(im2);
figure
imshow(im2);
hold on
% plot(my_corners(:,2),my_corners(:,1),'rs','MarkerSize',10);
plot(my_corners(:,2),my_corners(:,1),'r+');
hold off