% This script compares the outputs of two versions of exact_blas.c
% It is for debugging purposes; to the best of my knowledge, the version of
% this file contained here produces accurate results.

which exact_blas
which exact_blas_arch

y = linspace(0,1,20);
tau = logspace(-5,0,100);
sigxy = 0.1;
sigz = 0.3;
gamxy = 15*2*pi;
gamz = 1.4*2*pi;
wxy = 0.22;
wz = 0.75;
tau1 = 0.3;
a = 2;
L = 17;
b = 0.084;

gold = exact_blas_arch(sigxy, sigz, gamxy, gamz, wxy, wz, L, b, tau1, a, y, tau);
gnew = exact_blas(sigxy, sigz, gamxy, gamz, wxy, wz, L, b, tau1, a, y, tau);

if length(tau) > 1,
    semilogx(tau, gold, 'x-', tau, gnew, '.-');
    fprintf('Maximum absolute difference: %g\n', max(abs(gold-gnew)));
else
    fprintf('Old code gives: %g\nNew code gives: %g\n', gold, gnew);
end;