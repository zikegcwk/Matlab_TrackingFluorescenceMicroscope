% DCOEFF2DFIT   Fits occupancy and concentration parameters to an input FCS
%               curve.  Fits to the 2-D FCS model.
%    [D, C] = DCOEFF2DFIT( TAU, G, Wxy ) returns the diffusion coefficent D 
%    (in um^2 / ms) and concentration (in units of occupancy ) fits to the 
%    input FCS curve G with corresponding correlation times T.  The input 
%    parameter Wxy is the laser beam waist in the transverse direction (in um). 
%
%    [D, C] = DCOEFF2DFIT( TAU, G, Wxy, Thresh ) returns the same fits, but
%    the parameter Thresh specifies an upper limit on the correlation 
%    times to include in the nonlinear fit.
%
%    [D, C] = DCOEFF2DFIT( TAU, G, Wxy, Thresh, Plot ) plots the real data
%    and the fit result if Plot == true.
function [D, C] = Dcoeff2Dfit( TAU, G, Wxy, Thresh, Plot ),

if nargin < 3 | nargin > 5,
    error( 'Between 3 and 5 input arguments are required.' );
end;

if nargin >= 4,
    fit_range = find( TAU < Thresh );
    TAU_fit = TAU(fit_range);
    G_fit = G(fit_range);
else
    TAU_fit = TAU;
    G_fit = G;
end;

% Choice of beta0 affects convergence of fit.  If the fit complains about
% ill-conditioning, adjust this parameter.
beta0 = [1 .1];

% Perform the fit
beta = nlinfit( TAU_fit, G_fit, ...
    inline( '1 / beta(1) * (1 + t / beta(2)).^-1', 'beta', 't' ),...
    beta0 );

% beta(2) as we have defined it is the diffusion time \tau_D, which is
% given by \tau_D = Wxy^2 / ( 4 D ).
D = Wxy^2 / (4 * beta(2)) * 1e-3;

% beta(1) is simply 1 / N, the inverse of the mean occupancy.
C = 1 / beta(1);

if nargin == 5,
    if( Plot ),
        Dcoeff2DPlotFit( TAU, G, Wxy, D, C );
    end;
end;

return;
