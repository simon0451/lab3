%% Header
%Simon Popecki
%3. March 2017
%ME 646

%lab3.mat information
%BEAMPRESS: the deflection of the beam from 0 inches to .250 inches
%[deflection (inches) , voltage output (mV)]

%BEAMRELEASE: the return of the beam from .250 inches to 0 inches
%[deflection (inches) , voltage output (mV)]

%DER: the comparison between shunt resistor resistance and the
%corresponding change in voltage [voltage (mV) , resistance (kOhm)]

%ZEROVMASSLOADV: the zero voltage, mass applied to the beam, and the
%voltage outputted by the strain gauage [mV,g,mV]

%BUCKETWEIGHT: the mass of the bucket used to weigh samples in
%ZEROVMASSLOADV, grams

%% Beam/Strain Gauge Response
clear all;
close all;
load lab3.mat
%DER - (:,1) is the output voltage (IN MILLIVOLTS) and (:,2) is
%the resistance for the given shunt resistor(K OHMS)

%The resistance is the independent variable
RSG = 120; %Ohms
Rshunt = (DER(:,2)*1000); %converting to Ohms
deltaR = RSG-((RSG.*Rshunt)./(RSG+Rshunt));
deltaE = (DER(:,1)/1000)/100; %converting to volts, dividing by gain of 100

[REbestfit,REbestfitmb] = leastSquares(deltaR,deltaE); %the slope and y intercept of the best fit line
REbfx = REbestfit(:,1);
REbfy = REbestfit(:,2);

%making all the y values for the confidence intervals
conInts = confInt(deltaR,deltaE); %for an N of 5, v of 4
cifp = conInts(:,1);
cifn = conInts(:,2);
cimp = conInts(:,3);
cimn = conInts(:,4);
cix = linspace(deltaR(1),deltaR(end));

m = num2str(REbestfitmb(2),3);
b = num2str(REbestfitmb(1),3);
txt = strcat('V =',m,' (V/\Omega) R ',b,' (V)');
txt2 = 'Sample Variance deg. of Freedom: 4';
txt3 = 'Student''s t Variable at 95% conf.: 2.770';

figure
plot(deltaR,deltaE,'o',REbfx,REbfy,cix,cifp,'b--',cix,cimp,'r--',cix,cifn,'b--',cix,cimn,'r--')
title('H-Bridge Sensitivity')
ylabel('Change in Output Voltage (V)')
xlabel('Change in Resistance (\Omega)')
xmin = .08;
xmax = .27;
ymin = -.0035;
ymax = 0;
axis ([xmin xmax ymin ymax])
text(.35*xmax,.9*ymin,txt)
text(.35*xmax,.85*ymin,txt2)
text(.35*xmax,.8*ymin,txt3)
legend('Data','Least Squares Best Fit','Confidence Interval of Fit (95%)','Confidence Interval of Meas. (95%)','location','northeast')

%% FFT


figure
x = 0:0.01:20;
plot(x,sin(x)), grid on








