%function Delta_Extract looks into data_filenum.mat, and into data from t0
%to t1 and calculate delta_x y and z. delta_x is x(t+dt)-x(t). 


function [dx,dy,dz]=Delta_Extract(filenum,t1,t2,dt)

load(sprintf('data_%g.mat',filenum));

x=x0(t0>t1 & t0<t2);
y=y0(t0>t1 & t0<t2);
z=z0(t0>t1 & t0<t2);

index_jump=floor(dt*1000);
small_index=1;
big_index=small_index+floor(dt*1000);

j=1;

while big_index<length(x)
    x1=x(small_index);
    x2=x(big_index);    
    dx(j)=x2-x1;
    
    y1=y(small_index);
    y2=y(big_index);    
    dy(j)=y2-y1;
    
    z1=z(small_index);
    z2=z(big_index);    
    dz(j)=z2-z1;
    
    
    
    small_index=small_index+300;
    big_index=small_index+index_jump;
    j=j+1;
end
    






