%function [Dfit,nfit,gfit,Lfit,dt,dx,dy,dz] = all_traces_msd;
function [Dfit,nfit,gfit,Lfit,dt,dx,dy,dz,summary] = all_traces_msd,

if nargout == 0,
    error('This will be a waste of time.');
end;

data_traces;
Ntraces = size(traces, 1);

Npts = 250;

Dfit = zeros(Ntraces, 3);
nfit = zeros(Ntraces, 3);
gfit = zeros(Ntraces, 3);
Lfit = zeros(Ntraces, 3);

dx = zeros(Ntraces, Npts);
dy = zeros(Ntraces, Npts);
dz = zeros(Ntraces, Npts);

summary=zeros(Ntraces, 6);

for u = 1:Ntraces,
    [dt,dx(u, :),dy(u, :),dz(u, :)] = msd3d(traces(u, 1), traces(u, 2), traces(u, 3));
    [Dfit(u, :), nfit(u, :), gfit(u, :), Lfit(u, :)] = msdfit([1 1], dt,dx(u,:),dy(u,:),dz(u,:));
    summary(u,1)=traces(1);
    summary(u,2)=traces(3)-traces(2);
    summary(u,3)=Dfit(u,1);
    summary(u,4)=Dfit(u,2);
    summary(u,5)=Lfit(u,1);
    summary(u,6)=Lfit(u,2);
end;

return;

