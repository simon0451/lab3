function [output1, output2] = leastSquares(x,y)
%this function produces a least squares best fit line from the given x and
%y arrays, there are 100 points in the best fit array


input = [x,y]; %input line
pts = length(input);             % number of points
X = [ones(pts,1), input(:,1)];   % forming X of X beta = y
y = input(:,2);                % forming y of X beta = y
betaHat = (X' * X) \ X' * y;   % computing projection of matrix X on y, giving beta
%disp(betaHat);
% plot the best fit line
%xx = linspace(0,100);
%yy = betaHat(1) + betaHat(2)*xx; %betaHat(1) is the Y-intercept, and betaHat(2) is the slope
% plot the points (data) for which we found the best fit
m = betaHat(2);
b = betaHat(1);

xx = x;
yy = betaHat(1) + betaHat(2)*xx;

output1 = [xx,yy]; %the actual line
%output1 = output1';
output2 = [m,b]; %slope of the line and y intercept

end

