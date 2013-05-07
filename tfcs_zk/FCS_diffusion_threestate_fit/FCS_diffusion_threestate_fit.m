function FCS_diffusion_threestate_fit(tau,g2,wxy,wz,D,N)

f2fit=@(parameters,tau) FCS_diffusion_threestate(tau,wxy,wz,N,D,parameters(1),parameters(2),parameters(3),parameters(4));

%amplitude of the exp guess
parameters_1_guess=0.1;
%rates guess
parameters_2_guess=10^5;
parameters_3_guess=0.1;
parameters_4_guess=10^4;





[parameters_fit,r]=nlinfit(tau,g2,f2fit,[parameters_1_guess,parameters_2_guess,parameters_3_guess,parameters_4_guess]);


figure;
semilogx(tau,g2,'-or','MarkerSize',4,'MarkerFaceColor','r');
hold on;
semilogx(tau,FCS_diffusion_threestate(tau,wxy,wz,N,D,parameters_fit(1),parameters_fit(2),parameters_fit(3),parameters_fit(4)),'LineWidth',2);
disp(sprintf('Rate is: %g',parameters_fit(2)));



function g2tau=FCS_diffusion_threestate(t,wwxy,wwz,NN,DD,A1,k1,A2,k2)

tau_D=wwxy^2/(4*DD);
tau_D_prime=wwz^2/(4*DD);

GG2_diffusion=(1/NN)*(1./(1+t/tau_D)).*(1./(1+t/tau_D_prime).^0.5)+1;

GG2_threestate=A1.*exp(-k1.*t)+A2.*exp(-k2.*t)+1;

g2tau=GG2_diffusion.*GG2_threestate-1;