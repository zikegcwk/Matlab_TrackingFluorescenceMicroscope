% function g = polymer_tfcs(wxy, tau1, a, tau);
% Several fixed parameters located inside this function!
% See also polymer_tfcs
function g = polymer_endlabel_tfcs(tau1, a, tau);

sigmaxy = 0.1;
sigmaz = 0.2;

wxy = 0.22;
wz = 0.75;

L = 17;
b = 0.084; % Based on our measurement D = 0.67 um^2/s => Rg = 0.488
%b = 0.17; % Based on numbers quoted in Lumma et al, Rg = 0.73
y = 0;

gamxy = 15*2*pi;
gamz = 6*2*pi;

g = exact_blas(sigmaxy, sigmaz, gamxy, gamz, wxy, wz, L, b, tau1, a, y, tau);

return;