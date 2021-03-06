function [deflection] = deflection(mass)
%finds deflection given mass
mass = mass./1000; %converting to kg from g

g = 9.81; %m/s^s
E = 200000000000; %Pa, 200 GPa
length = (6.291-.382)*.0254; %m
width = .503*.0254; %m
thickness = .052*.0254; %m
deflection = (12.*mass.*g.*(length.^3))./(3.*E.*width.*thickness.^3);
% I = (width*thickness^3);
% deflection = 3*E*I/(length^3);
end