function fit=FCS_diffusion_twostate_fit(tau,g2,wxy,wz,D,N)
lightcolor=[204,204,255;204,255,204;255,204,204;204,255,255;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;
darkcolor=[0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0];
lightcolor=[204,204,255;204,255,204;255,204,204;153,255,204;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;
f2fit=@(parameters,tau) FCS_diffusion_twostate(tau,wxy,wz,N,D,parameters(1),parameters(2));

%amplitude of the exp guess
beta_g(1)=1e-1;
%rates guess
beta_g(2)=10^3;

if size(g2,1)~=1
    ave_g2=mean(g2);
    std_g2=std(g2)./size(g2,1)^.5;
    w=1./std_g2.^2;
    wg2=w.^0.5.*ave_g2;
    f2fit=@(beta,tau) w.^0.5.*FCS_diffusion_twostate(tau,wxy,wz,N,D,beta);
    [beta_fit,r]=nlinfit(tau,wg2,f2fit,beta_g);
else
    [parameters_fit,r]=nlinfit(tau,g2,f2fit,[parameters_1_guess,parameters_2_guess]);
end

if size(g2,1)~=1
    figure
    %subplot(4,1,1:3);
    shadedErrorBar_zk(tau,g2,{'Color',darkcolor(1,:),'LineWidth',2});hold on;
    hold on;
    plot(log10(tau),FCS_diffusion_twostate(tau,wxy,wz,N,D,beta_fit),'LineWidth',2);
    axis tight;
    %subplot(4,1,4);
    %plot(log10(tau),r,'or')
    axis tight;
else
    figure;
    semilogx(tau,g2,'-or','MarkerSize',4,'MarkerFaceColor','r');
    hold on;
    semilogx(tau,FCS_diffusion_twostate(tau,wxy,wz,N,D,parameters_fit(1),parameters_fit(2)),'LineWidth',2);
    title(cd);
end

fit.r=r;
fit.beta=beta_fit;
fit.h=chi2gof(r);



% 
% 
% text(10^-3,g2(1)*6/6,sprintf('rate - %g S^-1',parameters_fit(2)));
% text(10^-3,g2(1)*5/6,sprintf('Amp - %g ',parameters_fit(1)));
% disp(cd);
% disp(sprintf('Rate is: %g. \n',parameters_fit(2)));
% disp(sprintf('Amp is: %g',parameters_fit(1)));


function g2tau=FCS_diffusion_twostate(t,wwxy,wwz,NN,DD,beta)
AA=beta(1);
kk=beta(2);
tau_D=wwxy^2/(4*DD);
tau_D_prime=wwz^2/(4*DD);

GG2_diffusion=(1/NN)*(1./(1+t/tau_D)).*(1./(1+t/tau_D_prime).^0.5);

GG2_twostate=AA.*exp(-kk.*t)+1;

g2tau=GG2_diffusion.*GG2_twostate;