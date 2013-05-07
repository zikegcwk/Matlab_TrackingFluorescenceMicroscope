function [c,bins]=bin2d(X,Y,x0,y0,x1,y1,dx,dy)
p=floor((x1-x0)/dx)+1;
q=floor((y1-y0)/dy)+1;
npoints=length(X);
npoints2=length(Y);
if (not(npoints==npoints2))
    error('X and Y must have same length');
else
bins=zeros(npoints,2);
c=zeros(p,q);
for i=1:npoints
    if(X(i)<=x1 && X(i)>=x0 && Y(i)<=y1 && Y(i)>=y0)
        ci=floor((X(i)-x0)/dx)+1;
        cj=floor((Y(i)-y0)/dy)+1;
        c(ci,cj)=c(ci,cj)+1;
        bins(i,1)=ci;
        bins(i,2)=cj;
    end
end
end