clear all;
%% Load image 2 and convert it to gray-scale %%
im2_rgb = imread('images\im2.jpg');
im2 = rgb2gray(im2_rgb);
im2 = imresize(im2,1/2);
im2 = double(im2) / 255;
figure('Name','Initial Image - Grayscale');
imshow(im2);

%% Contrast Strech %%
im2_cs=pointtransform(im2,0.7561, 0.0392, 0.8039, 0.9608);
figure('Name','Image after Contrast Strech');
imshow(im2_cs);

%% My Canny %%
im2_canny = edge(im2_cs,'Canny',0.1);
figure('Name','Binary Image - Canny Edge Detection');
imshow(im2_canny);

%% My Hough Transform %%
tic;
[my_H,my_L,my_res] = myHoughTransform(im2_canny,1,pi/180,30);
my_hough_time = toc;

my_T = -pi/2:pi/180:pi/2;
N1 = size(im2_canny, 1);
N2 = size(im2_canny, 2);
rho_max = round(sqrt(N1.^2 + N2.^2));
my_R = -rho_max:1:rho_max;

figure('Name','Hough');
imshow(im2_cs), hold on
for k = 1:length(my_L)
    xy = rhoTheta2LineEndpoints(my_L(k,1),my_L(k,2),N2,N1);
    line([xy(1) xy(2)], [xy(3) xy(4)]);
end
hold off;

%% My Harris Corner %%
tic;
my_corners = myDetectHarrisFeatures(im2_cs);
my_time = toc;
figure('Name','My Harris');
imshow(im2_cs);
hold on
% plot(my_corners(:,2),my_corners(:,1),'rs','MarkerSize',10);
plot(my_corners(:,2),my_corners(:,1),'rs');
hold off

%% Eliminate the lines that don't have a parallel %%