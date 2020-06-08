function [H, L, res] = myHoughTransform(img_binary , Drho , Dtheta , n)
%MYHOUGHTRANSFORM - The Hough Transform of a binary image with specific rho
% and theta resolution and number of strongest lines to be returned. 
%       
%
%   --- Input ---
%   img_binary is a binary image (black-white), a product of Thresholding
%   on a greyscale image.
%   Drho is the resolution (in pixels) of the rho axis in the parameter space.
%   Dtheta is the resolution (in rads) of the theta axis in the parameter space.
%   n is the number of the strongest lines to be returned, based on the
%   votes in the cells of the Hough matrix.
%   --- Output ---
%   H is the voting matrix of the Hough Tranform.
%   L is a matrix containing the rho and theta parameters of detected lines.
%   res is the number of pixels of the image that don't belong in any
%   detected line.

N1 = size(img_binary, 1);
N2 = size(img_binary, 2);
rho_max = round(sqrt(N1.^2 + N2.^2));
theta_max = pi/2;
T = ceil(2*theta_max/Dtheta); % Calculating number of divisions of theta axis.
R = ceil(2*rho_max/Drho); % Calculating number of divisions of rho axis.
R = R-1;

thetas = linspace(-theta_max, theta_max, T+1); % Slice the theta axis.
%thetas = -theta_max:Dtheta:theta_max;
rhos = linspace(-rho_max, rho_max, R+1); % Slice the rho axis.
%rhos = -rho_max:1:rho_max;

H = zeros(R, T, 2); % Initialize H, with a third dimesions for calculating res.
L = zeros(n,3); % Initialize L, third column is the number of votes.

% Iterate through all the pixels of the image.
for n1=1:N1 % Corresponds to the rows = y in Hessian normal form.
    for n2=1:N2 % Corresponds to the columns = x in Hessian normal form.
        % Check if the pixel is an edge. If so, proceed to vote on H.
        if (img_binary(n1,n2)==1)
            % Check for every angle (theta) the corresponding distance
            % (rho). Then increment the resulting (rho, theta) cell of H.
            for j=1:T
                %t = (thetas(j) + thetas(j+1))/2;
                t = thetas(j); % Assign the jth-value of the thetas vector to t.
                r = n2*cos(t) + n1*sin(t); % Calculate rho.
                
                % Calculate corresponding index of r in rhos vector.
                dists = rhos-r;
                [d,i]=min(abs(dists)); % Calculate 
                if (dists(i)<0 && i>1)
                    i=i-1;
                end
                
                H(i,j,1)=H(i,j,1)+1; % Add a vote to H
                k = sum(H(i,j,:)>0);
                H(i,j,k+1)= n1+N1*n2; % Add the unique id of the pixel to the 3rd dimension of the matrix,
                                      % to keep track of which are part of the specific line.
                
                % Check if (i, j) pair exists in L.
                [row col]=find(L(:,1)==i & L(:,2)==j);
                if (isempty(row)==1)
                    % If not, check the number of points is greater than
                    % the minimum of L matrix.
                    if(H(i,j,1)>=L(1,3))
                        L(1,:)=[i j H(i,j,1)]; % If so, then replace entire row in L.
                    end
                else
                    % If it exists, then update the values and sort the L
                    % matrix, in acsending order, based on nuumber of
                    % points.
                    L(row,:)=[i j H(i,j,1)];
                    L=sortrows(L,3);
                end
                
            end
        end
    end
end

% Calculate how many pixels are part of the strongest lines, then detacting
% from total number of pixels.
res=N1*N2-sum(unique(H(:,:,2:end))>0);

L=L(:,1:2);
L(:,1)=rhos(L(:,1)); % Return the values of rho from the indices.
L(:,2)=thetas(L(:,2)); % Return the values of theta from the indices.

H=H(:,:,1); % Return only the voting matrix and discard the 3rd dimension.
end

