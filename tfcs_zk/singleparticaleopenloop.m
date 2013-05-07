% %diffusion coefficient of Qdots in um^2/s
% D=140;
% %laser xy dimension in um
% w_xy=0.65;
% %laser z dimension in um
% %w_z=2;
% w_z=pi*w_xy^2/0.532;
% 
% 
% %number of Qdots in laser focal volume. 
% N=20;
% 
% tau_xy=w_xy^2/(4*D);
% tau_z=w_z^2/(4*D);
% 
% 
% 
% t=logspace(-7,0,70);
% 
% 
% 
% 
% %these A1 A2 B1 B2 here are to take care of integration done in the g2tau
% %from Laurance Method.
% for j=1:1:(length(t)-1)
%     to=t(j+1)-t(j);
%     
%     logA1=log((tau_z-tau_xy)^0.5+(tau_z+t(j))^0.5);
%     logA2=log((tau_z-tau_xy)^0.5-(tau_z+to+t(j))^0.5);
%     
%     logB1=log((tau_z-tau_xy)^0.5-(tau_z+t(j))^0.5);
%     logB2=log((tau_z-tau_xy)^0.5+(tau_z+to+t(j))^0.5);
%     
%     g2t_normalized(j)=(1/N)*(tau_xy/to)*(tau_z/(tau_z-tau_xy))^0.5*(logA1+logA2-logB1-logB2);
% end
% 
% g2t_normalized(length(t))=g2t_normalized(length(t)-1);
% 
% g2t=(1/N)*(1./(1+t/tau_xy)).*(1./(1+t/tau_z).^0.5);
% 
%     
%  figure;hold all; 
%  subplot(1,2,1);hold all;
% for j=1:1:5    
%     TwoStateGG=TwoState_DD2(t,1*10^j,1*10^j,100000);
% 
%     %total_g2=(g2t+1).*TwoStateGG-1;
%     %total_g2=(g2t).*TwoStateGG;
%       twostate_g2=TwoStateGG-1;
%     plot(log10(t),twostate_g2,'LineWidth',2)
% end
% xlabel('Tau [S]', 'FontSize', 14);
% ylabel('Correlation [A.U.]', 'FontSize', 14);
% legend('rate ~10^1 S^{-1}','rate ~10^2 S^{-1}','rate ~10^3 S^{-1}','rate ~10^4 S^{-1}','rate ~10^5 S^{-1}')
% %set(gca,'Xscale','log')
% 
% subplot(1,2,2);
% hold all;
% plot(log10(t),g2t,'--k','LineWidth',2)
% %set(gca,'Xscale','log')
% hold all;
% for j=1:1:5    
%     TwoStateGG=TwoState_DD2(t,1*10^j,1*10^j,100000);
% 
%     %total_g2=(g2t+1).*TwoStateGG-1;
%     total_g2=(g2t).*TwoStateGG;
%      %total_g2=TwoStateGG-1;
%     plot(log10(t),total_g2,'LineWidth',2)
% end
% 
% xlabel('Tau [S]', 'FontSize', 14);
% ylabel('Correlation [A.U.]', 'FontSize', 14);
% legend('diffusion only','rate ~10^1 S^{-1}','rate ~10^2 S^{-1}','rate ~10^3 S^{-1}','rate ~10^4 S^{-1}','rate ~10^5 S^{-1}')


t=logspace(-7,0,70);
%diffusion coefficient of Qdots in um^2/s
D=140;
%laser xy dimension in um
w_xy=0.65;
%laser z dimension in um
%w_z=2;
w_z=pi*w_xy^2/0.532;
%number of Qdots in laser focal volume. 
N=20;
tau_xy=w_xy^2/(4*D);
tau_z=w_z^2/(4*D);
diffu=(1./(1+t/tau_xy)).*(1./(1+t/tau_z).^0.5);
TwoStateGG=TwoState_DD2(t,1*10^5,1*10^5,100000);
g2t=(1/N)*diffu;

%% donor
figure;
subplot(1,2,1);
hold all;box on; grid on;  
plot(log10(t),g2t,'--k','LineWidth',2)
for j=1:1:5
L=0.5+2*(j-1);
ee=0.5;
total_g2=((1+L)/(N*L))*(((1-ee)*L)/((1-ee)*L+1))^2*TwoStateGG.*diffu...
    +((1+L)/N)*(1/((1-ee)*L+1))^2.*diffu;
c=scale(total_g2(46:70),g2t(46:70));
plot(log10(t),total_g2,'LineWidth',2)
end
L=100000000000000000000000000000000000000000;
ee=0.5;
total_g2=((1+L)/(N*L))*(((1-ee)*L)/((1-ee)*L+1))^2*TwoStateGG.*diffu...
    +((1+L)/N)*(1/((1-ee)*L+1))^2.*diffu;
c=scale(total_g2(46:70),g2t(46:70));
plot(log10(t),total_g2,'LineWidth',2)
xlabel('Tau [S]', 'FontSize', 14);
ylabel('Correlation [A.U.]', 'FontSize', 14);
legend('diffusion only','L=0.5','L=2.5','L=4.5','L=6.5','L=8.5','L=\infty')
%% acceptor
subplot(1,2,2);
hold all;box on; grid on;  
plot(log10(t),g2t,'--k','LineWidth',2)
L=1000000000000000000000000000000000000000000000;
%crst=0.15;
for j=1:1:6
crst=0+0.05*(j-1);
ee=0.6;
total_g2=((1+L)/(N*L))*(1+crst*(1-ee)/ee+crst/L/ee)^-2*(1-2*crst)*TwoStateGG.*diffu;
c=scale(total_g2(46:70),g2t(46:70));
plot(log10(t),total_g2,'LineWidth',2)
end
xlabel('Tau [S]', 'FontSize', 14);
ylabel('Correlation [A.U.]', 'FontSize', 14);
legend('diffusion only','c=0','c=0.05','c=0.1','c=0.15','c=0.2','c=0.25')
% 
%% cross 
% 
% subplot(1,3,3);
% hold all;box on; grid on;  
% plot(log10(t),g2t,'--k','LineWidth',2)
% crst=0.15;
% for j=1:1:5
% L=0.5+2*(j-1);
% ee=0.5;
% deno=(L-L*ee+1)*(ee*L+crst*L-crst*L*ee+crst);
% F1=((1+L)/(N*L))*(-ee^2*L^2+crst*L^2*(1-ee)^2)/deno;
% F2=(crst+crst*L)/N/deno;
% total_g2=F1*TwoStateGG.*diffu+F2*diffu;
% c=scale(total_g2(46:70),g2t(46:70));
% plot(log10(t),total_g2,'LineWidth',2)
% end
% L=100000000000000000000000000000000000000000000;
% ee=0.5;
% deno=(L-L*ee+1)*(ee*L+crst*L-crst*L*ee+crst);
% F1=((1+L)/(N*L))*(-ee^2*L^2+crst*L^2*(1-ee)^2)/deno;
% F2=(crst+crst*L)/N/deno;
% total_g2=F1*TwoStateGG.*diffu+F2*diffu;
% c=scale(total_g2(46:70),g2t(46:70));
% plot(log10(t),total_g2,'LineWidth',2)
% xlabel('Tau [S]', 'FontSize', 14);
% ylabel('Correlation [A.U.]', 'FontSize', 14);
% legend('diffusion only','L=0.5','L=2.5','L=4.5','L=6.5','L=8.5','L=\infty')
