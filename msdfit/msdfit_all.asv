function [T,D_fit,L_fit,gamma_fit]= msdfit_all(M)
[n,p]=size(M);
T=zeros(n,1);
D_fit=zeros(n,3);
L_fit=zeros(n,3);
gamma_fit=zeros(n,3);

for j=1:1:n
    display(sprintf('Calculating msd fit for  %g out of %g.\n',j,n));
    display(sprintf('This is data_%g.mat',M(j,1)));
    MSD3d(M(j,1),M(j,2),M(j,3));
%    T(j)=M(j,3)-M(j,2);
%    [dt,dx,dy,dz]=MSD3D_noPlot(M(j,1),M(j,2),M(j,3));
%    [cD,cN,cGamma,cL]=msdfit(1,dt,dx,dy,dz);
%    D_fit(j,:)=cD;
%    gamma_fit(j,:)=cGamma';
%    L_fit(j,:)=cL';';
end

if nargout==0
    clear T D_fit L_fit gamma_fit;
end

