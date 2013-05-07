function b=calib_modulation(D,n,gammas,omega,dt, varargin)
%varargin contains dx, dy, dz
ndim=length(varargin);
if ndim==0
    error('No data to fit');
    return
end

figure(302);
colororder='bgr';

ndimfit=size(gammas,2);
b=zeros(ndim,1);
b0=1;
for i=1:ndim
    if ndimfit==1
        gammac=gammas(i);
        fit4modulation=@(x,deltaT) x^2./(2*deltaT).*(gammac^2/(omega^2+gammac^2)*(1-cos(omega*deltaT)));
        beta=[D(i),n(i),gammas(i,1)];
        data2fit=varargin{i}-g_1(beta,dt);
        fit4msd=@(x,deltaT) fit4modulation(x,deltaT)+g_1(beta,deltaT);
    else 
        gammac=gammas(i,1);
        gammap=gammas(i,2);
        fit4modulation=@(x,deltaT) x^2./(2*deltaT).*((gammap*gammac)^2/((omega^2-gammap*gammac)^2+(gammap*omega)^2)*(1-cos(omega*deltaT)));
        beta=[D(i),n(i),gammas(i,1),gammas(i,2)];
        data2fit=varargin{i}-g_2(beta,dt);
        fit4msd=@(x,deltaT) fit4modulation(x,deltaT)+g_1(beta,deltaT);
    end
b(i)=nlinfit(dt,data2fit,fit4modulation,b0);
semilogx(dt,varargin{i},colororder(i),dt,fit4msd(b(i),dt),'k');
hold all;
end


end

function y = g_1(beta, t);
D = beta(1);
n = beta(2);
gamma_c = beta(3);

y = D - D/gamma_c*(1-n^2*gamma_c^2/(2*D))*(1-exp(-gamma_c*t))./t;

%g = inline('beta(1) + beta(1)./(beta(3)*t)*(1-beta(2)^2*beta(3)^2/(2*beta(1))).*(exp(-beta(3)*t)-1)', 'beta', 't'); % 1st order fitting function

end

function y = g_2(beta, t);

D = beta(1);
n = beta(2);
gamma_c = beta(3);
gamma_p = beta(4);

nu = sqrt(gamma_p^2 - 4*gamma_c*gamma_p);
% the following is wrong:
%y = D - D ./ t * exp(-gamma_p * t / 2).*(2/nu*sinh(nu*t/2)...
%    + (1/gamma_p - 1/gamma_c + (n^2*gamma_c)/(2*D))*(-exp(gamma_p*t/2) + cosh(nu*t/2) + gamma_p/nu*sinh(nu*t/2)))./t;

 y = D - D./t .* (2./nu*sinh(nu*t/2).*exp(-gamma_p*t/2) + (1/gamma_p - 1/gamma_c + n^2*gamma_c/(2*D)) .* ...
          (-1 + exp(-gamma_p*t/2).*(cosh(nu*t/2) + gamma_p/nu*sinh(nu*t/2))));
end