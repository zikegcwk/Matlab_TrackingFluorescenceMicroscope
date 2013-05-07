function [tau,ave_X1,ave_X2,ave_X3,X1,X2,X3]=FCS_JUMP_ZK_select(siglist,taumin,taumax,N,tide)

 

X1=zeros(length(siglist),N-1);
X2=zeros(length(siglist),N-1);
X3=zeros(length(siglist),N-1);

for j=1:1:length(siglist)
           disp(sprintf('begin FCS calculations on file %g. ', siglist(j,1)));
                   
           [tau,X1(j,:),X2(j,:),X3(j,:)]=FCS_JUMP_ZK_4(siglist(j,1),siglist(j,2),siglist(j,3),taumin,taumax,N);
                     
end

ave_X1=mean(X1,1);
ave_X2=mean(X2,1);
ave_X3=mean(X3,1);       
scrsz = get(0,'ScreenSize');
 figure('Name',strcat(cd),'Position',[200 scrsz(4)/3-100 scrsz(3)/2 scrsz(4)/1.5-100])
 title(cd)
 semilogx(tau,ave_X1,'r');
 hold on;
 semilogx(tau,ave_X2,'b');
 semilogx(tau,ave_X3,'k');

if nargin==5
 scrsz = get(0,'ScreenSize');
 figure('Name',strcat(cd,'Normalized'),'Position',[200 scrsz(4)/3-100 scrsz(3)/2 scrsz(4)/1.5-100])
 title(cd)
 t_tide=min(find(tau>tide));
 scale_X1=scale(ave_X1(t_tide:end),ave_X3(t_tide:end));
 scale_X2=scale(ave_X2(t_tide:end),ave_X3(t_tide:end));
 semilogx(tau,ave_X1*scale_X1,'r');
 hold on;
 semilogx(tau,ave_X2*scale_X2,'b');
 semilogx(tau,ave_X3,'k');
end    
% figure('Name',strcat(cd,'\Donor'),'Position',[200 scrsz(4)/3-100 scrsz(3)/2 scrsz(4)/1.5-100])
% title('Donor Autocorrelation')
