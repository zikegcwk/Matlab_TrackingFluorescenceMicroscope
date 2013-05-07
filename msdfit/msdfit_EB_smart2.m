%   MSDFIT  fits theoretical curves to mean-squared deviation curves
%   extracted from tracking data.
%
%   [D_fit, n_fit, gammavec_fit, L] = msdfit(ndim, dt, dx, dy, dz);
%
%   See also msd3d, msdfit2
function [D_fit, D_noise, gammavec_fit, L, noiseDensity, h] = msdfit_EB_smart2(dt, dx, dy, dz,eb,plotTag)

if isempty(eb)
    eb=length(dt)*ones(1,length(dt));
end

eb=eb/sum(eb);

g_1=@(beta,t) eb.*g_1_0(beta,t);
g_2=@(beta,t) eb.*g_2_0(beta,t);

D0 = 5;
n0_xy = 0.001;

% gamma_c0_xy=20*2*pi;
% gamma_p0_xy =20*2*pi;

gamma_c0_x=480;
gamma_c0_x=280;
gamma_c0_z=242;
gamma_p0_xy =100;
gamma_p0_z=100;

n0_z = 0.001;

% gamma_c0_z = 20*2*pi;
% gamma_p0_z = 20*2*pi;

% gamma_c0_z=200;
% gamma_p0_z =100;

%         beta_xy1 = [D0, n0_xy, gamma_c0_xy];
%         beta_z1 = [D0, n0_z, gamma_c0_z];
%       
%  
%             beta_xy2 = [D0, n0_xy, gamma_c0_xy, gamma_p0_xy];
%             beta_z2 = [D0, n0_z, gamma_c0_z, gamma_p0_z];
    
    
    
D_fit = -1*ones(3, 1);
n_fit = -1*ones(3, 1);
nd=zeros(3,1);
L=-1*ones(3,1);
gammavec_fit = -1*ones(3, 2);
gammavec_fit(:,2)=inf;
noiseDensity=D_fit;

try
beta_x = nlinfit(dt, eb.*dx, g_2, beta_xy2);
D_fit(1) = beta_x(1);
n_fit(1) = beta_x(2);
gammavec_fit(1,1)=beta_x(3);
gammavec_fit(1,2)=beta_x(4);
nd(1)=2;
catch EM1
    try
    beta_x = nlinfit(dt, eb.*dx, g_1, beta_xy1);
    D_fit(1) = beta_x(1);
    n_fit(1) = beta_x(2);
gammavec_fit(1,1)=beta_x(3);
nd(1)=1;

    catch EM2
    end
end

try
beta_y = nlinfit(dt, eb.*dy, g_2, beta_xy2);
D_fit(2) = beta_y(1);
n_fit(2) = beta_y(2);
gammavec_fit(2,1)=beta_y(3);
gammavec_fit(2,2)=beta_y(4);
nd(2)=2;
catch EM1
    try
    beta_y = nlinfit(dt, eb.*dy, g_1, beta_xy1);
    D_fit(2) = beta_y(1);
    n_fit(2) = beta_y(2);
gammavec_fit(2,1)=beta_y(3);
nd(2)=1;

    catch EM2
    end
end


try
beta_z = nlinfit(dt, eb.*dz, g_2, beta_z2);
D_fit(3) = beta_z(1);
n_fit(3) = beta_z(2);
gammavec_fit(3,1)=beta_z(3);
gammavec_fit(3,2)=beta_z(4);
nd(3)=2;
catch EM1
    try
    beta_z = nlinfit(dt, eb.*dz, g_1, beta_z1);
    D_fit(3) = beta_z(1);
    n_fit(3) = beta_z(2);
gammavec_fit(3,1)=beta_z(3);
nd(3)=1;

    catch EM2
    end
end


L = sqrt(D_fit .*(sum(1./gammavec_fit, 2)+1./gammavec_fit(:,1).*n_fit));
D_noise=n_fit.*D_fit;
noiseDensity=sqrt(2*n_fit)./gammavec_fit(:,1);


h=[];
if(plotTag)
h=figure();
%title(sprintf('trace %g',fignum));
switch nd(1)
    case 0
        semilogx(dt, dx, 'b'); hold on;
    case 1
        semilogx(dt, dx, 'b', dt, g_1_0(beta_x, dt), 'k');  hold on;
    case 2
        semilogx(dt, dx, 'b', dt, g_2_0(beta_x, dt), 'k');  hold on;
end
switch nd(2)
    case 0
        semilogx(dt, dy, 'g'); hold on;
    case 1
        semilogx(dt, dy, 'g', dt, g_1_0(beta_y, dt), 'k'); hold on;
    case 2
        semilogx(dt, dy, 'g', dt, g_2_0(beta_y, dt), 'k'); hold on;
end
switch nd(3)
    case 0
        semilogx(dt, dz, 'r');
    case 1
        semilogx(dt, dz, 'r', dt, g_1_0(beta_z, dt), 'k');
    case 2
        semilogx(dt, dz, 'r', dt, g_2_0(beta_z, dt), 'k');
end
end


end

function y = g_1_0(beta, t)
D = beta(1);
% n = beta(2);
gamma_c = beta(3);

DnoiseoverD = beta(2);

% y = D - D/gamma_c*(1-n^2*gamma_c^2/(2*D))*(1-exp(-gamma_c*t))./t;
y = D - D/gamma_c*(1-DnoiseoverD)*(1-exp(-gamma_c*t))./t;
end

function y = g_2_0(beta, t)

D = beta(1);
% n = beta(2);
DnoiseoverD = beta(2);

gamma_c = beta(3);
gamma_p = beta(4);

nu = sqrt(gamma_p^2 - 4*gamma_c*gamma_p);

%  y = D - D./t .* (2./nu*sinh(nu*t/2).*exp(-gamma_p*t/2) + (1/gamma_p - 1/gamma_c + n^2*gamma_c/(2*D)) .* ...
%           (-1 + exp(-gamma_p*t/2).*(cosh(nu*t/2) + gamma_p/nu*sinh(nu*t/2))));
      
       y = D - D./t .* (2./nu*sinh(nu*t/2).*exp(-gamma_p*t/2) + 1/gamma_c(gamma_c/gamma_p - 1 + DnoiseoverD) .* ...
          (-1 + exp(-gamma_p*t/2).*(cosh(nu*t/2) + gamma_p/nu*sinh(nu*t/2))));
      
y=eb.*y;
end


