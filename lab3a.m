%% Header
%Simon Popecki
%3. March 2017
%ME 646

%lab3.mat information
%BEAMPRESS: the deflection of the beam from 0 inches to .250 inches
%[deflection (inches) , voltage output (mV)]

%BEAMRELEASE: the return of the beam from .250 inches to 0 inches
%[deflection (inches) , voltage output (mV)]

%DEDR: the comparison between shunt resistor change in resistance and the
%corresponding change in voltage [voltage (mV) , resistance (kOhm)]

%ZEROVMASSLOADV: the zero voltage, mass applied to the beam, and the
%voltage outputted by the strain gauage [mV,g,mV]

%BUCKETWEIGHT: the mass of the bucket used to weigh samples in
%ZEROVMASSLOADV, grams

%% Beam/Strain Gauge Response
clear all;
close all;
load lab3.mat
%DEDR - (:,1) is the delta e value (change in output voltage IN MILLIVOLTS) and (:,2) is
%the change in resistance for the given shunt resistor(K OHMS)

%The resistance is the independent variable
deltaE = DEDR(:,1);
deltaR = DEDR(:,2);
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

plot(deltaR,deltaE,'o',REbfx,REbfy,cix,cifp,'b--',cix,cifn,'b--',cix,cimp,'g--',cix,cimn,'g--')
title('what in std. deviation?')
ylabel('Output Voltage (mV, gain not accounted for)')
xlabel('Resistance (k\Omega)')


