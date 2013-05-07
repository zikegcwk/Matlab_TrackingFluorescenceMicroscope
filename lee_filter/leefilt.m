% LEEFILT  Smooths fluorescence data using a Lee filter.
%    tilde_sig = leefilt(signal, m, sigma0) returns the 
%    output of the Lee filter of window 2*m+1 data bins and 
%    smoothing parameter sigma0 for input signal.
function tilde_sig = leefilt(signal, m, sigma0);

if nargin ~= 3,
    error('Exactly three input parameters are required.');
end;

if nargout > 1,
    error('Only one output argument is available.');
end;

if min(size(signal)) ~= 1,
    error('Input signal must be a vector.');
end;


if m ~= round(m) | max(size(m)) ~= 1,
    error('m must be an integer.');
end;

if max(size(sigma0)) ~= 1,
    error('sigma0 must be a scalar.');
end;

if m <= 0,
    tilde_sig = signal;
    return;
end;

% The Lee filter implemented in MATLAB script takes about 6000 times
% as long to run as it does implemented in C, so...

tilde_sig = fast_lee_filter(signal, m, sigma0);

return;