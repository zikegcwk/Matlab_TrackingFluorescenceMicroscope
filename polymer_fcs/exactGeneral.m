function g = approxGeneral(beta, trange);
    global hofx_table hofx_arange hofx_xrange;
    
    [sigmaxy, sigmaz, gam, Rg, wxy, wz, L, b, Delta] = get_fit_params;
    gamxy = gam;
    gamz = gam; 
    
    tau1 = beta(1);
    scale = beta(2);
    a = beta(3);
    
    g = scale*exact_blas(sigmaxy, sigmaz, gamxy, gamz, wxy, wz, L, b, Delta, tau1, a, Rg, trange);
return;
