% y = msd2(t, D, n, gammac, gammap)
function y = msd2(t, D, n, gamma_c, gamma_p);

nu = sqrt(gamma_p^2-4*gamma_c*gamma_p);

y = D - D./t .* (2./nu*sinh(nu*t/2).*exp(-gamma_p*t/2) + (1/gamma_p - 1/gamma_c + n^2*gamma_c/(2*D)) .* ...
          (-1 + exp(-gamma_p*t/2).*(cosh(nu*t/2) + gamma_p/nu*sinh(nu*t/2))));
   
return;