% BEAMSCANFIT  Fit a set of 1-D Gaussians to a 2-D beam scan
%   [xfit, wfit, afit, bgfit] = BeamScanFit(x, y, M, x0, y0, w0)
%   fits a Gaussian function of x to each slice through M along y.
%   [xfit, wfit, afit, bgfit] = BeamScanFit(x, y, M, x0, y0, w0, beadDiam)
%   corrects waist measurements for the diameter, beadDiam, of the bead 
%   used in making the scan
% 
% See also scanxy 
function [xfit, wfit, afit, bgfit] = BeamScanFit(x, y, M, x0, y0, w0, beadDiam),
if nargin < 6,
    error('6 arguments required.');
end;

if nargin < 7,
    beadDiam = 0;
end;

if nargin > 7,
    warning('Too many arguments. Extra will be ignored.');
end;

dx_fine = (max(x)-min(x))/100;
x_fine = min(x):dx_fine:max(x);

dy_fine = (max(y)-min(y))/100;
y_fine = min(y):dy_fine:max(y);

bg0 = min(min(M));
a0 = max(max(M)) - bg0;

g = inline('beta(1) + beta(2)*exp(-2*(x-beta(3)).^2./beta(4)^2)','beta','x');

xfit = zeros(size(M, 1), 1);
wfit = zeros(size(M, 1), 2);
afit = zeros(size(M, 1), 2);
bgfit = zeros(size(M, 1), 2);

figure(2000); clf; hold on;
for ix = 1:size(M, 1),
    data = M(ix, :);
    beta = nlinfit(x, data, g, [bg0, a0, x0, w0]);
    xfit(ix) = beta(3);
    bgfit(ix, 1) = beta(1);
    afit(ix, 1) = beta(2);
    wfit(ix, 1) = beta(4);
    plot(x_fine, g(beta, x_fine), x, M(ix, :), '.');
end;

hold off;

xlabel('x'); ylabel('Intensity'); title('Fits along x');

afittmp = afit;
afittmp(wfit(:, 1) > 3) = 0; % Get rid of extraneous values to fitting to lack of signal
w_peak = wfit(find(afittmp(:, 1) == max(afittmp(:, 1))), 1);
w_peak = sqrt(w_peak^2-beadDiam^2/4*sqrt(2));
fprintf('Beam waist along x  at peak intensity: %g\n', w_peak);

figure(2001); clf; hold on;

for iy = 1:size(M, 2),
    data = M(:, iy)';
    beta = nlinfit(y, data, g, [bg0, a0, y0, w0]);
    yfit(iy) = beta(3);
    bgfit(iy, 2) = beta(1);
    afit(iy, 2) = beta(2);
    wfit(iy, 2) = beta(4);
    plot(y_fine, g(beta, y_fine), y, M(:, iy)', '.');
end;

hold off;
xlabel('y'); ylabel('Intensity'); title('Fits along y');

afittmp = afit;
afittmp(wfit(:, 2) > 3, 2) = 0; % Get rid of extraneous values to fitting to lack of signal
w_peak = wfit(find(afittmp(:, 2) == max(afittmp(:, 2))), 2);

w_peak = sqrt(w_peak^2-beadDiam^2/4*sqrt(2));
fprintf('Beam waist along y at peak intensity: %g\n', w_peak);

wfit = sqrt(wfit.^2 - beadDiam^2/4*sqrt(2)); % Correction for bead size. See lab notebook, may 2008

if nargout == 0,
    clear xfit wfit afit bgfit;
end;
