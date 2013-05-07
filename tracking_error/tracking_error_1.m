%function sigma_tau=tracking_error_1(tau,D,gamma,f)

% calculates the tracking error by using the first order tracking system

% model. tau is a vector and the delay time used in FCS. D is the diffusion

% coefficient of the tracked molecule, gamma is the level of aggression of

% the feedback controller, or the tracking bandwidth, f is the power spectral density of the noise process.  



function sigma_tau=tracking_error_1(tau,D,gamma,f)



sigma_tau=(exp(-gamma*tau)*(D/gamma+0.5*f^2*gamma));



