function [output] = confInt2(x,y)

[~,BF] = leastSquares(x,y);
m = BF(1); %slope
b = BF(2); %y intercept

% yfffff = (ThermocoupleVoltage-betaHat(1))/betaHat(2); %°C
% Part3BF = polyfit(ThermistorTemperature,ThermocoupleTemperature,1);
bfy = m*x+b; %Generating y values for the best fit

Yc = bfy; %The value of y predicted by the least squares equation for a given value of x
tvp = 2.080; %For N = 22, 95% confidence
yiyci = (y-bfy).^2;
sumyiyci = sum(yiyci);
Syx = (sumyiyci/(length(y)-1))^.5; %standard error of the fit
SampleMeanValue = (sum(x))/length(x);

unsummedDen = zeros(1,length(x)); %pre-allocating for faster for loop performance

for i = 1:1:length(x)
    unsummedDen(i) = (x(i)-SampleMeanValue)^2;
end
Den = sum(unsummedDen);

CIofFitPOS = Yc+tvp.*Syx.*(1./length(y)+((x-SampleMeanValue).^2./(Den))).^.5;
CIofFitNEG = Yc-tvp.*Syx.*(1./length(y)+((x-SampleMeanValue).^2./(Den))).^.5;

CIofMeasurementPOS = Yc+tvp.*Syx.*(1+1./length(y)+((x-SampleMeanValue).^2./(Den))).^.5;
CIofMeasurementNEG = Yc-tvp.*Syx.*(1+1./length(y)+((x-SampleMeanValue).^2./(Den))).^.5;

xq = linspace(x(1),x(end));
cifp = interp1(x,CIofFitPOS,xq,'spline');
cifn = interp1(x,CIofFitNEG,xq,'spline');
cimp = interp1(x,CIofMeasurementPOS,xq,'spline');
cimn = interp1(x,CIofMeasurementNEG,xq,'spline');
 
outputrows = [cifp;cifn;cimp;cimn];
output = outputrows';


end