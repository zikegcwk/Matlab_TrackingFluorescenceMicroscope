function [gs, ts] = smoothg(tau, g, dt);

ts = dt:dt:max(tau);
gs = zeros(size(ts));
for u = 1:(length(ts)-1),
    gs(u) = mean(g(find(ts(u) < tau & tau < ts(u+1))));
end;

return;