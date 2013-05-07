% g = mycorrelator_CR(t,delta)
%   Determines for a given photon time tag if the next photon occurred
%   within a time delta.  Useful for determining the short time
%   correlations.
%
function tau = mycorrelator_CR(t,delta)
s = length(t);
j = 0;
for i=1:s-1
    if t(i+1)-t(i)<=delta
        j=j+1;
        tau(j) = i;       
    end
end
   