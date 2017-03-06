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

m = num2str(REbestfitmb(1),3);
b = num2str(REbestfitmb(2),3);
txt = strcat('V =',m,' (V/\Omega) R+ ',b,' (V)');
txt2 = 'Sample Variance deg. of Freedom: 4';
txt3 = 'Student''s t Variable at 95% conf.: 2.770';

%Plotting the deltaR vs. deltaE and respective confidence intervals
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
grid on

% Part 1.d
Gain = 100;
Marray = ZEROVMASSV(:,2);
Varray = ZEROVMASSV(:,3);

MV = ZEROVMASSV(:,3); %taking voltages from the displacement calculation for comparison
VstrainM = abs(strain(MV,Gain)); %strain as calculated from the strain gauge (taking absolute value)


DP =  BEAMPRESS(:,1); %inches
DVP = BEAMPRESS(:,2); %voltages for pressing on the beam (mV)
VstrainDP = abs(strain(DVP,Gain)); %strain as calculated from the strain gauge (taking absolute value)
DPstrain = dispStrain(DP);

DR = BEAMRELEASE(:,1); %inches
DVR = BEAMRELEASE(:,2); %inches

VstrainDR = abs(strain(DVR,Gain));
DRstrain = dispStrain(DR);

Mstrain = massStrain(Marray);
MVstrain = strain(Varray,Gain);

%Best fit line for part 1.d.iii
BEAM = (BEAMPRESS+flipud(BEAMRELEASE))/2;
BEAMx = BEAM(:,1);
BEAMy = BEAM(:,2);
BEAMystrain = strain(BEAMy,Gain);
BEAMfitV = leastSquares(BEAMx,BEAMy);
BEAMfitVolts = BEAMfitV(:,2);
BEAMfit = strain(BEAMfitVolts,Gain);
% beamm = BEAMfitmb(1);
% beamb = BEAMfitmb(2);
conInts2 = confInt2(BEAMx,BEAMystrain);
cifp2 = conInts2(:,1);
cifn2 = conInts2(:,2);
cimp2 = conInts2(:,3);
cimn2 = conInts2(:,4);
cix2 = linspace(BEAMx(1),BEAMx(end));

%Hysteresis
BPstrain = strain(BEAMPRESS(:,2),Gain);
BRstrain = strain(BEAMRELEASE(:,2),Gain);
BeamDiff = BPstrain-BRstrain;

figure
plot(DP,DPstrain,'r:',DP,VstrainDP,'o',DR,VstrainDR,'*')
title('Strain Measured from Displacement vs. Prediction')
xlabel('Displacement (in)')
ylabel('Strain')
legend('Prediction','Data - Press','Data - Release','locaton','northwest')
grid on

figure
plot(Marray,Mstrain,'r:',Marray,MVstrain,'o')
title('Strain Measured from Mass vs. Prediction')
xlabel('Added Mass (g)')
ylabel('Strain')
legend('Prediction','Data')
grid on

txt4 = 'Sample Variance deg. of Freedom: 21';
txt5 = 'Student''s t Variable at 95% conf.: 2.080';
figure
plot(DP,VstrainDP,'o',DR,VstrainDR,'*',BEAMx,BEAMfit,':',cix2,cifp2,'b--',cix2,cimp2,'r--',cix2,cifn2,'b--',cix2,cimn2,'r--')
title('Best Fit and 95% Conf. Interval for Displacement')
xlabel('Displacement (inches)')
ylabel('Strain')
legend('Data (Press)','Data (Release)','Linear Least Squares Fit','95% Conf. Interval of Fit','95% Conf. Interval of Meas.','location','northwest')
grid on
xmin = 0;
xmax = .25;
ymin = .0001;
ymax = .0007;
axis ([xmin xmax ymin ymax])
text(.35*xmax,.25*ymax,txt4)
text(.35*xmax,.2*ymax,txt5)










