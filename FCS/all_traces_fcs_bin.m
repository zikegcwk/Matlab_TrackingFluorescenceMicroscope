function [g0, tau0, g1, tau1] = all_traces_fcs_bin(dt),

if nargout == 0,
    error('This will be a waste of time.');
end;

if nargin < 1,
    error('One argument required.');
end;

Ntau = round(1/dt);
data_traces;
Ntraces = size(traces, 1);
g0 = zeros(Ntraces, Ntau);
g1 = g0;

for u = 1:Ntraces,
    load(sprintf('data_%g', traces(u, 1)));
    data0 = tags{1}(find(tags{1} > traces(u, 2) & tags{1} < traces(u, 3)));
    data1 = tags{2}(find(tags{2} > traces(u, 2) & tags{2} < traces(u, 3)));
    [i0,t0] = atime2bin(data0, dt);
    [i1,t1] = atime2bin(data1, dt);
    [g0(u, :), tau0] = computeFCS(i0,dt, 1);
    [g1(u, :),tau1] = computeFCS(i1,dt, 1);
end;

return;

