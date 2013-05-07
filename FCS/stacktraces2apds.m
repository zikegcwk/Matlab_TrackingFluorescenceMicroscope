function [alltraces,ncounts]=stacktraces2apds(dataidxs)
nidxs=length(dataidxs);
alltraces={[],[],[],[]};
ncounts=zeros(nidxs,4);
deltaT=100;
for i=1:nidxs
    cdata=load(sprintf('data_%d.mat',dataidxs(i)));
    %       display(sprintf('Loading data_%d.mat',dataidxs(i)))
    nchannels=length(cdata.tags);
    for j=1:nchannels
    cI=cdata.tags{j};
    if j==1
        deltaT=cI(end);
    end
    ncounts(i,j)=length(cI)/deltaT;
    cI=cI+deltaT*(i-1);
    alltraces{j}=cat(2,alltraces{j},cI);
    end
end
end