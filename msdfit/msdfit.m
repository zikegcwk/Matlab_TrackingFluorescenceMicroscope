%   MSDFIT  fits theoretical curves to mean-squared deviation curves
%   extracted from tracking data.
%
%   [D_fit, n_fit, gammavec_fit, L] = msdfit(ndim, dt, dx, dy, dz);
%
%   See also msd3d, msdfit2
function [D_fit, n_fit, gammavec_fit, L] = msdfit(ndim, dt, dx, dy, dz);
if nargin < 3,
    error('You must give me some data to work with');
end;

num_in = min([nargin - 2, 3]);

D0 = 2.8;
n0_xy = 0.2;
gamma_c0_xy=50;%20*2*pi;
gamma_p0_xy =1000;%200*2*pi;

% for dx: 
% D0 = 2.7;
% n0_xy = 0.2;
% gamma_c0_xy=130;%20*2*pi;
% gamma_p0_xy =1000;%200*2*pi;



n0_z = 0.02;
gamma_c0_z = 100;%20*2*pi;
gamma_p0_z = 1000;%200*2*pi;

if length(ndim) == 1,
    ndim_xy = ndim;
    ndim_z = ndim;
    if ndim == 1,
        beta_xy = [D0, n0_xy, gamma_c0_xy];
        beta_z = [D0, n0_z, gamma_c0_z];
        g_xy = @g_1;
        g_z = @g_1;
    else if ndim == 2,
            beta_xy = [D0, n0_xy, gamma_c0_xy, gamma_p0_xy];
            beta_z = [D0, n0_z, gamma_c0_z, gamma_p0_z];
            g_xy = @g_2;
            g_z = @g_2;
        else 
            error('I can not fit for dimensions higher than 2 right now.');
        end;
    end;
else 
    ndim_xy = ndim(1);
    ndim_z = ndim(2);
    if ndim_xy == 1,
        beta_xy = [D0, n0_xy, gamma_c0_xy];
        g_xy = @g_1;
    else if ndim_xy == 2,
            beta_xy = [D0, n0_xy, gamma_c0_xy, gamma_p0_xy];
            g_xy = @g_2;
        else 
            error('I can not fit for dimensions higher than 2 right now.');
        end;
    end;
    if ndim_z == 1,
        beta_z = [D0, n0_z, gamma_c0_z];
        g_z = @g_1;
    else if ndim_z == 2,
            beta_z = [D0, n0_z, gamma_c0_z, gamma_p0_z];
            g_z = @g_2;
        else 
            error('I can not fit for dimensions higher than 2 right now.');
        end;
    end;
end;
    
    
Dvec = zeros(num_in, 1);
nvec = zeros(num_in, 1);
gammavec_fit = zeros(num_in, max(ndim)) + inf;

beta_x = nlinfit(dt, dx, g_xy, beta_xy);
D_fit(1) = beta_x(1);
n_fit(1) = beta_x(2);

for ii = 1:ndim,
    gammavec_fit(1, ii) = beta_x(2 + ii);
end;


if num_in > 1,
    beta_y = nlinfit(dt, dy, g_xy, beta_xy);
    D_fit(2) = beta_y(1);
    n_fit(2) = beta_y(2);

    for ii = 1:ndim_xy,
        gammavec_fit(2, ii) = beta_y(2 + ii);
    end;
end;

if num_in > 2,
    beta_z = nlinfit(dt, dz, g_z, beta_z);
    D_fit(3) = beta_z(1);
    n_fit(3) = beta_z(2);

    for ii = 1:ndim_z,
        gammavec_fit(3, ii) = beta_z(2 + ii);
    end;
end;

figure; 
if num_in == 1,
    semilogx(dt, dx, 'b', dt, g_xy(beta_x, dt), 'k');
else if num_in == 2,
        semilogx(dt, dx, 'b', dt, g_xy(beta_x, dt), 'k', dt, dy, 'g', dt, g_xy(beta_y, dt), 'k');
    else 
        semilogx(dt, dx, 'b', dt, g_xy(beta_x, dt), 'b', dt, dy, 'g', dt, g_xy(beta_y, dt), 'g', dt, dz, 'r', dt, g_z(beta_z, dt), 'r');
    end;
end;

L = find_L(D_fit, n_fit, gammavec_fit);
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

 y = D - D./t .* (2./nu*sinh(nu*t/2).*exp(-gamma_p*t/2) + (1/gamma_p - 1/gamma_c + n^2*gamma_c/(2*D)) .* ...
          (-1 + exp(-gamma_p*t/2).*(cosh(nu*t/2) + gamma_p/nu*sinh(nu*t/2))));
return;
