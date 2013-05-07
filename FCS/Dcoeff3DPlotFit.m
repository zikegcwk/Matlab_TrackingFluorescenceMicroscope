% DCOEFF3DPLOTFIT   Plots FCS curve and diffusion coefficient fit.
%    DCOEFF3DPLOTFIT( TAU, G, Wxy, Omega, D, C ) plots the FCS curve (TAU,
%    G) along with the 3D fit to diffusion coefficent D and concentration C
%    generated using DCOEFF3DFIT.  Wxy is the transverse beam waist, and
%    Omega is the ratio between axial and transverse beam waists.
function Dcoeff3DPlotFit( TAU, G, Wxy, Omega, D, C ),

if nargin ~= 6,
    error( '6 input arguments required.' );
end;

beta( 1 ) = 1 / C;
beta( 2 ) = Wxy^2 / ( 4e3 * D );

FCSmodel = inline( '[ t(1), 1 / beta(1) * (1 + t(2:end) / beta(2)).^-1 .* (1 + t(2:end) / (t(1)^2 * beta(2))) .^-0.5 ]', 'beta', 't' );

figure;
TAU_aug = [ Omega, TAU ];
fit_result = FCSmodel( beta, TAU_aug );
semilogx( TAU, G, TAU, fit_result(2:end), 'r' );
xlabel( '\tau' );
ylabel( 'G' );
legend( 'Measured', 'Fit');

return;