%   MSDFIT  fits theoretical curves to mean-squared deviation curves
%   extracted from tracking data.
%
%   [D_fit, n_fit, gammavec_fit, L] = msdfit(ndim, dt, dx, dy, dz);
%
%   See also msd3d, msdfit2
function fit = msdfit_zk_1_structure(dif);

lightcolor=[204,204,255;204,255,204;255,204,204;204,255,255;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;
darkcolor=[0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0];
lightcolor=[204,204,255;204,255,204;255,204,204;153,255,204;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;
wx=1./dif.stdDX.^2;
wy=1./dif.stdDY.^2;
wz=1./dif.stdDZ.^2;
wDX=wx.^0.5.*dif.DX;
wDY=wy.^0.5.*dif.DY;
wDZ=wz.^0.5.*dif.DZ;
dt=dif.DT;

%initial conditions
for j=1:1:3
    beta_i(j,1)=3.5;
    beta_i(j,2)=0.02;
    beta_i(j,3)=20*2*pi;
end
f2fitx=@(beta,t) wx.^0.5.*g_1(beta,t);
f2fity=@(beta,t) wy.^0.5.*g_1(beta,t);
f2fitz=@(beta,t) wz.^0.5.*g_1(beta,t);

%check=beta_i(4)^2-4*beta_i(3)*beta_i(4)
beta_estX = nlinfit(dt, wDX, f2fitx, beta_i(1,:));
beta_estY = nlinfit(dt, wDY, f2fity, beta_i(2,:));
beta_estZ = nlinfit(dt, wDZ, f2fitz, beta_i(3,:));

fit(1).D=beta_estX(1);fit(1).n=beta_estX(2);fit(1).gammaC=beta_estX(3);
%fit(1).L = sqrt(fit(1).D * (fit(1).gammaC+fit(1).gammaP) + fit(1).n^2.*fit(1).gammaC/2);

fit(2).D=beta_estY(1);fit(2).n=beta_estY(2);fit(2).gammaC=beta_estY(3);
%fit(2).L = sqrt(fit(2).D * (fit(2).gammaC+fit(2).gammaP) + fit(2).n^2.*fit(2).gammaC/2);

fit(3).D=beta_estZ(1);fit(3).n=beta_estZ(2);fit(3).gammaC=beta_estZ(3);
%fit(3).L = sqrt(fit(3).D * (fit(3).gammaC+fit(3).gammaP) + fit(1).n^2.*fit(3).gammaC/2);


figure; hold on;

% 
% semilogx(dt, dx, 'b', dt, g_xy(beta_x, dt), 'k');
% semilogx(dt, dx, 'b', dt, g_xy(beta_x, dt), 'k', dt, dy, 'g', dt, g_xy(beta_y, dt), 'k');
    shadedErrorBar_zk_simple(dif.DT,dif.DX,dif.stdDX,{'Color',darkcolor(1,:),'LineWidth',2});
    shadedErrorBar_zk_simple(dif.DT,dif.DY,dif.stdDY,{'Color',darkcolor(2,:),'LineWidth',2});
    shadedErrorBar_zk_simple(dif.DT,dif.DZ,dif.stdDZ,{'Color',darkcolor(3,:),'LineWidth',2});
plot(log10(dt),g_1(beta_estX, dt), '--b','LineWidth',2);
plot(log10(dt),g_1(beta_estY, dt), '--g','LineWidth',2);
plot(log10(dt),g_1(beta_estZ, dt), '--r','LineWidth',2);


%semilogx(dt, dx, 'b', dt, g_xy(beta_x, dt), 'b', dt, dy, 'g', dt, g_xy(beta_y, dt), 'g', dt, dz, 'r', dt, g_z(beta_z, dt), 'r');

%fit.L = find_L(fit.D, fit.n, gammavec_fit);



return;

function y = g_1(beta, t);
D = beta(1);
n = beta(2);
gamma_c = beta(3);

y = D - D/gamma_c*(1-n^2*gamma_c^2/(2*D))*(1-exp(-gamma_c*t))./t;

return;
