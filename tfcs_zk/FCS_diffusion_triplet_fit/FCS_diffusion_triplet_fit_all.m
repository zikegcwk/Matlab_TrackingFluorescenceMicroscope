%function FCS_diffusion_triplet_fit fits measured g2 to a model with
%diffusion and triplet state formation. It outputs the state life time of
%the triplet state as well as the fraction of population of the molecules
%that are in the triplet state.



function [N_fit D_fit T_fit t_triplet_fit]=FCS_diffusion_triplet_fit_all(tau,g2,wxy,wz)
lightcolor=[204,204,255;204,255,204;255,204,204;204,255,255;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;
darkcolor=[0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0];
lightcolor=[204,204,255;204,255,204;255,204,204;153,255,204;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;
%get the average value and weights
    [tau,ave_g2,std_g2,h]=draw_fcs(tau,g2,1,0);
     %set weights as 1/sigma^2.
     w=1./std_g2.^2;
     %weight the data. 
     wg2=w.^0.5.*ave_g2;
     %weight the model function
       
    %f2fit=@(para,tau) w.^0.5.*FCS_twostate(tau,para(1),para(2));
    f2fit=@(parameters,tau) w.^0.5.*FCS_diffusion_triplet(tau,wxy,wz,parameters(1),parameters(2),parameters(3),parameters(4));
    %[para_fit,residues,J,sigma]=nlinfit(tau,wg2,f2fit,[para_1_guess,para_2_guess]);
    
    


%number of molecule guess
parameters_1_guess=20;
%diffusion coefficient guess
parameters_2_guess=1.87*10^2;
%fraction of population in triplet state guess
parameters_3_guess=0.3;
%decay time of the triplet state guess
parameters_4_guess=10^-6;

size(wg2)

[parameters_fit,r]=nlinfit(tau,wg2,f2fit,[parameters_1_guess,parameters_2_guess,parameters_3_guess,parameters_4_guess]);


N_fit=parameters_fit(1);
D_fit=parameters_fit(2);
T_fit=parameters_fit(3);
t_triplet_fit=parameters_fit(4);

[hh,pp]=chi2gof(r);
if ~hh
    disp('Accept Model!')
else
    disp('Reject Model!')
end


figure;
shadedErrorBar_zk(tau,g2,{'Color',darkcolor(1,:),'LineWidth',2});hold on;
%semilogx(tau,g2,'-og','MarkerSize',4,'MarkerFaceColor','g');
%hold on;
plot(log10(tau),FCS_diffusion_triplet(tau,wxy,wz,parameters_fit(1),parameters_fit(2),parameters_fit(3),parameters_fit(4)),'r','LineWidth',2);


disp(sprintf('Number of molenule is: %g. \n',N_fit));
disp(sprintf('Diffusion Coefficient is %g um^2/s. \n', D_fit));
disp(sprintf('Fraction of triplet state is %g. \n', T_fit));
disp(sprintf('Tripet decay time scale is : %g us. \n',t_triplet_fit*10^6));


function g2tau=FCS_diffusion_triplet(t,wwxy,wwz,NN,DD,TT,tau_triplet)

tau_D=wwxy^2/(4*DD);
tau_D_prime=wwz^2/(4*DD);

gg2_diffusion=(1/NN)*(1./(1+t/tau_D)).*(1./(1+t/tau_D_prime).^0.5);
gg2_triplet=(1/(1-TT))*(1-TT+TT*exp(-t./tau_triplet));


g2tau=gg2_diffusion.*gg2_triplet;

