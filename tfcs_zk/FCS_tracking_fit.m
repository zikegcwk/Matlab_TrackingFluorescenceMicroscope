function fit=FCS_tracking_fit(tau,g2)
%% prepare the data for fitting
ave_g2=mean(g2);
size_g2=size(g2);
std_g2=std(g2)./size_g2(1,1).^0.5;

%set the weights as 1/sigma^2.
w=1./std_g2.^2;
%weight the data. 
wg2=w.^0.5.*ave_g2;

beta_g(1)=100;
beta_g(2)=0.05;
beta_g(3)=100;
beta_g(4)=0.05;

f2fit=@(beta,tau) w.^0.5.*FCS_tracking(tau,beta);
[fit.beta_fit,fit.r,fit.J,fit.sigma]=nlinfit(tau,wg2,f2fit,beta_g);
fit.ci=nlparci(fit.beta_fit,fit.r,'jacobian',fit.J);
fit.tg2=FCS_tracking(tau,fit.beta_fit);
fit.h=chi2gof(fit.r);
% %output results
% fitting_results{1,1}='Number of molecules';fitting_results{1,2}=parameters_fit(1);fitting_results{1,3}=ci(1,2)-parameters_fit(1);
% fitting_results{2,1}='Diffusion Coefficient';fitting_results{2,2}=parameters_fit(2);fitting_results{2,3}=ci(2,2)-parameters_fit(2);
% 

figure;
subplot(4,1,1:3);
hold all;
plot(log10(tau),FCS_tracking(tau,fit.beta_fit));
shadedErrorBar_zk(tau,g2);
subplot(4,1,4);
plot(log10(tau),fit.r,'*r')

function g2tau=FCS_tracking(t,para),
gama1=para(1);
c1=para(2);
gama2=para(3);
c2=para(4);

%red laser waist size in xyz.
wxy=1;
wz=pi*wxy^2/0.633;

sigma_xy=c1*exp(-gama1.*t);
sigma_z=c2*exp(-gama2.*t);


g2tau=((0.25*wxy^2+c1)^2./((0.25*wxy^2+c1)^2-sigma_xy.^2))...
    .*((0.25*wz^2+c2)./((0.25*wz^2+c2)^2-sigma_z.^2).^0.5)-1;
