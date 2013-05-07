function g2=FCS_sqtrackingpoly(t,para)
%% set parameters

t=logspace(-5,0,50);
tau=t;
%  g1=FCS_tracking(t,para);
%  g1(end)=[];
  for j=1:1:100
      poly(j,:)=para(j)*t.^(j-1);
  end    
 g1=sum(poly,1);
 g1(end)=[];

%fxy and fz is the frequencies of laser rotation and on-off.
fxy=95*10^3;
fz=100*10^3;
%fxy=para(5);
%fz=para(6);
%get the tri wave use the analytical normalized form
for j=1:1:length(tau)-1
        to=tau(j+1)-tau(j);
        for k=1:1:500 
               fff1(k)=(4/(pi^3*(2*k-1)^3*fxy*to))*...
                   (sin(2*pi*fxy*(2*k-1)*(tau(j)+to))-sin(2*pi*fxy*(2*k-1)*(tau(j))));               
        end
        tri1(j)=sum(fff1);
end     

g2=(tri1+1).*g1;
% figure;
% plot(log10(t(1:end-1)),g2)
% hold on;
% plot(log10(t(1:end-1)),g1,'r')
% plot(log10(t(1:end-1)),tri1,'g')
%  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 












% %% calculating triangular waves (averaged) for g2 p3.
% % for k=1:1:250
% % end
% % 
% % tri1=sum(ff1,1)+1;
% % tri2=sum(ff2,1)+1;
% tau=t;
% for j=1:1:(length(tau)-1)
%     %time scale for nomalization
%     to=tau(j+1)-tau(j);    
%     %k is index for square and triangular waves
%     for k=1:1:500 %you perhaps will never need to go to 1000!
%         %if not normalized, this is the expression. 
%         %ff1(k,:)=(8/pi^2)*cos((2*k-1)*2*pi*fz*t)./(2*k-1)^2;
%         %ff2(k,:)=(8/pi^2)*cos((2*k-1)*2*pi*fz*(t-0.5/fz))./(2*k-1)^2;        
%         %if you average it at different tau windows, you got this:
%         ff1(k)=(4/(pi^3*(2*k-1)^3*fz*to))*(sin(2*pi*fz*(2*k-1)*(tau(j)+to))-sin(2*pi*fz*(2*k-1)*(tau(j))));        
%         ff2(k)=(4/(pi^3*(2*k-1)^3*fz*to))*(sin(2*pi*fz*(2*k-1)*(tau(j)-0.5/fz+to))-sin(2*pi*fz*(2*k-1)*(tau(j)-0.5/fz)));        
%     end    
%     tri1(j)=sum(ff1);
%     tri2(j)=sum(ff2);   
% end
% %this is just to make sure tau and g2 have the same length. 
% tri1(length(tau))=tri1(length(tau)-1);
% tri2(length(tau))=tri2(length(tau)-1);
% 
% % for j=1:1:(length(tau)-1)
% %     %time scale for nomalization
% %     to=tau(j+1)-tau(j);
% %     %k is index for square and triangular waves
% %     for k=1:1:500 %you perhaps will never need to go to 1000!
% %         %if not normalized, this is the expression. 
% %         %ff(k,:)=(8/pi^2)*cos((2*k-1)*2*pi*f*tau)./(2*k-1)^2;       
% %         ff(k)=(4/(pi^3*(2*k-1)^3*f*to))*(sin(2*pi*f*(2*k-1)*(tau(j)+to))-sin(2*pi*f*(2*k-1)*(tau(j))));    
% %     end
% %     SB_g2(j)=sum(ff)+1;   
% % end
% % %this is just to make sure tau and g2 have the same length. 
% % SB_g2(length(tau))=SB_g2(length(tau)-1); 
% %% get the g3, finally.
% g_p3=(1+tri1).*exp(-z0^2./(sb^2+sigma_z.^2))+(1+tri2).*exp(-z0^2./(sb^2-sigma_z.^2));

%% get the g total.


















