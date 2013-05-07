function fit=FCS_TrackingThreeState_fit(tau,g2,tg2)
%% prepare the data for fitting
ave_g2=mean(g2);
size_g2=size(g2);
std_g2=std(g2)./size_g2(1,1).^0.5;
%set the weights as 1/sigma^2.
w=1./std_g2.^2;
%weight the data. 
wg2=w.^0.5.*ave_g2;
%initial estimation of the fitting parameters.
beta_g(1)=0.02;
beta_g(2)=100;
beta_g(3)=0.02;
beta_g(4)=300;

figure;
plot(log10(tau),TrackingThreeState(tau,tg2,beta_g))


%% perform fitting
f2fit=@(beta,tau) w.^0.5.*TrackingThreeState(tau,tg2,beta);
[fit.beta_fit,fit.r,fit.J,fit.sigma]=nlinfit(tau,wg2,f2fit,beta_g);
%fit.ci=nlparci(fit.beta_fit,fit.r,'covar',fit.sigma,'alpha',0.38);
fit.ci=nlparci(fit.beta_fit,fit.r,'jacobian',fit.J,'alpha',0.38);

fit.h=chi2gof(fit.r);

% %output results
% fitting_results{1,1}='Number of molecules';fitting_results{1,2}=parameters_fit(1);fitting_results{1,3}=ci(1,2)-parameters_fit(1);
% fitting_results{2,1}='Diffusion Coefficient';fitting_results{2,2}=parameters_fit(2);fitting_results{2,3}=ci(2,2)-parameters_fit(2);
%% plotting
figure;
subplot(4,1,1:3)
hold all;
plot(log10(tau),TrackingThreeState(tau,tg2,fit.beta_fit));
shadedErrorBar_zk(tau,g2);
subplot(4,1,4);
plot(log10(tau),fit.r,'--*r')

%% fitting functions
%function TrackingTwoState takes inputs tau, tracking theoretical
%function, and beta for two state function and generate the combination of
%the two.
function g=TrackingThreeState(tau,tg2,beta)
c1=beta(1);
rate1=beta(2);
c2=beta(3);
rate2=beta(4);

g=(tg2+1).*(c1.*exp(-rate1.*tau)+c2.*exp(-rate2.*tau)+1)-1;
