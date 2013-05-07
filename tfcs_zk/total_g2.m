

tau=logspace(-6,0,240);
k12=10^4;
k21=10^3;

D=[5 5 5];
bandwidth=[10*2*pi 200*2*pi;10*2*pi 200*2*pi;5*2*pi 300*2*pi];
noise=[0.005;0.005;0.05];
laserwaist=[0.65;0.65;3];


DyeGG2=TwoState_DD2(tau,k12,k21,10);
SBL_GG2=StrobingLaser_GG2(tau,100*10^3);
T_GG2=Track_GG2(tau,D,bandwidth,noise,laserwaist,'second_order',0,0);
T_GG2=0.2*(T_GG2-1)+1;
figure;
hold on;
%semilogx(tau,DyeGG2-1,'r');
%control
semilogx(tau,T_GG2-1,'b','LineWidth',2);%no strobing
semilogx(tau,SBL_GG2.*T_GG2-1,'b');%add strobing
%HP
semilogx(tau,DyeGG2.*T_GG2-1,'r','LineWidth',2)
semilogx(tau,DyeGG2.*SBL_GG2.*T_GG2-1,'r');
legend('control','control strobing','sample','sample strobing')
set(gca,'Xscale','log')