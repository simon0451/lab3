function [output] = dispStrain(deflection)
%this function calculates strain given displacement
deflection = deflection*.0254; %converting inches to meters
thickness = .052*.0254; %meters
length = (6.291-.382)*.0254; %meters
output = (3.*deflection.*thickness)/(2.*length.^2);

end