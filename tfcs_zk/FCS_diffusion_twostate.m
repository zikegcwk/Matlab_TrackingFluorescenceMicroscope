%FCS_diffusion_twostate(t,wxy,wz,N,D,beta)
function g2tau=FCS_diffusion_twostate(t,wwxy,wwz,NN,DD,beta)
AA=beta(1);
kk=beta(2);
tau_D=wwxy^2/(4*DD);
tau_D_prime=wwz^2/(4*DD);

GG2_diffusion=(1/NN)*(1./(1+t/tau_D)).*(1./(1+t/tau_D_prime).^0.5);

GG2_twostate=AA.*exp(-kk.*t)+1;

g2tau=GG2_diffusion.*GG2_twostate;