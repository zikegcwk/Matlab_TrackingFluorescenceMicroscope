
function y = msd2theory(beta, t);

D = beta(1);
n = beta(2);
gamma_c = beta(3);
gamma_p = beta(4);

nu = sqrt(gamma_p^2 - 4*gamma_c*gamma_p);
if nu<0
    error('nv is negative. See code.');
end

a=nu-gamma_p;
b=nu+gamma_p;

y1=D-D./t.*(1/nu).*(exp(a*t/2)-exp(-b*t/2))-(D./t).*(1/gamma_p - 1/gamma_c + n^2*gamma_c/(2*D)).* (0.5*exp(a*t/2)+0.5*exp(-b*t/2)+gamma_p*(1/nu)*0.5*(exp(a*t/2)-exp(-b*t/2))-1);
y2=D - D./t .* (2./nu*sinh(nu*t/2).*exp(-gamma_p*t/2) + (1/gamma_p - 1/gamma_c + n^2*gamma_c/(2*D)) .*(-1 + exp(-gamma_p*t/2).*(cosh(nu*t/2) + gamma_p/nu*sinh(nu*t/2))));
% y1=(D./t).*(1/gamma_p - 1/gamma_c + n^2*gamma_c/(2*D)).* (0.5*exp(a*t/2)+0.5*exp(-b*t/2)+gamma_p*(1/nu)*0.5*(exp(a*t/2)-exp(-b*t/2))-1);
% y2=- D./t .* ( (1/gamma_p - 1/gamma_c + n^2*gamma_c/(2*D)) .*(-1 + exp(-gamma_p*t/2).*(cosh(nu*t/2) + gamma_p/nu*sinh(nu*t/2))));


figure(999);

hold on;
semilogx(t,y1,'b');
semilogx(t,y2,'r');
set(gca,'XScale','log')
return;
