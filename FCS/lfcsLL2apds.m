function [tau,gs] = lfcsLL2apds(traces,corrPairs,taumin,taumax,N)
tau = logspace(taumin,taumax,N);
npairs=length(corrPairs);
for i=1:npairs
    cpair=corrPairs{i};
    gs{i}=corr_Laurence(traces{cpair(1)},traces{cpair(2)},tau);
    gs{i}=gs{i}(1:end-1)-1;
end
tau = tau(1:end-1);