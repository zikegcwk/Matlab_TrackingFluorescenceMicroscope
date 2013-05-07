%function wmean takes x, which is a vector and then average it by a weight
%vector w. 
function avg_x=wmean(x,w)

if length(w)~=length(x)
    error('x and w must be the same length');
end

wx=x.*w;

avg_x=sum(wx)/sum(w);