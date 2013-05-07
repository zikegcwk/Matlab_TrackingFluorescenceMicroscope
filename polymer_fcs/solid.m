function g = solid(trange);

    [sigmaxy, sigmaz, gam, Rg, wxy, wz, L, b, Delta] = get_fit_params;
    gamxy = gam;
    gamz = gam; 
    
    Rg = mean(Rg);
    
    static_xy = sigmaxy^2+Rg.^2+wxy^2/4;
    static_z = sigmaz^2+Rg.^2+wz^2/4;

    g = zeros(size(trange));
    for u = 1:length(trange),
        t = trange(u);
        dynamic_xy = sigmaxy^2*exp(-gamxy*t);
        dynamic_z = sigmaz^2*exp(-gamz*t);

        g(u) = sum(1./((static_xy.^2 - dynamic_xy.^2)*sqrt(static_z.^2 - dynamic_z.^2)));
        gnorm = sum(1./((static_xy.^2)*sqrt(static_z.^2)));
        g(u) = g(u)/gnorm - 1;       
    end;

return;