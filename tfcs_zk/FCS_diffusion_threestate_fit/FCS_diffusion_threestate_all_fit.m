function FCS_diffusion_threestate_all_fit(tau,g2)

f2fit=@(para,tau) FCS_diffusion_threestate(tau,para);

%amplitude of the exp guess
para_g(1)=0.2;
%rates guess
para_g(2)=10^5;
para_g(3)=0.2;
para_g(4)=10^3;
%number of molecules
para_g(5)=30;
% diffusion coefficient
para_g(6)=195;
%op=statset('Display','off','MaxIter',200,'TolFun',1e-8,'TolX',1e-8,'DerivStep',6.055e-6,...
%    'FunValCheck','on','Robust','on','WgtFun','bisquare');

[para_f,r]=nlinfit(tau,g2,f2fit,para_g);
chi2gof(r)

figure;
plot(log10(tau),g2,'-or','MarkerSize',4,'MarkerFaceColor','r');
hold on;
plot(log10(tau),FCS_diffusion_threestate(tau,para_f),'LineWidth',2);

function g2tau=FCS_diffusion_threestate(t,para)
wwxy=1;
wwz=pi/0.532;

A1=para(1);
k1=para(2);
A2=para(3);
k2=para(4);
NN=para(5);
DD=para(6);

tau_D=wwxy^2/(4*DD);
tau_D_prime=wwz^2/(4*DD);

gg2_diffusion=(1/NN)*(1./(1+t/tau_D)).*(1./(1+t/tau_D_prime).^0.5);

GG2_threestate=A1.*exp(-k1.*t)+A2.*exp(-k2.*t)+1;

g2tau=gg2_diffusion.*GG2_threestate;