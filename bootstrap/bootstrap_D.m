%function bootstrap_D looks into file data_filenum.dat and extract
%diffusion coefficient and confidence intervals using bootstrap method. 
function [D,stdD]=bootstrap_D(filenum,t1,t2,dt)

%get all the iid variables for boostrap. 
[dx,dy,dz]=Delta_Extract(filenum,t1,t2,dt);

BDx=bootstrp(2000,@D_dx,dx);
BDy=bootstrp(2000,@D_dx,dy);
BDz=bootstrp(2000,@D_dx,dz);

tempD(1)=mean(dx.^2/dt/2);
tempD(2)=mean(dy.^2/dt/2);
tempD(3)=mean(dz.^2/dt/2);


tempstdD(1)=std(BDx);
tempstdD(2)=std(BDy);
tempstdD(3)=std(BDz);

D=mean(tempD);
%stdD=(sum(tempstdD.^2)/9)^0.5;
stdD=std(tempD);
function D=D_dx(dx)
D=mean(dx.^2)/2;
