%function SB_g2=StrobingLaser_g2(tau,f)

%tau is the correlation time scale and f is the frequency in which the
%laser is strobed. 


% this code is to calculate the g2 contribution due to the strobing laser.
% not the complete g2 for strobing laser
% basically, it's <T(t)T(t+tau)>/<T(t)>^2. 

% I want to first get rid of the strobing laser contribution before I fit
% the two state model to the hairpin data. 

%created by ZK 06182009


function SB_g2=StrobingLaser_g2(tau,f)
for j=1:1:(length(tau)-1)
    %time scale for nomalization
    to=tau(j+1)-tau(j);
    %k is index for square and triangular waves
    for k=1:1:500 %you perhaps will never need to go to 1000!
        %if not normalized, this is the expression. 
        %ff(k,:)=(8/pi^2)*cos((2*k-1)*2*pi*f*tau)./(2*k-1)^2;       
        ff(k)=(4/(pi^3*(2*k-1)^3*f*to))*(sin(2*pi*f*(2*k-1)*(tau(j)+to))-sin(2*pi*f*(2*k-1)*(tau(j))));    
    end
    SB_g2(j)=sum(ff)+1;   
end
%this is just to make sure tau and g2 have the same length. 
SB_g2(length(tau))=SB_g2(length(tau)-1);   
figure;
plot(log10(tau),SB_g2-1);