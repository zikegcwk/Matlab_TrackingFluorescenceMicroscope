function [atraces,D,Dnoise,gammac,gammap,L,noiseDensity,Istats,PlaserStats,StageStats]=analyzeTraces_smart_noplot(traces,savemode,savefile)
tic
warning off stats:nlinfit:IterationLimitExceeded
[n,p]=size(traces);
thres=0.3;
if(p<=3)
    atraces=cat(2,traces,zeros(n,2));
    x=1:n;
    atraces(:,5)=x';
    atraces(:,4)=-1;
else
    atraces=traces;
end
display(sprintf('%g traces to analyze \n',n));
D=-1*ones(n,3);
L=D;
Dnoise=D;
noiseDensity=D;
Istats=-1*ones(n,2);
PlaserStats=-1*ones(n,2);
StageStats=-1*ones(n,9);
gammac=-1*ones(n,3);
gammap=inf*ones(n,3);
cfile=-1;

for i=1:n
    if not(atraces(i,1)==cfile)
        cfile=atraces(i,1);
        load(sprintf('data_%g.mat',cfile));
    end
    
    ix = find(t0 >= atraces(i,2) & t0 <= atraces(i,3));
    if not(isempty(ix)) && length(ix)>399
        tmax=t0(ix(end));
        x=x0(ix); y=y0(ix); z=z0(ix); t=t0(ix); 
%         I=atime2bin(tags{1},1e-3,atraces(i,2),tmax);
%         Plaser=daq_out;
%         Plaser=Plaser(ix);
        
        [dT, DX, DY, DZ,EB] = MSD3D_EB_smart(t,x,y,z);
        [D_fit, D_noise, gammavec_fit, L_accuracy, noiseD] = msdfit_EB_smart(dT, DX, DY, DZ,EB,0);
        
       idxs=find(isreal(D_fit(1:2)) & L_accuracy(1:2)<thres & D_fit(1:2)>0);
        if not(isempty(idxs))
            atraces(i,4)=mean(D_fit(idxs));
        end
        D(i,:)=D_fit';
        gammac(i,:)=gammavec_fit(:,1)';
        gammap(i,:)=gammavec_fit(:,2)';
        L(i,:)=L_accuracy';
        Dnoise(i,:)=D_noise';
        noiseDensity(i,:)=noiseD';
        
%         Istats(i,1)=mean(I); Istats(i,2)=var(I,1);
%         PlaserStats(i,1)=mean(Plaser); PlaserStats(i,2)=var(Plaser,1);
        
        StageStats(i,1)=min(x);
        StageStats(i,2)=max(x);
        StageStats(i,3)=mean(x);
        
        StageStats(i,4)=min(y);
        StageStats(i,5)=max(y);
        StageStats(i,6)=mean(y);
        
        StageStats(i,7)=min(z);
        StageStats(i,8)=max(z);
        StageStats(i,9)=mean(z);
%         
%         StageStats(i,10)=stage(
    end
    
    display(sprintf('%g : Trace %g out of %g, D=%g \n',toc,i,n,atraces(i,4)));
end

if nargin>1

if nargin<3
    savefile='./analysis.mat';
end
if savemode==1 %%overwrite
    save(savefile,'atraces','D','gammac','gammap','L','Dnoise','noiseDensity','Istats','PlaserStats','StageStats');
end
end
fprintf(1,'Job completed in %g s', toc);

end



