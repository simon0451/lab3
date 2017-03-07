function [dampingRatio] = dRatio2(pks)
%where pks is an array of the magnitudes of the peaks i.e. the Ys

Y = pks; %renaming pks to Y, not strictly necessary
Y1 = Y(1);

dampingRatiof = zeros(1,length(Y)); %preallocating the array
for n = 2:1:length(Y)
    dampingRatiof(n) = ((1./(n-1)).*log(Y1./Y(n)))./((4.*pi.^2)+((1./(n-1)).*log(Y1./Y(n))).^2).^.5;
end

dampingRatio = dampingRatiof';

end