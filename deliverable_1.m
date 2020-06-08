clear all;
%% Load image 2 and convert it to gray-scale %%
im2_rgb = imread('images\im2.jpg');
im2 = rgb2gray(im2_rgb);
im2 = imresize(im2,1/10);
im2 = double(im2) / 255;
figure('Name','Initial Image - Grayscale');
imshow(im2);

%% Edge Detector %%
im2_canny = edge(im2,'Canny',0.25);
figure('Name','Binary Image - Canny Edge Detection');
imshow(im2_canny);
%
im2_sobel = edge(im2);
figure('Name','Binary Image - Sobel Edge Detection');
imshow(im2_sobel);
%
%% Hough Transform - Canny %%
tic;
[H_canny,T_canny,R_canny] = hough(im2_canny,'RhoResolution',1,'Theta',-90:1:89);
hough_time = toc;
figure('Name','Canny');
subplot(2,1,1);

imshow(imadjust(rescale(H_canny)),'XData',T_canny,'YData',R_canny,...
      'InitialMagnification','fit');
title('Hough Transform of Canny');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca,hot);
P_canny  = houghpeaks(H_canny,10,'threshold',ceil(0.3*max(H_canny(:))));
x = T_canny(P_canny(:,2)); y = R_canny(P_canny(:,1));
plot(x,y,'s','color','blue');
hold off;

subplot(2,1,2);
lines = houghlines(im2_canny,T_canny,R_canny,P_canny,'FillGap',5,'MinLength',15);
imshow(im2_rgb), hold on
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% end
title('Canny');
hold off;

%% Hough Transform - Sobel %%
% [H_sobel,T_sobel,R_sobel] = hough(im2_sobel,'RhoResolution',1,'Theta',-90:1:89);
% figure('Name','Sobel');
% subplot(2,1,1);
% imshow(imadjust(rescale(H_sobel)),'XData',T_sobel,'YData',R_sobel,...
%       'InitialMagnification','fit');
% title('Hough transform of Sobel');
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal, hold on;
% colormap(gca,hot);
% P_sobel  = houghpeaks(H_sobel,10,'threshold',ceil(0.3*max(H_sobel(:))));
% x = T_sobel(P_sobel(:,2)); y = R_sobel(P_sobel(:,1));
% plot(x,y,'s','color','blue');
% hold off;
% 
% subplot(2,1,2);
% lines = houghlines(im2_sobel,T_sobel,R_sobel,P_sobel,'FillGap',10,'MinLength',7);
% imshow(im2_rgb), hold on
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% end
% title('Sobel');
% hold off;

%% My Hough Transform %%
tic;
[my_H_canny,my_L,my_res] = myHoughTransform(im2_canny,1,pi/180,10);
my_hough_time = toc;

my_T_canny = -pi/2:pi/180:pi/2;
N1 = size(im2_canny, 1);
N2 = size(im2_canny, 2);
rho_max = round(sqrt(N1.^2 + N2.^2));
my_R_canny = -rho_max:1:rho_max;

% Plot My Hough Transform.
figure('Name','My Canny');
subplot(2,1,1);
%imshow(imadjust(rescale(my_H_canny)),'XData',my_T_canny,'YData',my_R_canny,...
%      'InitialMagnification','fit');
imshow(my_H_canny,[ ],'XData',my_T_canny,'YData',my_R_canny);
title('My Hough Transform of Canny');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
%colormap(gca,hot);
x = my_L(:,2); y = my_L(:,1);
plot(x,y,'s','color','blue');
hold off;

% Draw image with the lines, based on My Hough Transform.
subplot(2,1,2);
imshow(im2), hold on
for k = 1:length(my_L)
    xy = rhoTheta2LineEndpoints(my_L(k,1),my_L(k,2),N2,N1);
    line([xy(1) xy(2)], [xy(3) xy(4)]);
end
title('My Canny');
hold off;

%% Upscale Image %%
im2_up = rgb2gray(im2_rgb);
figure('Name','Upscaled Image');
imshow(im2_up), hold on
for k = 1:length(my_L)
    xy = rhoTheta2LineEndpoints(my_L(k,1)*10,my_L(k,2),size(im2_up,2),size(im2_up,1));
    line([xy(1) xy(2)], [xy(3) xy(4)]);
end
title('My Canny - Upscaled');
hold off;