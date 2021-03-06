%function SB_g2=StrobingLaser_duty_GG2(tau,f,d)

%tau is the correlation time scale and f is the frequency in which the
%data is recorded, and d is the duty cycle of the strobing laser. 


% this code is to calculate the g2 contribution due to the strobing laser with some duty cycle d.
% not the complete g2 for strobing laser
% basically, it's <T(t)T(t+tau)>/<T(t)>^2. 

% I want to first get rid of the strobing laser contribution before I fit
% the two state model to the hairpin data. 

%created by ZK 01032010


function SB_GG2=StrobingLaser_duty_GG2(tau,f,d)

for j=1:1:(length(tau)-1)
    %time scale for nomalization
    to=tau(j+1)-tau(j);
    
    
    %k is index for square and triangular waves
    for k=1:1:500 %you perhaps will never need to go to 1000!
        %if not normalized, this is the expression. 
        %ff(k,1)=0.5*(2/k/pi/d)^2*(sin(k*pi*d))^2*cos(2*pi*f*k*tau(j));
        ff(k,1)=(1/(2*to))*(2/k/pi/d)^2*(sin(k*pi*d))^2*(1/2/pi/k/f)*(sin(2*pi*f*k*(tau(j)+to))-sin(2*pi*f*k*tau(j)));
        

    end
    
    SB_GG2(j)=sum(ff,1)+1;
    
    
end

%this is just to make sure tau and g2 have the same length. 
SB_GG2(length(tau))=SB_GG2(length(tau)-1);
    