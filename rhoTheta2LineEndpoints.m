function xy = rhoTheta2LineEndpoints(rho,theta,max_X,max_Y)
% RHOTHETA2LINEENDPOINTS - Return endpoints of a line, given rho and theta 
% of Hesse Normal Form, inside the bounds of an image, with size max_X of
% columns and max_Y of rows.
%   We isolate special cases and apply math theory to calculate the
%   coordinates.
%
%   --- Input ---
%   rho is the distance parameter of Hesse Normal Form.
%   theta is the angle parameter of Hesse Normal Form.
%   --- Output ---
%   xy is a column vector of the endpoint cartesian coordinates, as in [x_left x_right y_left y_right].

lambda_rho = tan(theta);
lambda_e = - 1/lambda_rho;
x_r = cos(theta)*rho;
y_r = sin(theta)*rho;

if (lambda_e == 0) % If the line is horizontal.
    xy = [0 max_X y_r y_r];
elseif (lambda_e == inf || lambda_e == -inf) % If the line is vertical.
    xy = [x_r x_r 0 max_Y];
else % The line is neither vertical nor horizontal.
    xy = zeros (1,4);
    beta = y_r-lambda_e*x_r; % Calculate beta of the equation, based on (x_r,y_r).
    
    % Calculate left endpoint of the line (closest to y axis).
    if (beta<0)
        y_left = 0;
        x_left = -beta/lambda_e;
    elseif (beta>max_Y)
        y_left = max_Y;
        x_left = (y_left - beta)/lambda_e;
    else
        x_left = 0;
        y_left = beta;
    end
    
    % Calculate right endpoint of the line (furthest from y axis).
    x_right = max_X;
    y_right = lambda_e*x_right+beta;
    if (y_right<0)
        y_right = 0;
        x_right = - beta/lambda_e;
    elseif(y_right>max_Y)
        y_right = max_Y;
        x_right = (y_right - beta)/lambda_e;
    end
    
    xy = [x_left x_right y_left y_right];
end

end

