% [g,g_std] = FCS_compute(t, u, tau_mn, tau_mx)
%   Returns the correlation (and their std) of discrete time vectors t and u evaluated at
%   the points given in tau_mn and tau_mx (left and right bin edges).
%
% g = FCS_compute(t, u, tau_mn)
%   Uses elements of tau_mn to define both left and right edges.

function [g,g_std] = FCS_compute(t,u,tau_mn,tau_mx)
% tau_mn, tau_mx same size vectors of left edge and right-edge for bins:
% calls FCS_core3.c
% you should look into FCS_core.c for notes. 

if nargin<4;
    tau_mx = tau_mn([2:end end]);
end;

t0 = min([min(t) min(u)]);
t = t-t0;
u = u-t0;
na=0*tau_mn;
nb=0*tau_mn;
g_tmp=0*tau_mn;
m=0*tau_mn;

[na,nb,g_tmp,m]= FCS_core3(t,u,tau_mn,tau_mx);

GG=g_tmp.*m./na./nb;
g=GG-1;
sigma2_yk=(na+nb+2*(g_tmp-na.*nb./m))./(na.*nb);
g_std=sqrt(sigma2_yk+GG.^2.*m.^0.2.*(1./na+1./nb));

if nargout == 1
    clear g_std;
end








%0*tau_mn;

%for kk = 1:length(tau_mn);
 %   g(kk) = corr_Laurence_sub(t,u,tau_mn(kk),tau_mx(kk));% mexed
%end;