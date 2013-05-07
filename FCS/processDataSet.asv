function [tau,gss,ncounts]=processDataSet(ds,corrPairs,taumin,taumax,N)
%dirinit=pwd;
tic;
nsets=length(ds);
display(sprintf('Processing data_%d...',ds(1)));
u=load(sprintf('data_%d.mat',ds(1)));
[tau,gss]=lfcsLL2apds(u.tags,corrPairs,taumin,taumax,N);
npairs=length(corrPairs);
nchannels=length(u.tags);
ncounts=zeros(nsets,nchannels);
    for j=1:nchannels
       deltaT=round(u.tags{j}(end));
    ncounts(1,j)=length(u.tags{j})/deltaT;
    end
for i=2:nsets
    display(sprintf('Processing data_%d...',ds(i)));
    u=load(sprintf('data_%d.mat',ds(i)));
    [tau,gs]=lfcsLL2apds(u.tags,corrPairs,taumin,taumax,N);
    for j=1:npairs
        gss{j}=gss{j}+gs{j};
    end
    nchannels=length(u.tags);
    for j=1:nchannels
       deltaT=round(u.tags{j}(end));
    ncounts(i,j)=length(u.tags{j})/deltaT;
    end
end
for j=1:npairs
    gss{j}=gss{j}/nsets;
end
display(sprintf('Job terminated in %d seconds',toc));


    
        
    