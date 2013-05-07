% G2_SQWAVE  Calculates the FCS contribution due to square-wave modulated
% excitation.
% g2 = g2_sqwave(tau, freq) returns the autocorrelation curve for the pure
% square wave modulation for time bins tau and frequency freq (in Hz).
%
% Note that the actual modulation will never be a true square wave, but
% will have a finite rise and fall time due to modulator actuation.  If
% your modulator is sufficiently slow that this rise time is a
% nonnegligible fraction of the cycle period, use g2_rise_sqwave.
%
% See also g2_rise_sqwave
function g = g2_sqwave(tau, freq),

T = 1/freq;

g = zeros(size(tau));

p = 1:2:1001;

for tt = 1:length(tau)-1,
    t = tau(tt); 
    t0 = tau(tt+1)-tau(tt);

    % note the factor of 4/P^2 for normalization
    g(tt) =  4*T/(pi^3*t0)*sum(1./p.^3.*(sin(2*p*pi*(t+t0)/T)-sin(2*p*pi*t/T)));
end;


return;
