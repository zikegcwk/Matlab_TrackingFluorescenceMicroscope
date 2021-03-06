function g2=FCS_sqtracking(t,para)
%% set parameters
para
gama1=para(1);
c1=para(2);
gama2=para(3);
c2=para(4);
%fxy and fz is the frequencies of laser rotation and on-off.
fxy=95*10^3;
fz=100*10^3;
%fxy=para(5);
%fz=para(6);

t=logspace(-5,0,50);
tau=t;
%z0 is the height of the two beams up and down.
z0=1;
%green laser waist size in xyz.
wxy=1;
wz=pi*wxy^2/0.532;
%r is the radius of which the beam is circled around.
r=wxy/1.414;

%% get the sigmas and sigma zeros. these are the slow stuff. 
sigma_xy=(c1*exp(-gama1.*t)).^0.5;
sigma_z=(c2*exp(-gama2.*t)).^0.5;
sgb=(c1+0.25*wxy^2)^0.5;
sb=(c2+0.25*wz^2)^0.5;
%% calculating g2 p1 and p2.
for j=1:1:(length(tau)-1)
    %disp(sprintf('numerical integrating: %g/20',j))
    if tau(j+1)<1e-3   
        clear ft temp ftv;
        to=tau(j+1)-tau(j);
        %fine tau
        clear ft ftv*;
        ft=tau(j):10^-7:tau(j+1);
        fs_xy=(c1*exp(-gama1.*ft)).^0.5;
        fs_z=(c2*exp(-gama2.*ft)).^0.5;
        %first 
        ftv1=0.5*(sgb^4*sb^2)./(sgb^4-fs_xy.^4)./(sb^4-fs_z.^4).^0.5;        
        %second
        ftv2=-r^2*(sgb^2-fs_xy.^2.*cos(2*pi*fxy.*ft))./(sgb^4-fs_xy.^4)...
               +r^2./sgb^2+z0^2./sb^2;
        ftv2=exp(ftv2);               
        %third
        clear ff1 ff2;  
         for k=1:1:500 %you perhaps will never need to go to 1000!
                %if not normalized, this is the expression. 
            ff1(k,:)=(8/pi^2)*cos((2*k-1)*2*pi*fz*ft)./(2*k-1)^2;
            ff2(k,:)=(8/pi^2)*cos((2*k-1)*2*pi*fz*(ft-0.5*fz))./(2*k-1)^2;
         end
         tri1=sum(ff1,1);
         tri2=sum(ff2,1);
         ftv3=(1+tri1).*exp(-z0^2./(sb^2+fs_z.^2))...
             +(1+tri2).*exp(-z0^2./(sb^2-fs_z.^2));    
        fg=ftv1.*ftv2.*ftv3-1;
        %now you have g2 at fine tau and its value is in ftv. 
        %now you can perform the integration and normalization.
        g2(j)=trapz(ft,fg)/to;
    else
        to=tau(j+1)-tau(j);
        clear g_p1 g_p2 g_p3
        %at large tau, I ignore the oscilation.
        g_p1=0.5*(sgb^4*sb^2)./(sgb^4-sigma_xy(j).^4)./(sb^4-sigma_z(j).^4).^0.5;%need to fix the power! 
%         g_p2=-r^2*(sgb^2-sigma_xy(j).^2.*cos(2*pi*fxy.*t(j)))./(sgb^4-sigma_xy(j).^4)...
%             +r^2./sgb^2+z0^2./sb^2;
        g_p2=-r^2*(sgb^2-sigma_xy(j).^2.*0)./(sgb^4-sigma_xy(j).^4)...
            +r^2./sgb^2+z0^2./sb^2;
        g_p2=exp(g_p2); 
        for k=1:1:500 
               fff1(k)=(4/(pi^3*(2*k-1)^3*fz*to))*...
                   (sin(2*pi*fz*(2*k-1)*(tau(j)+to))-sin(2*pi*fz*(2*k-1)*(tau(j))));        
               fff2(k)=(4/(pi^3*(2*k-1)^3*fz*to))*...
                   (sin(2*pi*fz*(2*k-1)*(tau(j)-0.5/fz+to))-sin(2*pi*fz*(2*k-1)*(tau(j)-0.5/fz)));        
        end
        tri1=sum(fff1);
        tri2=sum(fff2);
        g_p3=(1+tri1).*exp(-z0^2./(sb^2+sigma_z(j).^2))+(1+tri2).*exp(-z0^2./(sb^2-sigma_z(j).^2));
        g2(j)=g_p1.*g_p2.*g_p3-1;
        
    end    
end       
 figure;
 plot(log10(t(1:end-1)),g2)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 












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


















