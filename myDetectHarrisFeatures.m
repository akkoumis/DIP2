function corners = myDetectHarrisFeatures(I)
%MYDETECTHARRISFEATURES Summary of this function goes here
%   Detailed explanation goes here

kappa = 0.14;
threshold = 0.05;

max_Y = size(I,1);
max_X = size(I,2);

%M = zeros(max_Y, max_X);
R = zeros(max_Y, max_X);

sigma = 1;
w_radius = 4;
w_size = 2*w_radius+1;
w = fspecial('gaussian',w_size,sigma);

[dx, dy] = meshgrid(-1:1, -1:1);

I1 = conv2(I,dx,'same');
I2 = conv2(I,dy,'same');

I1sq = I1.^2;
I2sq = I2.^2;
I12 = I1.*I2;

corners=zeros(1,2);

for p2=1+w_radius:max_Y-w_radius
   for p1=1+w_radius:max_X-w_radius
       M = zeros (2,2);
       for u2=-w_radius:w_radius
           for u1=-w_radius:w_radius
               M = M + w(u2+w_radius+1,u1+w_radius+1)*[I1sq(p2+u2,p1+u1) I12(p2+u2,p1+u1); I12(p2+u2,p1+u1) I2sq(p2+u2,p1+u1)];       
           end
       end
%        A = [I1sq(p2,p1) I12(p2,p1); I12(p2,p1) I2sq(p2,p1)]; 
       
       
       R(p2,p1) =  det(M)-kappa*(trace(M).^2);
       if (R(p2,p1)>threshold)
           temp =  [p2 p1];
          corners(size(corners,1)+1,:) = temp; 
       end
   end    
end

corners = corners(2:end,:);

end

