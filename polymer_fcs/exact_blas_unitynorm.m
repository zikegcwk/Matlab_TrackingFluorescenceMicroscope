function g = exact_blas_unitynorm(sigxy, sigz, gamxy, gamz, wxy, wz, L, b,...
    tau1, a, y_over_L, tau);
	
g0 = exact_blas(sigxy, sigz, gamxy, gamz, wxy, wz, L, b, tau1, a, y_over_L, tau);
g = g0/gausspoly_variance(L, b, y_over_L, wxy, wz, sigxy, sigz);
return;