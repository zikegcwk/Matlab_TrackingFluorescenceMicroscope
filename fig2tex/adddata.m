function traces=adddata(filenum,tstart,tstop)
switch nargin
    case 0
    if ~exist('./gooddata.mat')
        display('No data in the index');
        traces=[];
    else
        u=load('./gooddata.mat');
        traces=u.traces;
    end
    case 1
        if ~exist('./gooddata.mat')
    traces=filenum;
    save gooddata.mat traces
    else
    u=load('./gooddata.mat');
    traces=u.traces;
    traces=cat(1,traces,filenum);
    save gooddata.mat traces
        end
    case 3
if ~exist('./gooddata.mat')
    traces=[filenum,tstart,tstop];
    save gooddata.mat traces
else
    u=load('./gooddata.mat');
    traces=u.traces;
    traces(end+1,:)=[filenum,tstart,tstop];
    save gooddata.mat traces
end
    end
end
