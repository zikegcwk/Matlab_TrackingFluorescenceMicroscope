function [tau,gs]=lfcs2channels(dataid, tstart, tstop, corrPairs, taumin, taumax,N)
display(sprintf('Processing data_%d...',dataid));
tic;
u=load(sprintf('data_%d.mat',dataid));
traces=u.tags;

tau = logspace(taumin,taumax,N);
npairs=length(corrPairs);
for i=1:npairs
    cpair=corrPairs{i};
    
    channel1=traces{cpair(1)};
    firstphoton=find(channel1>tstart,1,'first');
    lastphoton=find(channel1<tstop,1,'last');
    channel1=channel1(firstphoton:lastphoton);
    
    channel2=traces{cpair(2)};
    firstphoton=find(channel2>tstart,1,'first');
    lastphoton=find(channel2<tstop,1,'last');
    channel2=channel2(firstphoton:lastphoton);
    
    gs{i}=corr_Laurence(channel1,channel2,tau);
    gs{i}=gs{i}(1:end-1)-1;
end
tau = tau(1:end-1);
display(sprintf('Job terminated in %d seconds',toc));