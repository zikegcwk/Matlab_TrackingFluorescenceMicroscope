function g = corr_Laurence_sub(t,u,tau_mn,tau_mx);
g=0;
T = max([max(t) max(u)]);

for kk=1:length(t);
    g = g+ sum(u>= t(kk)+tau_mn & u< t(kk)+tau_mx);
end;

dtau = tau_mx-tau_mn;
tau = mean([tau_mn tau_mx]);
na = sum(t<=(T-tau));
nb = sum(u>=tau);
if na ~= 0 & nb ~=0 & dtau ~=0;
    g = g*(T-tau)/na/nb/dtau;
end;