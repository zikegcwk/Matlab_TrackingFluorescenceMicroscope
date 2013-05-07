function [sigmaxy, sigmaz, gam, Rg, wxy, wz, L, b, Delta] = get_fit_params,
sigmaxy = 0.35; % 110nm rms tracking error (about the same on all three axes)
sigmaz = 0.35; % 
gam = 2*2*pi; % 15Hz tracking bandwidth

wxy = 0.22; % 200nm beam waist
lambda = 0.444; % 444nm laser wavelength
zeta = lambda/(sqrt(2)*pi*wxy); 
wz = wxy/zeta; % z axis beam width

L = 17; % 17um polymer contour length
b = 0.17; %gives the correct average radius of gyration (~700nm) for DNA polymer of length L,
% found from <Rg^2> = Lb/6
labelDensity = 1/3000; % in dyes / bp
numDyes = round(48000 * labelDensity);
Delta = L / numDyes; % Dye spacing

l = 0:(numDyes-1);
Rg = sqrt(L*b/3 * ((l*Delta/L - 1/2).^2 + 1/12)); % divide by sqrt(3) to get Rg along single axis.
return;