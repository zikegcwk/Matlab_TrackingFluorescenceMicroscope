function y = g_tizzle(beta, t);

D = beta(1);
n = beta(2);
gamma_c = beta(3);
gamma_p = beta(4);

nu = sqrt(gamma_p^2 - 4*gamma_c*gamma_p);
%y = D + D * gamma_c^2 * exp(-gamma_p*t/2) .* (2/nu .* sinh(nu * t/2)*(1/gamma_p - 1/gamma_c) ...
%    + (1/gamma_p^2 - gamma_c*n^2/(2*D*gamma_p))*(cosh(nu*t/2) + gamma_p /
%    nu * sinh(nu*t/2) - exp(gamma_p*t/2)))./t;

y = D - D * gamma_c^2/gamma_p^2 * exp(-gamma_p * t / 2).*(2/nu*sinh(nu*t/2)...
    + (1/gamma_p - 1/gamma_c + (n^2*gamma_c)/(2*D))*(-exp(gamma_p*t/2) + cosh(nu*t/2) + gamma_p/nu*sinh(nu*t/2)))./t;

return;