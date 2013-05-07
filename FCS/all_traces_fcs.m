%function [g0,tau,g1,gx] = all_traces_fcs(taumin,taumax,Ntau, linear),
function [g0,tau,g1,gx] = all_traces_fcs(taumin,taumax,Ntau, linear),


if nargout == 0,
    error('This will be a waste of time.');
end;

if nargin < 3,
    error('At least three arguments required.');
end;

if nargin < 4,
    linear = 0;
end;

data_traces;
Ntraces = size(traces, 1);
g0 = zeros(Ntraces, Ntau-1);

if nargout > 2,
    g1 = g0;
end;

if nargout > 3,
    gx = g0;
end;

for u = 1:Ntraces,
    if nargout > 3,
        [tau,g0(u, :), g1(u, :), gx(u, :)] = lfcs(traces(u, 1), taumin, taumax, Ntau, traces(u, 2), traces(u, 3), linear);
    else if nargout > 2,
          [tau,g0(u, :), g1(u, :)] = lfcs(traces(u, 1), taumin, taumax, Ntau, traces(u, 2), traces(u, 3), linear);
        else
          [tau,g0(u, :)] = lfcs(traces(u, 1), taumin, taumax, Ntau, traces(u, 2), traces(u, 3), linear);
        end;
    end;
end;

return;

