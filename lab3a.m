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

MV = ZEROVMASSV(:,3)-ZEROVMASSV(:,1); %taking voltages from the displacement calculation for comparison
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

%% Cantilever Beam Vibration - Part 2

%clearing old variables and loading in data from lab book
load lab3.mat

%loading data and processing it into usefull arrays (only working with
%test 3)
nheaderlines=29; %data starts on line 30
% test1struct = importdata('Test1.lvm','\t',nheaderlines); %importing three waveforms, at least one should be good
% test2struct = importdata('Test2.lvm','\t',nheaderlines);
test3struct = importdata('Test3.lvm','\t',nheaderlines);
% test1 = test1struct.data; %pulling useful data out of the structured array
% test2 = test2struct.data;
test3 = test3struct.data;
% test1t = test1(:,1); %the time array for test 1 - units are presumed to be seconds
% test2t = test2(:,1); %the time array for test 2
test3traw = test3(:,1); %the time array for test 3
% test1V = test1(:,2); %the voltage array for test 1
% test2V = test2(:,2); %the voltage array for test 2
test3Vraw = test3(:,2); %the voltage array for test 3

%plotting the data together to see what looks best
% figure
% plot(test1t,test1V,test2t,test2V,test3traw,test3Vraw)
% title('Test Plot - Which Data Set is Best?')
% xlabel('Time (s)')
% ylabel('Voltage (V)')
% legend('Test 1','Test 2','Test 3')
%test 2 is the biggest, test 1 is the smallest, and test 3 in inbetween
%going with test 3 data for no particular reason....

%removing the part of the data before 0 seconds
test3t = test3traw(test3traw >=0);
test3V = test3Vraw(end-(length(test3t))+1:end);
%plotting to see how it looks (not normalized about zero yet)
% figure
% plot(test3t,test3V)
%looks good!

%normalizing the data about 0 V
meantest3V = mean(test3V);
test3Vn = test3V-meantest3V; %creating the normalized waveform which gives us deltaE
%plotting to check
% figure
% plot(test3t,test3Vn)
%looks good!

%converting the normalized waveform to strain
Gain = 100; %the gain is probably 100, larger gains make strain smaller
test3s = strain(test3Vn,Gain);

%plotting to check
% figure
% plot(test3t,test3s)
% grid on
%all values between .00000005 and .00000022
th = .00000005;
[pks,dep,pidx,didx] = peakdet(test3s,th);
peakLocations = test3t(pidx);
depLocations = test3t(didx);

%plotting the strain vs. time waveform with peaks and depressions
figure
plot(test3t,test3s,peakLocations,pks,'r.',depLocations,dep,'r.')
title('Strain vs. Time for Vibrating Beam')
xlabel('Time (s)')
ylabel('Strain')
legend('Data','Peaks')

%finding the damping ratio using method 1
DR1 = dRatio1(pks);

%Finding the damping ratio using method 2
DR2 = dRatio2(pks); %creates an array of damping ratios for the second method (put this in a table)
avgDR2 = mean(DR2); %finding the arithmetic mean of the damping ratios from method 2 (results in single DR number)
stdDR2 = std(DR2); %standard deviation of the DR values from method 2


%finding the damped natural frequency
Td = peakLocations(2)-peakLocations(1); %distance between the first and second peak
omegaD = (2*pi)./Td; %this is the damped natural frequency

%finding the undamped natural frequency
omegaN = omegaD./((1-(avgDR2.^2)).^.5); %using the damping ratio found by the second method (they are basically the same)


%calculating beam stiffness
E = 200000000000; %Pa
width = .503*.0254; %m
thickness = .052*.0254; %m
I = ((width*(thickness^3))/12);
stiffCalc = (3*E*I)/(((6.291-.382)*.0254)^3); %from the cantilever beam equation

%finding beam stiffness from data
Farray = (ZEROVMASSV(:,2)./1000*9.81); %getting force in newtons from the force test data
VFarray = (ZEROVMASSV(:,3)-ZEROVMASSV(:,1)); %getting deltaE from the force data
intarray = linspace(Farray(1),Farray(end),2000); %newtons
interpVF = interp1(Farray,VFarray,intarray);

Darray = (BEAMPRESS(:,1).*.0254); %getting displacement in meters from displacement test data
VDarray = (BEAMPRESS(:,2)-BEAMPRESS(1)); %getting the deltaE for displacement

POIarray = find(interpVF >= VDarray(6));
POIindex = POIarray(1); %position in the interpVF array where displacement is a known value
DPOI = Darray(6); %the displacement in meters at the point of interest
FPOI = intarray(POIindex); %the force in Netwons at the point of interest

stiffExp = FPOI/DPOI;

%finding beam volume
Vbeam = ((6.291-.382)*.0254)*width*thickness;
rhoSteel = 8050; %kg/m^3
MassofBeam = Vbeam*rhoSteel;

%% FFT - Part 3











