function [N1,D1,N2,D2]=FCS_twocomponent_diffusion_fit(tau,g2,wxy,wz)



f2fit=@(parameters,tau) FCS_twocomponent_diffusion(tau,wxy,wz,parameters(1),parameters(2),parameters(3),parameters(4));

%initial estimates for number of molecules inside laser focus
parameters_1_guess=1/0.50;
%initial estimates for diffusion coefficient.
parameters_2_guess=55;


%initial estimates for number of molecules inside laser focus
parameters_3_guess=1/0.50;
%initial estimates for diffusion coefficient.
parameters_4_guess=100;

[parameters_fit,r]=nlinfit(tau,g2,f2fit,[parameters_1_guess,parameters_2_guess,parameters_3_guess,parameters_4_guess]);



figure;
plot(log10(tau),g2,'-or','MarkerSize',4,'MarkerFaceColor','r');
hold on;
plot(log10(tau),FCS_twocomponent_diffusion(tau,wxy,wz,parameters_fit(1),parameters_fit(2),parameters_fit(3),parameters_fit(4)),'LineWidth',2);

disp(sprintf('Number of molecules A inside laser focus is: %g',parameters_fit(1)))
disp(sprintf('diffusion coefficient of molecule A is: %g um^2/s',parameters_fit(2)));

disp(sprintf('Number of molecules B inside laser focus is: %g',parameters_fit(3)))
disp(sprintf('diffusion coefficient of molecule B is: %g um^2/s',parameters_fit(4)));

N1=parameters_fit(1);
N2=parameters_fit(3);
D1=parameters_fit(2);
D2=parameters_fit(4);



function g2tau=FCS_twocomponent_diffusion(t,wwxy,wwz,NN1,DD1,NN2,DD2)

tau_D1=wwxy^2/(4*DD1);
tau_D_prime1=wwz^2/(4*DD1);

tau_D2=wwxy^2/(4*DD2);
tau_D_prime2=wwz^2/(4*DD2);

g2tau=(NN1/(NN1+NN2)^2)*(1./(1+t/tau_D1)).*(1./(1+t/tau_D_prime1).^0.5)+(NN2/(NN1+NN2)^2)*(1./(1+t/tau_D2)).*(1./(1+t/tau_D_prime2).^0.5);