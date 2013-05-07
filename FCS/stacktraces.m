function [alltraces,ncounts]=stacktraces(dataidxs,deltaT)
nidxs=length(dataidxs);
alltraces=[];
ncounts=zeros(nidxs,1);
for i=1:nidxs
    cdata=load(sprintf('data_%d.mat',dataidxs(i)));
    display(sprintf('Loading data_%d.mat',dataidxs(i)))
    cI=cdata.tags{1};
    ncounts(i)=length(cI);
    cI=cI+deltaT*(i-1);
    alltraces=cat(2,alltraces,cI);
end
end