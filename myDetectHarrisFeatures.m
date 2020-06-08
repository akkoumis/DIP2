function corners = myDetectHarrisFeatures(I)
%MYDETECTHARRISFEATURES - Detect corners on given image (I), using
%Harris-Stephens algorithm.
%   At first, we assign values to the parameters kappa and threshold. Then,
%   we initialize the 2D Gaussian filter, with its parameters (w_size and sigma).
%   Furthermore, we initialize the derivative masks for dx and dy and
%   filter the image I with those two masks. Using the results, we can
%   create helper matrices for calculating the A matrix of the algorithm.
%   Finally, for each pixel we apply the algorithm, by convoluting it with the
%   filter w and, thus, calculate the matrix M. Using the M, we can decide
%   whether it's a corner or not.
%
%   I is the image whom corners we must detect.

kappa = 0.04; % Kappa coefficient
threshold = 0.1; % The T coefficient.

max_Y = size(I,1);
max_X = size(I,2);

R = zeros(max_Y, max_X);

w_radius = 2; % The radius of the 2D Gaussian filter.
w_size = 2*w_radius+1; % The size of the 2D Gaussian filter, for each dimension.
sigma = w_size/3; % The standard deviation of the 2D Gaussian filter.
w = fspecial('gaussian',w_size,sigma); % Create the 2D Gaussian Filter.

[dx, dy] = meshgrid(-1:1, -1:1); % Create the derivative masks for both dimensions.

I1 = conv2(I,dx,'same'); % Calculate the dx derivative by convoluting the mask.
I2 = conv2(I,dy,'same'); % Calculate the dy derivative by convoluting the mask.

I1sq = I1.^2; % Helper matrix for M calculations.
I2sq = I2.^2; % Helper matrix for M calculations.
I12 = I1.*I2; % Helper matrix for M calculations.

corners=zeros(1,2); % Initialize the cornerns matrix to be returned. The first pair will be discarded at the end.

% Iterate through all the pixels (p2,p1) of the image.
% for p2=1+w_radius:max_Y-w_radius
%     for p1=1+w_radius:max_X-w_radius
for p2=1:max_Y
    for p1=1:max_X
        M = zeros (2,2);
        % Convolute with the 2D Gaussian filter with the A matrix.
        for u2=max(-w_radius,-p2+1):min(w_radius,-p2+max_Y)
            for u1=max(-w_radius,-p1+1):min(w_radius,-p1+max_X)
                A = [I1sq(p2+u2,p1+u1) I12(p2+u2,p1+u1); I12(p2+u2,p1+u1) I2sq(p2+u2,p1+u1)];
                M = M + w(u2+w_radius+1,u1+w_radius+1)*A;
            end
        end
        
        % Calculate the result, using the M matrix, as stated in the algorithm.
        R(p2,p1) =  det(M)-kappa*(trace(M).^2);
        if (R(p2,p1)>threshold) % Check if result passes threshold.
            temp =  [p2 p1];
            corners(size(corners,1)+1,:) = temp; % If yes, add the pair to the corners.
        end
    end
end

if(size(corners,1)>1)
    corners = corners(2:end,:); % Discard the first zero pair.
else
    clear corners;
end
end

