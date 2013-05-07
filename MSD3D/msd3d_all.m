function [dt,dx,dy,dz,T,I,std_I]=msd3d_all(listall)
N=length(listall);
dt=zeros(N,250);
dx=zeros(N,250);
dy=zeros(N,250);
dz=zeros(N,250);
T=zeros(N,1);
I=zeros(N,1);
std_I=zeros(N,1);

for j=1:1:N
     [dt(j,:),dx(j,:),dy(j,:),dz(j,:)]=msd3d_noplot(listall(j,1),listall(j,2),listall(j,3));
     %temp_D(1)=mean(dx(232:250)); %averaging from 0.6 sec to 1 sec. 
     %temp_D(2)=mean(dy(232:250));
     %temp_D(3)=mean(dz(232:250));
     %D(j)=mean(temp_D);
     %std_D(j)=std(temp_D);
     T(j)=listall(j,3)-listall(j,2);
 end


for j=1:1:N
    load(sprintf('data_%g.mat',listall(j,1)));
    temp_index=find(t0>listall(j,2)&t0<listall(j,3));
    temp_I=daq_out(temp_index);
    I(j)=mean(temp_I);
    std_I(j)=std(temp_I);
end