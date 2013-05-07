% G2_RISE_SQWAVE  Calculates the FCS contribution due to square-wave modulated
% excitation with nonzero rise/fall time.
% g2 = g2_sqwave(tau, freq, delta) returns the autocorrelation curve for the pure
% square wave modulation for time bins tau, frequency freq (in Hz), and
% rise/fall time delta (in seconds).
%
% See also g2_sqwave
function g = g2_rise_sqwave(tau, freq, delta),

T = 1/freq;

g = zeros(size(tau));

p = 1:2:1001;

for tt = 1:length(tau)-1,
    t = tau(tt); 
    t0 = tau(tt+1)-tau(tt);

    % note the factor of 4/P^2 for normalization
    g(tt) = 4*T^3/(pi^5*delta^2*t0)*sum(1./p.^5 .*sin(p*pi*delta/T).^2.*...
        (sin(2*p*pi*(t+t0)/T)-sin(2*p*pi*t/T)));
end;

return;
