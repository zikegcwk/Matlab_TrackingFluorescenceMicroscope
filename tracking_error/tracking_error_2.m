%% description of the code
%function sigma_tau=tracking_error_2(tau,D,gamma,f)

%GENEARL INFORMATION
%%%%%%%%%%%%%
% calculates the tracking error at different time sclaes by using the second order tracking system
% model. In this model we treat plant as a low pass filter with some cutoff frequency, beyond which both gain and phase roll off. 
%This low pass filter model is a reasonable approximation to our mechanial
%system. 
%SYSTEM PARAMETERS
%tau is a vector and the delay time used in FCS. 
%D is the diffusion coefficient of the tracked molecule
%gamma is a 1 by 2 matrix. First col gives gamma_c - level of aggression of
%the controller. Second col gives gamma_p - (gamma_p/2/pi) gives the cutoff
%frequency of the low pass filter. 
%f is the power spectral density of the noise process.  






%% implementation
function sigma_tau=tracking_error_2(tau,D,gamma,f)
if length(gamma)~=2
    error('check your gamma values. make sure its length is 2.');
end

gc=gamma(1);
gp=gamma(2);
v=(gp^2-4*gp*gc)^0.5;
%sigma_tau has the unit of um^2.
sigma_tau=(D*exp(-gp*tau*0.5).*((1/gp+1/gc)*cosh(0.5*v*tau)+gp*(1/v)*(1/gc-1/gp)*sinh(0.5*v*tau))+0.5*f^2*gc*exp(-0.5*gp*tau).*(cosh(0.5*v*tau)+gp*(1/v)*sinh(0.5*v*tau)));





















































































