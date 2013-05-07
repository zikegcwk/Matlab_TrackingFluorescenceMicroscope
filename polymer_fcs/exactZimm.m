function g = exactZimm(beta, trange);
    [sigmaxy, sigmaz, gam, Rg, wxy, wz, L, b, Delta] = get_fit_params;
    gamxy = gam;
    gamz = gam; 
    
    tau1 = beta(1);
    scale = beta(2);
    
    g = scale*exact_blas(sigmaxy, sigmaz, gamxy, gamz, wxy, wz, L, b, Delta, tau1, 3/2, Rg, trange);
return;
