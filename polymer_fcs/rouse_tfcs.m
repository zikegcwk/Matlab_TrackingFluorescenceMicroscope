function g = rouse_tfcs(wxy, tau1, tau);

a = 2;

sigmaxy = 0.0;
sigmaz = 0.0;

lambda = 0.444;
zeta = lambda/(sqrt(2)*pi*wxy); 
wz = wxy/zeta;

L = 17;
b = 0.084; % Based on our measurement D = 0.67 um^2/s => Rg = 0.488
%b = 0.17; % Based on numbers quoted in Lumma et al, Rg = 0.73
N = 5;
Delta = 1 / (N-1);
%y = 0:Delta:1;
y = 0;
gamxy = 15*2*pi;
gamz = 6*2*pi;

g = exact_blas(sigmaxy, sigmaz, gamxy, gamz, wxy, wz, L, b, tau1, a, y, tau);

return;