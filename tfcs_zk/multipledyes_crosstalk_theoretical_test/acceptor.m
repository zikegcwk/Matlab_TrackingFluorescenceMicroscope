c=0;
tau=logspace(-6,0,120);
DNA=0.2.*exp(-10^4.*tau)+0.1*exp(-0.8*10^2.*tau);
x=3;
y=0;
eff=0.8;




D=[3.5 3.5 3.5];
bandwidth=[25*2*pi;25*2*pi;10*2*pi];
noise=[0.05;0.05;0.5];
laserwaist=[0.65;0.65;3];
T_GG2=Track_GG2(tau,D,bandwidth,noise,laserwaist,'first_order',0,0);
T_GG2=(T_GG2-1)*0.1+1;
T_GG2=0.05*exp(-10^3.*tau)+1;

g2_nocross=(DNA/x+1).*T_GG2-1;
g2_first=((x-2*c*x)*(DNA+1)+2*c*x*(1+y/x)*eff^-1+x*(x-1))./(x*(1-c)+c*(x+y)*eff^-1)^2;
g2_acceptor=g2_first.*T_GG2-1;

figure(1);clf;
semilogx(tau,DNA,'b','LineWidth',2);
hold on;
semilogx(tau,g2_acceptor,'g');
semilogx(tau,T_GG2-1,'k')
legend('DNA','total','tracking')
 