function [output] = massStrain(M)
%this function determines strain in a steel bar given mass added to a
%bucket
M = M/1000; %converting from grams to kilograms
thickness = .052*.0254; %meters
width = .503*.0254; %meters
length = (6.291-.382)*.0254; %meters
E = 200000000000; %young's modulas for steel, Pa
g = 9.81; %m/s^2
BUCKETMASS =.0119; %kg
HOOKMASS = .0074; %kg
M = M+BUCKETMASS+HOOKMASS; %accounting for the additional mass from the hook and the bucket

I = (width*(thickness^3))/12;
output = (M.*g.*length).*(thickness./2)/(E.*I);

end
