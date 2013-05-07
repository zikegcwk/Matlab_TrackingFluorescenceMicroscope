function [NEFF,OMEGAS,XIS,VEFFS]=beamcalib(dataidxs,start,stop,Dth,tagPlot)
nfits=length(dataidxs);
NEFF=zeros(nfits,1);
OMEGAS=zeros(nfits,1);
XIS=zeros(nfits,1);
VEFFS=zeros(nfits,1);
for i=1:nfits
    [tau,g]=lfcs(dataidxs(i),start,stop,200);
    [NEFF(i),OMEGAS(i),XIS(i),VEFFS(i)]=fcs_beamfit(tau,g,Dth,tagPlot);
end
end
    
    