f=10;

t=linspace(0,1,200);


for k=1:1:2500

ff(k,:)=(4/pi)*sin((2*k-1)*2*pi*f*t)./(2*k-1);

end

fff=(sum(ff,1)+1)/2;

figure;

plot(t,fff)