function [output] = strain(deltaE,Gain)
%this function will output a strain that corresponds to an input voltage
%change as recorded by the amplifier
deltaE = deltaE/1000; %Converting to volts

GF = 2; %guage factor - this is a product unique number and should be provided with part documentation
Ei = 5; %Wheatstone bridge input voltage, 5 V in the case of Lab 3

output = (deltaE*2)/(Ei*GF*Gain);

end