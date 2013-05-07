%function FCS_diffusion_triplet_fit fits measured g2 to a model with
%diffusion and triplet state formation. It outputs the state life time of
%the triplet state as well as the fraction of population of the molecules
%that are in the triplet state.


function D_fit=FCS_diffusion_triplet_fit(tau,g2,wxy,wz)
%function [N_fit,D_fit, T_fit, t_triplet_fit, r]=FCS_diffusion_triplet_fit(tau,g2,wxy,wz)


f2fit=@(parameters,tau) FCS_diffusion_triplet(tau,wxy,wz,parameters(1),parameters(2),parameters(3),parameters(4));

%number of molecule guess
parameters_1_guess=30;
%diffusion coefficient guess
parameters_2_guess=190;
%fraction of population in triplet state guess
parameters_3_guess=0.3;
%decay time of the triplet state guess
parameters_4_guess=10^-4;

[parameters_fit,r]=nlinfit(tau,g2,f2fit,[parameters_1_guess,parameters_2_guess,parameters_3_guess,parameters_4_guess]);


N_fit=parameters_fit(1);
D_fit=parameters_fit(2);
T_fit=parameters_fit(3);
t_triplet_fit=parameters_fit(4);
if 0
    figure;
    subplot(2,1,1)
    semilogx(tau,g2,'-og','MarkerSize',4,'MarkerFaceColor','g');
    hold on;
    semilogx(tau,FCS_diffusion_triplet(tau,wxy,wz,parameters_fit(1),parameters_fit(2),parameters_fit(3),parameters_fit(4)),'r','LineWidth',2);
    title(cd);
    text(10^-3,g2(1)*6/6,sprintf('N - %g',N_fit));
    text(10^-3,g2(1)*5/6,sprintf('D - %g um^2/s',D_fit));
    text(10^-3,g2(1)*4/6,sprintf('T - %g',T_fit));
    text(10^-3,g2(1)*3/6,sprintf('t_triplet - %g uS',t_triplet_fit*10^6));

    disp(cd);
    disp(sprintf('Number of molenule is: %g. \n',N_fit));
    disp(sprintf('Diffusion Coefficient is %g um^2/s. \n', D_fit));
    disp(sprintf('Fraction of triplet state is %g. \n', T_fit));
    disp(sprintf('Tripet decay time scale is : %g us. \n',t_triplet_fit*10^6));

    subplot(2,1,2);
    semilogx(tau,r,'-or','MarkerSize',4,'MarkerFaceColor','r');
    [d,p]=chi2gof(r)
end


function g2tau=FCS_diffusion_triplet(t,wwxy,wwz,NN,DD,TT,tau_triplet)

tau_D=wwxy^2/(4*DD);
tau_D_prime=wwz^2/(4*DD);

gg2_diffusion=(1/NN)*(1./(1+t/tau_D)).*(1./(1+t/tau_D_prime).^0.5);
gg2_triplet=(1/(1-TT))*(1-TT+TT*exp(-t./tau_triplet));


g2tau=gg2_diffusion.*gg2_triplet;

