% [D_fit, n_fit, gammavec_fit, yfit, L] = msdfit2(dt, dx, D0, n0, gc0, gp0)
function [D_fit, n_fit, gammavec_fit, yfit, L] = msdfit2(dt, dx, D0, n0, gc0, gp0);

beta0 = [D0, n0, gc0, gp0];

beta = nlinfit(dt, dx, @f2, beta0);

D_fit = beta(1);
n_fit = beta(2);
gammavec_fit = [beta(3), beta(4)];
yfit = f2(beta, dt);
L = sqrt(D_fit*(1/beta(3) + 1/beta(4)) + n_fit^2*beta(3)/2);

return;

function y = f2(beta, t);
D = beta(1);
n = beta(2);
gamma_c = beta(3);
gamma_p = beta(4);

nu = sqrt(gamma_p^2-4*gamma_c*gamma_p);

y = D - D./t .* (2./nu*sinh(nu*t/2).*exp(-gamma_p*t/2) + (1/gamma_p - 1/gamma_c + n^2*gamma_c/(2*D)) .* ...
          (-1 + exp(-gamma_p*t/2).*(cosh(nu*t/2) + gamma_p/nu*sinh(nu*t/2))));
      
return;