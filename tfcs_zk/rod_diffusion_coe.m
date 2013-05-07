function rodD=rod_diffusion_coe(n)
kb=1.38e-23;
T=293;
eta=0.001;

dia=20;

p=3.4*n/dia;

v=0.312+0.565*p^-1-0.1*p^-2;

rodD=(log(p)+v)*(kb*T)/(3*pi*eta*n*3.4*10^-10)*10^12;


