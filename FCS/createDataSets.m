function ds=createDataSet(title,idxs,tag,varargin)
cfolder=pwd;
a=strfind(cfolder,'data');
cpath=cfolder(a+5:length(cfolder));
ds=struct('title',title,'sets',[]);
ds.sets=struct('idxs',idxs,'path',cpath,'tag',tag);
n=length(varargin);
if ~(mod(n,2)==0)
    error('Invalid number of arguments. Number of arguments must be 3+even. Type "help createDataSets" for usage');
else
    m=n/2;
    for i=1:m
        ds.sets(i+1).idxs=varargin{2*i-1};
        ds.sets(i+1).tag=varargin{2*i};
        ds.sets(i+1).path=cpath;
    end
end