function [H, L, res] = myHoughTransform(img_binary , Drho , Dtheta , n)
%MYHOUGHTRANSFORM - The Hough Transform of binary image
%   Detailed explanation goes here
%   --- Input ---
%   img_binary is a binary image (black-white), a product of Thresholding
%   on a greyscale image.
%   Drho is the resolution (in pixels) of the rho axis in the parameter space.
%   Dtheta is the resolution (in rads) of the theta axis in the parameter space.
%   n is the number of the strongest lines to be returned, based on the
%   votes in the cells of the Hough matrix.
%   --- Output ---
%   H is the voting matrix of the Hough Tranform.
%   L
%   res

N1 = size(img_binary, 1);
N2 = size(img_binary, 2);
%rho_max = sqrt(N1.^2 + N2.^2);
rho_max = round(sqrt(N1.^2 + N2.^2));
%theta_max = 2 * pi;
theta_max = pi/2;
T = ceil(2*theta_max/Dtheta);
R = ceil(2*rho_max/Drho);
R=R-1;

%thetas = linspace(0, theta_max, T+1);
thetas = linspace(-theta_max, theta_max, T+1); % Slice the theta axis.
%rhos = linspace(0, rho_max, R+1);
rhos = linspace(-rho_max, rho_max, R+1); % Slice the rho axis.

H = zeros(R, T);

for n1=1:N1
    for n2=1:N2
        if (img_binary(n1,n2)==1)
            
            for j=1:T
                %t = (thetas(j) + thetas(j+1))/2;
                t = thetas(j);
                r = n1*cos(t) + n2*sin(t);
                dists = rhos-r;
                [d,i]=min(abs(dists));
                if (dists(i)<0)
                   %i=i-1; 
                end
                
                if (d<1)
                    H(i,j)=H(i,j)+1;
                    break;
                end
            end
        end
    end
end

%{
for j=1:T
    t = (thetas(j) + thetas(j+1))/2;
    c=cos(t);
    s=sin(t);
    [row,col] = find(img_binary);
    n_max=length(row);
    
    for n=1:n_max
        r = row(n)*c + col(n)*s;
        for i=2:R+1
            if (rhos(i)>=r)
                H(i-1,j)=H(i-1,j)+1;
                break;
            end
        end
    end
end
%}

L=1;
res=1;
end

