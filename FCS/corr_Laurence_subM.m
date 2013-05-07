function g = corr_Laurence_subM(t,u,tau_mn,tau_mx);
g=0;
T = max([max(t) max(u)]);
N = length(t);
ix_low = 1;
ix_hig = 1;
% while exit deal...
for kk=1:length(t);
    while ix_low<=N & u(ix_low) < t(kk)+tau_mn;
        ix_low = ix_low+1;
    end;
    while ix_hig<=N & u(ix_low) < t(kk)+tau_mx;
        ix_hig = ix_hig+1;
    end;
    g = g+ ix_hig-ix_low;
end;

dtau = tau_mx-tau_mn;
tau = mean([tau_mn tau_mx]);
na = sum(t<=(T-tau));
nb = sum(u>=tau);
if na ~= 0 & nb ~=0 & dtau ~=0;
    g = g*(T-tau)/na/nb/dtau;
end;