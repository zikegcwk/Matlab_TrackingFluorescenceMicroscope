% DCOEFF2DPLOTFIT   Plots FCS curve and diffusion coefficient fit.
%    DCOEFF2DPLOTFIT( TAU, G, Wxy, D, C ) plots the FCS curve (TAU, G)
%    along with the 3D fit to diffusion coefficent D and concentration C
%    generated using DCOEFF2DFIT.  Wxy is the transverse beam waist.
function Dcoeff2DPlotFit( TAU, G, Wxy, D, C ),

if nargin ~= 5,
    error( '5 input arguments required.\n' );
end;

beta( 1 ) = 1 / C;
beta( 2 ) = Wxy^2 / ( 4e3 * D );

FCSmodel = inline( '1 / beta(1) * (1 + t / beta(2)).^-1', 'beta', 't' );
figure;
semilogx( TAU, G, TAU, FCSmodel( beta, TAU ), 'r' );
xlabel( '\tau' );
ylabel( 'G' );
legend( 'Measured', 'Fit');

return;