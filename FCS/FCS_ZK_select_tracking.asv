%FCS_ZK_select(siglist,taumin,taumax,N,tide)
function [tau,ave_X1,ave_X2,ave_X3,X1,X2,X3,ave_Tr,Tr,laser,T,I]=FCS_ZK_select_tracking(siglist,taumin,taumax,N)

Tr=zeros(length(siglist),N-1);
X1=zeros(length(siglist),N-1);
X2=zeros(length(siglist),N-1);
X3=zeros(length(siglist),N-1);
T=zeros(length(siglist),1);

for j=1:1:length(siglist)
    [tau,X1(j,:),X2(j,:),X3(j,:),Tr(j,:)]=FCS_ZK_tracking_4(siglist(j,1),siglist(j,2),siglist(j,3),taumin,taumax,N);
    [I{j},tt,laser(j,1),laser(j,2)]=plot_fluo(siglist(j,1),10^-2,siglist(j,2),siglist(j,3),0);
    T(j,1)=siglist(j,3)-siglist(j,2);
end

%ave_X1=mean(X1,1);
%ave_X2=mean(X2,1);
%ave_X3=mean(X3,1);       
ave_X1=ave_msd(X1,T);
ave_X2=ave_msd(X2,T);
ave_X3=ave_msd(X3,T);
ave_Tr=ave_msd(Tr,T);

scrsz = get(0,'ScreenSize');
figure('Name',strcat(cd),'Position',[200 scrsz(4)/3-100 scrsz(3)/2 scrsz(4)/1.5-100])
title(cd)
semilogx(tau,ave_X1,'r');
hold on;
semilogx(tau,ave_X2,'b');
semilogx(tau,ave_X3,'k');
semilogx(tau,ave_Tr,'g');
legend('acceptor','donor','cross','tracking')
