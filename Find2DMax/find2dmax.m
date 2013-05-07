function [a,b,m] = find2dmax(M),

[m,a] = max(max(M'));
[m,b] = max(max(M));

return;

