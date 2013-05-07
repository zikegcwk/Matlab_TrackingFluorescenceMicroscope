function g = approxRouse(beta, trange);
    global hofx_table hofx_arange hofx_xrange;
    
    [sigmaxy, sigmaz, gam, Rg, wxy, wz, L, b, Delta] = get_fit_params;
    gamxy = gam;
    gamz = gam; 
    
    tau1 = beta(1);
    scale = beta(2);
    a = 2;
    
    g = scale*shortTimeApprox(sigmaxy, sigmaz, gamxy, gamz, wxy, wz, L, b, Delta, tau1, ...
        a, Rg, trange, hofx_table, hofx_arange, hofx_xrange);
return;

% function g = approxRouse(beta, trange)
%     global hofx_table;
%     global hofx_arange; 
%     global hofx_xrange;
%     
%     [sigmaxy, sigmaz, gam, Rg, wxy, wz, L, b, Delta] = get_fit_params;
%     tau1 = beta(1);
%     scale = beta(2);
%     a = 2;
%     g = zeros(size(trange));
% 
%     hofx_a_ix = find(hofx_arange <= a, 1, 'last');
%        
%     for u = 1:length(trange)
%         t = trange(u);   
%         tovertau = (t/tau1)^(1/a);
%         g(u) = sum(1./((sigmaxy^2 + Rg.^2 + wxy^2/4).^2 - ...
%             (sigmaxy^2*exp(-t*gam) + Rg.^2 - L*b/(3*pi^2)*sqrt(pi)*tovertau).^2)...
%             .*1./sqrt(((sigmaz^2 + Rg.^2 + wz^2/4).^2 - ...
%             (sigmaz^2*exp(-t*gam) + Rg.^2 - L*b/(3*pi^2)*sqrt(pi)*tovertau).^2)));
%             
%         gnorm = 0;
%         
%         if(1)
%             for l = 1:length(Rg),
%                 neqrange = [1:l-1,l+1:length(Rg)];
%                 x = abs(l-neqrange)*Delta/L/tovertau;
%                 hofx = zeros(size(x));
%                 for q = 1:length(x),
%                     hofx_x_ix = find(hofx_xrange <= x(q), 1, 'last');
%                     dhofxda = diff(hofx_table(hofx_a_ix+[0 1], hofx_x_ix))/diff(hofx_arange(hofx_a_ix+[0 1]));
%                     dhofxdx = diff(hofx_table(hofx_a_ix, hofx_x_ix + [0 1]))/diff(hofx_xrange(hofx_x_ix + [0 1]));
%                     hofx(q) = hofx_table(hofx_a_ix, hofx_x_ix) + ...
%                         dhofxdx*(x(q)-hofx_xrange(hofx_x_ix)) + ...
%                         dhofxda*(a-hofx_arange(hofx_a_ix));
%                 end;
% 
%                 Rgneq = Rg(neqrange);
%                 g(u) = g(u) + sum(1./((sigmaxy^2 + Rg(l)^2 + wxy^2/4)*(sigmaxy^2+Rgneq.^2 + wxy^2/4) - ...
%                     (sigmaxy^2*exp(-t*gam)+1/2*(Rg(l)^2 + Rgneq.^2)-1/6*abs(neqrange - l)*Delta*b - ...
%                     L*b/(3*pi^2)*(t/tau1)^(1/a)*hofx).^2).*...
%                     1./sqrt((sigmaz^2 + Rg(l)^2 + wz^2/4)*(sigmaz^2+Rgneq.^2 + wz^2/4) - ...
%                     (sigmaz^2*exp(-t*gam)+1/2*(Rg(l)^2 + Rgneq.^2)-1/6*abs(neqrange - l)*Delta*b -...
%                     L*b/(3*pi^2)*(t/tau1)^(1/a)*hofx).^2));
%                 gnorm = gnorm + sum(1./((sigmaxy^2+Rg(l)^2+wxy^2/4)*(sigmaxy^2+Rg.^2+wxy^2/4)).*...
%                     1./sqrt((sigmaz^2+Rg(l)^2+wz^2/4)*(sigmaz^2+Rg.^2+wz^2/4)));
%             end;
%         else
%             gnorm = sum(1./(sigmaxy^2+Rg.^2+wxy^2/4).^2.*1./(sigmaz^2+Rg.^2+wz^2/4));
%         end;
%         g(u) = (g(u)/gnorm-1)*scale;
%     
%     end;
% return;
