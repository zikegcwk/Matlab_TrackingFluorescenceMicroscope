function y=autoprocess_dcoeff2apds(ds,corrPairs,taumin,taumax,w,xi,d0)
%dirinit=pwd;
nsets=length(ds.sets);
y=struct('tag',0,...
    'D_mean',0,'D_std',0,'D',0,'N_mean',0,'N_std',0,'N',0,...
    'D_mean',0,'D_std',0,'D',0,'N_mean',0,'N_std',0,'N',0,...
    'D_mean',0,'D_std',0,'D',0,'N_mean',0,'N_std',0,'N',0,...
    'Ncounts',[],...
    'tau',[],'g0',[],'g1',[],'gx',[]);
for i=1:nsets   
cset=ds.sets(i);
y(i).tag=cset.tag;
%cdir=sprintf('/mnt/tracking/external/data/%s',cset.path);
%display(sprintf('Processing set of path %s and with tag %d...',cset.path,cset.tag));
%cd(cdir);

display('Calculating stacked fcs...');
[st,y(i).Ncounts]=stacktraces(cset.idxs,100);
[y(i).tau,y(i).g0,y(i).g1,y(i).gx]=lfcsLL2apds(st,taumin,taumax,200);
[y(i).D,y(i).N]=fcs_singleparticle_Dfit(y(i).tau,y(i).g,w,0,d0,0);
display('Calculating individual fcs...');
[DS,NS]=alltraces_Dfit(cset.idxs,taumin,taumax,w,xi,d0,0);
y(i).D_mean=mean(DS);
y(i).N_mean=mean(NS);
y(i).D_std=std(DS,1);
y(i).N_std=std(NS,1);
end
%display('Switching back to the initial directory');