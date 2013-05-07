function g = approxZimm(beta, trange);
    global hofx_table hofx_arange hofx_xrange;
    
    [sigmaxy, sigmaz, gam, Rg, wxy, wz, L, b, Delta] = get_fit_params;
    gamxy = gam;
    gamz = gam; 
    
    tau1 = beta(1);
    scale = beta(2);
    a = 3/2;
    
    g = scale*shortTimeApprox(sigmaxy, sigmaz, gamxy, gamz, wxy, wz, L, b, Delta, tau1, ...
        a, Rg, trange, hofx_table, hofx_arange, hofx_xrange);
return;

% function g = approxZimm(beta, trange);
%     [sigmaxy, sigmaz, gam, Rg, wxy, wz] = get_fit_params;
%     tau1 = beta(1);
%     scale = beta(2);
%     a = 3/2;
%   
%     for u = 1:length(trange)
%         t = trange(u);
%         gnorm = sum(1./((sigmaxy^2 + Rg.^2 + wxy^2/4).^2)*1./(sigmaz^2 + Rg.^2 + wz^2/4)); 
%         g(u) = sum(1./((sigmaxy^2 + Rg.^2 + wxy^2/4).^2 - ...
%             (sigmaxy^2*exp(-t*gam) + 1/6*(2*Rg.^2 - 2.68*(t/tau1)^(1/a))).^2)...
%             *1./sqrt((sigmaz^2 + Rg.^2 + wz^2/4).^2 - ...
%             (sigmaz^2*exp(-t*gam) + 1/6*(2*Rg.^2 - 2.68*(t/tau1)^(1/a))).^2))/gnorm-1;
%         g(u) = g(u)*scale;
%     end;
% return;
