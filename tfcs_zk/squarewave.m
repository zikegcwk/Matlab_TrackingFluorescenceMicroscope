%function sqaure_wave generates a square wave with frequency f in time
%domain t. t is a time vector. 

function square_wave=squarewave(f,t)

%f=10;

%t=linspace(0,1,200);


for k=1:1:250

%ff(k,:)=(4/pi)*sin((2*k-1)*2*pi*f*(t+0.25/f))./(2*k-1);
ff(k,:)=(4/pi)*sin((2*k-1)*2*pi*f*t)./(2*k-1);

end

square_wave=(sum(ff,1)+1)/2;


