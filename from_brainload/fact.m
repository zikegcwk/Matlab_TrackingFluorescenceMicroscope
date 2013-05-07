function F = fact(N)
%FACT vector factorial function
%  FACT(N) is the vector containing the factorials of the components of N
%
%  See also FACTORIAL.

for k = 1:length(N)
    F(k) = factorial(N(k));
end;

return;