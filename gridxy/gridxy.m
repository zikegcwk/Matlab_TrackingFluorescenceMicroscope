

function gridxy(xmin,xmax,ymin,ymax,dx,stay_time)

if nargin==5
    stay_time=20; % 20 second detection time
else if nargin==0
        xmin=0;
        xmax=20;
        ymin=20;
        ymax=40;
        dx=2;
        stay_time=3;
    end
end


x = xmin:dx:xmax;
y = ymin:dx:ymax;

Nx=length(x);
Ny=length(y);


for j= 1:Nx;
    for k=1:Ny;
        StepXY(x(j) , y(k));
        pause(.1);
        acquire(Ny*(j-1)+k,Ny*(j-1)+k,stay_time);
    end;
end;








