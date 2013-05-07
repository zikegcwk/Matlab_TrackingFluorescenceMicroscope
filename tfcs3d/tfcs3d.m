% TFCS3D  Three-dimensional tracking FCS curve
%   g = tfcs3d(tau, omegaxy, omegaz, r, w, a, z0, Gxy, Gz, nxy, nz, D) 
%   returns the three-dimensional tFCS curve as a function of tau 
%   according to the parameters
%   given: 
%       omegaxy and omegaz are the beam modulation frequencies
%       r and w are the beam rotation radius and waist
%       a and z0 are the axial "waist" and beam separation
%       Gxy and Gz are vectors of 1 or 2 coefficients describing the 
%           dynamics of the tracking system.  G(1) = gamma_c, G(2) =
%           gamma_p
%       nxy and nz are the tracking system noise densities
%       D is the diffusion coefficient
function g = tfcs3d(tau, omegaxy, omegaz, r, w, a, z0, Gammaxy, Gammaz, nxy, nz, D);

if length(Gammaxy) == 1,
    Axy = -Gammaxy;
    SigmaInfEU = D/Gammaxy;
    SigmaInfEN = nxy^2/(2*Gammaxy);
    CxyEU = 1;
    CxyEN = Gammaxy;
else
    if length(Gammaxy) > 2,
        error('Sorry, I can accept up to a second-order system only');
    end;
    Axy = [-Gammaxy(2), -Gammaxy(2); Gammaxy(1), 0];
    SigmaInfEU = diag([D / Gammaxy(2), D * Gammaxy(1)/Gammaxy(2)^2]);
    SigmaInfEN = diag([nxy^2/(2*Gammaxy(2)), nxy^2*Gammaxy(1)/(2*Gammaxy(2)^2)]);
    CxyEU = [1 Gammaxy(2)/Gammaxy(1)];
    CxyEN = [0 Gammaxy(2)];
end;

if length(Gammaz) == 1,
    Az = -Gammaz;
    SInfEU = D/Gammaz;
    SInfEN = nz^2/(2*Gammaz);
    CzEU = 1;
    CzEN = Gammaz;
else
    if length(Gammaz) > 2,
        error('Sorry, I can accept up to a second-order system only');
    end;
    Az = [-Gammaz(2), -Gammaz(2); Gammaz(1), 0];
    SInfEU = diag([D / Gammaz(2), D * Gammaz(1)/Gammaz(2)^2]);
    SInfEZ = diag([nz^2/(2*Gammaz(2)), nz^2*Gammaz(1)/(2*Gammaz(2)^2)]);
    CzEU = [1 Gammaz(2)/Gammaz(1)];
    CzEN = [0 Gammaz(2)];
end;


sigma0 = sqrt(CxyEU*SigmaInfEU*CxyEU' + CxyEN*SigmaInfEN*CxyEN');
barsigma = sqrt(sigma0^2 + w^2/4);

s0 = sqrt(CzEU*SInfEU*CzEU' + CzEN*SInfEN*CzEN');
bars = sqrt(s0^2 + a^2/4);

g = zeros(size(tau));

for tt = 1:length(tau),
    t = tau(tt);
    
    sigmat = sqrt(CxyEU*expm(Axy*t)*SigmaInfEU*CxyEU' + CxyEN*expm(Axy*t)*SigmaInfEN*CxyEN');
    st = sqrt(CzEU*expm(Az*t)*SInfEU*CzEU' + CzEN*expm(Az*t)*SInfEN*CzEN');
    
    g(tt) = (barsigma^4*bars^2)/(2*(barsigma^4 - sigmat^4)*sqrt(bars^4 - st^4))...
        * exp(-r^2*((barsigma^2 - sigmat^2 * cos(omegaxy*t))/(barsigma^4-sigmat^4))...
                + r^2/barsigma^2 + z0^2/bars^2)...
        * ((1 + 1/2*cos(omegaz*t))*exp(-z0^2/(bars^2 + st^2)) ...
            + (1 - 1/2*cos(omegaz*t))*exp(-z0^2/(bars^2 - st^2))) - 1;
end;