function [dt,dx,dy,dz,I,std_I,T]=remove_bad(bad,dt,dx,dy,dz,I,std_I,T)




for j=1:1:length(bad)
    dt(bad(j),:)=[];
    dx(bad(j),:)=[];
    dy(bad(j),:)=[];
    dz(bad(j),:)=[];
    I(bad(j),:)=[];
    std_I(bad(j),:)=[];
    T(bad(j),:)=[];
end