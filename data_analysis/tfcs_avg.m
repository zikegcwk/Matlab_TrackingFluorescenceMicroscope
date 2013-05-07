function [tauav, gav] = tfcs_avg(tau, g, avgtime, maxtime),

tauav = avgtime:avgtime:maxtime;
gav = zeros(size(tauav));

for u = 1:length(tauav),
    if u == 1, 
        w_min = 0;
    else
        w_min = tauav(u-1);
    end;
      
    w_max = tauav(u);
    
    gav(u) = mean(g(find(tau >= w_min & tau <= w_max)));
end;

return;




