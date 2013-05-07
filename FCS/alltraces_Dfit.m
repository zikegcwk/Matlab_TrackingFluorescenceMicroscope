function [DCOEFFS,NEFFS]=alltraces_Dfit(dataidxs,start,stop,omega,xi,td0,tagPlot)
nfits=length(dataidxs);
NEFFS=zeros(nfits,1);
DCOEFFS=zeros(nfits,1);
for i=1:nfits
    [tau,g]=lfcs(dataidxs(i),start,stop,200);
    [DCOEFFS(i),NEFFS(i)]=fcs_singleparticle_Dfit(tau,g,omega,xi,td0,tagPlot);
end
end