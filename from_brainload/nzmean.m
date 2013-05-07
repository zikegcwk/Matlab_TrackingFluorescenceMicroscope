function m = nzmean(x,d)
%NZMEAN   Nonzero average or mean value
%   M = NZMEAN(X, DIM) returns the function MEAN(X, DIM) taken for
%   nonzero values in X only.

S = sum(x, d);
N = sum(x ~= 0, d);

m = S ./ N;
return;