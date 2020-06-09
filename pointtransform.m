function Y = pointtransform(X, x1, y1, x2, y2)
%POINTTRANSFORM - Particulary Contrast Stretching.
%   This function realizes the Contrast Streching Tranformation.
%   X is the 2D array containing the values of the pixels' brigthness.
%   x1, y1 is the first point, indicating the end of the first segment.
%   x2, y2 is the second point, indicating the end of the second segment.
%   Thus, we have all the information need for the tranfer function.

alpha = y1/x1; % Matlab supports division by zero (Inf).
beta = (y2-y1)/(x2-x1); % Matlab supports division by zero (Inf).
gamma = (1-y2)/(1-x2); % Matlab supports division by zero (Inf).

Y = zeros(size(X,1),size(X,2)); % Initialize memory for performance reasons.

for i = 1:size(X,1)
   for j = 1:size(X,2)
       if (X(i,j)<x1)
           if(alpha==Inf) % Check if the 1st segment is a vertical line.
               Y(i,j)=y1; % If so, assign the y-value of the end of the segment.
           else
               Y(i,j)=alpha*X(i,j); % Else calculate the value, as stated by the algorithm.
           end
       elseif (X(i,j)<x2)
           if(beta==Inf) % Check if the 2nd segment is a vertical line.
               Y(i,j)=y2; % If so, assign the y-value of the end of the segment.
           else
               Y(i,j)=beta*(X(i,j)-x1)+y1; % Else calculate the value, as stated by the algorithm. 
           end
       else
           if(gamma==Inf) % Check if the 3rd segment is a vertical line.
               Y(i,j)=1; % If so, assign the y-value of the end of the segment (1).
           else
               Y(i,j)=gamma*(X(i,j)-x2)+y2; % Else calculate the value, as stated by the algorithm. 
           end
       end   
   end
end

end

