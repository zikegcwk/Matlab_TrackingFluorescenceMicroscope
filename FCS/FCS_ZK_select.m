%FCS_ZK_select(siglist,taumin,taumax,N,tide)
function [tau,ave_X1,ave_X2,ave_X3,X1,X2,X3,laser,T,I]=FCS_ZK_select(templist,taumin,taumax,N,tide)
u=1;
for j=1:1:size(templist,1)
   if (templist(j,3)-templist(j,2))>2
        siglist(u,1)=templist(j,1);
        siglist(u,2)=templist(j,2);
        siglist(u,3)=templist(j,3);
        u=u+1;
   end
end



X1=zeros(length(siglist),N-1);
X2=zeros(length(siglist),N-1);
X3=zeros(length(siglist),N-1);
T=zeros(length(siglist),1);

for j=1:1:size(siglist,1)

           disp(sprintf('begin FCS calculations on file %g. ', siglist(j,1)));               
           [tau,X1(j,:),X2(j,:),X3(j,:)]=FCS_ZK_4(siglist(j,1),siglist(j,2),siglist(j,3),taumin,taumax,N);
           [I{j},tt]=plot_fluo(siglist(j,1),10^-2,siglist(j,2),siglist(j,3),0);
           T(j,1)=siglist(j,3)-siglist(j,2);

end



%ave_X1=mean(X1,1);

%ave_X2=mean(X2,1);

%ave_X3=mean(X3,1);       

ave_X1=ave_msd(X1,T);
ave_X2=ave_msd(X2,T);
ave_X3=ave_msd(X3,T);

%scrsz = get(0,'ScreenSize');
figure(9379);clf;hold all;
 plot(log10(tau),ave_X1,'r');
 hold on;
 plot(log10(tau),ave_X2,'b');
 plot(log10(tau),ave_X3,'k');
 box on;
 grid on;

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



