function fscale(fig,taumin)

if nargin ==1;
    taumin=-5;
end

squ=[taumin,0,0,1]

h=figure(fig);
axis(squ)
axis autoy
