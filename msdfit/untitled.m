[tau,D_fit,L_fit,gamma_fit]=msdfitTraces(M)
[n,p]=size(M);
tau=zeros(n,1);
D_fit=zeros(n,3);
L_fit=zeros(n,3);
gamma_fit=zeros(n,3);

for i=1:n
    tau(i)=M(i,3)-M(i,2);
    [dt,dx,dy,dz]=MSD3D(M(i,1),M(i,2),M(i,3));
    [cD,cN,cGamma,cL]=msdfit(1,dt,dx,dy,dz);
    D_fit(i,:)=cD;
    gamma_fit(i,:)=cGamma';
    L_fit(i,:)=cL';
end

