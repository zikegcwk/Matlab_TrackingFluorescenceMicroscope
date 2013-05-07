function g=TrackingTwoState(tau,tg2,beta)
c=beta(1);
rate=beta(2);
g=(tg2+1).*(c.*exp(-rate*tau)+1)-1;


%this is the unnormalized version
%g=(tg2+1).*(c.*exp(-rate*tau)+1)-1;

%this is the normalized version
% for j=1:1:(length(tau)-1)
%     %time scale for nomalization
%     to=tau(j+1)-tau(j);    
%     g=(((c/(to*rate))*exp(-rate*tau)*(1-exp(-rate*to)))+1).*(tg2+1)-1;
% end
% 
% %this is just to make sure tau and g2 have the same length. 
% g(length(tau))=g(length(tau)-1);