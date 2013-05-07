%NHIST  Normalized histogram
%   [A, X] = NHIST( data, NUM_BINS ) returns the histogram
%   corresponding to the MATLAB function call
%   [A, X] = HIST(DATA, NUM_BINS )
%   where A has been normalized so that 
%   sum(A) * dx == 1.
function [a, x] = nhist( data, num_bins );

if nargin == 0,
    error( 'Come on, at least give me some data.' );
end;

if nargin == 1,
    num_bins = 1;
end;

if numel( num_bins ) ~= 1,
    error( 'NHIST does not support vector bin centers (yet?).' );
end;

[a, x] = hist( data, num_bins );

a = a / (sum(a) * (x(2) - x(1)));

return;