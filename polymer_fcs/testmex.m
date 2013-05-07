%clear all;
global hofx_table hofx_arange hofx_xrange;

[sigmaxy, sigmaz, gam, Rg, wxy, wz, L, b, Delta] = get_fit_params;
gamxy = gam;
gamz = gam;
 
tau1 = 0.2;
tau = logspace(-6,0,25);
load hofxtable;

hofx_table = h;
hofx_arange = arange;
hofx_xrange = xrange;

tic; 
grouse = exact_blas(sigmaxy, sigmaz, gamxy, gamz, wxy, wz, L, b, Delta, 0.8, 2, Rg, tau);
toc;

tic;
gzimm = exact_blas(sigmaxy, sigmaz, gamxy, gamz, wxy, wz, L, b, Delta, tau1, 4/3, Rg, tau);
toc;

figure(121);
semilogx(tau, grouse, tau, gzimm);
legend('exact Rouse', 'exact Zimm');
