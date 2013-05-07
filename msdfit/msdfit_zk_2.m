%   MSDFIT  fits theoretical curves to mean-squared deviation curves
%   extracted from tracking data.
%
%   [D_fit, n_fit, gammavec_fit, L] = msdfit(ndim, dt, dx, dy, dz);
%
%   See also msd3d, msdfit2
function fit = msdfit_zk_2(dt,dx,dy,dz,beta_i);



if nargin==4
    for j=1:1:3
        beta_i(j,1)=3.5;
        beta_i(j,2)=0.2;
        beta_i(j,3)=40;
        beta_i(j,4)=200*2*pi;
    end
% check=gamma_p0^2-4*gamma_p0*gamma_c0
% beta_i = [D0, n0, gamma_c0, gamma_p0];
end
g_z=@g_2;
%check=beta_i(4)^2-4*beta_i(3)*beta_i(4)
beta_estX = nlinfit(dt, dx, @g_2, beta_i(1,:));
beta_estY = nlinfit(dt, dy, @g_2, beta_i(2,:));
beta_estZ = nlinfit(dt, dz, @g_2, beta_i(3,:));

fit.Dx=beta_estX(1);fit.nx=beta_estX(2);fit.gammaCx=beta_estX(3);fit.gammaPx=beta_estX(4);
fit.Lx = sqrt(fit.Dx * (fit.gammaCx+fit.gammaPx) + fit.nx^2.*fit.gammaCx/2);

fit.Dy=beta_estY(1);fit.ny=beta_estY(2);fit.gammaCy=beta_estY(3);fit.gammaPy=beta_estY(4);
fit.Ly = sqrt(fit.Dy * (fit.gammaCy+fit.gammaPy) + fit.ny^2.*fit.gammaCy/2);

fit.Dz=beta_estZ(1);fit.nz=beta_estZ(2);fit.gammaCz=beta_estZ(3);fit.gammaPz=beta_estZ(4);
fit.Lz = sqrt(fit.Dz * (fit.gammaCz+fit.gammaPz) + fit.nz^2.*fit.gammaCz/2);


figure(11);clf; 
% 
% semilogx(dt, dx, 'b', dt, g_xy(beta_x, dt), 'k');
% semilogx(dt, dx, 'b', dt, g_xy(beta_x, dt), 'k', dt, dy, 'g', dt, g_xy(beta_y, dt), 'k');
semilogx(dt, dx, 'b', dt, g_z(beta_estX, dt), '--b','LineWidth',2);
hold on;
semilogx(dt, dy, 'g', dt, g_z(beta_estY, dt), '--g','LineWidth',2);
semilogx(dt, dz, 'r', dt, g_z(beta_estZ, dt), '--r','LineWidth',2);

%semilogx(dt, dx, 'b', dt, g_xy(beta_x, dt), 'b', dt, dy, 'g', dt, g_xy(beta_y, dt), 'g', dt, dz, 'r', dt, g_z(beta_z, dt), 'r');

%fit.L = find_L(fit.D, fit.n, gammavec_fit);



return;

function y = g_1(beta, t);
D = beta(1);
n = beta(2);
gamma_c = beta(3);

y = D - D/gamma_c*(1-n^2*gamma_c^2/(2*D))*(1-exp(-gamma_c*t))./t;

return;

function y = g_2(beta, t);

D = beta(1);
n = beta(2);
gamma_c = beta(3);
gamma_p = beta(4);

nu = sqrt(gamma_p^2 - 4*gamma_c*gamma_p);

a=nu-gamma_p;
b=nu+gamma_p;

y=D-D./t.*(1/nu).*(exp(a*t/2)-exp(-b*t/2))-(D./t).*(1/gamma_p - 1/gamma_c + n^2*gamma_c/(2*D)).* (0.5*exp(a*t/2)+0.5*exp(-b*t/2)+gamma_p*(1/nu)*0.5*(exp(a*t/2)-exp(-b*t/2))-1);
%  y = D - D./t .* (2./nu*sinh(nu*t/2).*exp(-gamma_p*t/2) + (1/gamma_p - 1/gamma_c + n^2*gamma_c/(2*D)) .* ...
%           (-1 + exp(-gamma_p*t/2).*(cosh(nu*t/2) + gamma_p/nu*sinh(nu*t/2))));
return;
