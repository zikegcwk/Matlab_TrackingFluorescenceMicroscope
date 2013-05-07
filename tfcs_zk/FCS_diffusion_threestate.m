function g2tau=FCS_diffusion_threestate(t,para)
wwxy=1;
wwz=pi/0.532;
A1=para(1);
k1=para(2);
A2=para(3);
k2=para(4);
%NN=para(5);
%DD=para(6);
NN=1;
DD=140;
tau_D=wwxy^2/(4*DD);
tau_D_prime=wwz^2/(4*DD);

gg2_diffusion=(1/NN)*(1./(1+t/tau_D)).*(1./(1+t/tau_D_prime).^0.5);

GG2_threestate=A1.*exp(-k1.*t)+A2.*exp(-k2.*t)+1;

g2tau=gg2_diffusion.*GG2_threestate;