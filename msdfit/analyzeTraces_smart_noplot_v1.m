function [atraces,D,Dnoise,gammac,gammap,L,Istats,PlaserStats]=analyzeTraces_smart_noplot_v1(traces,savemode,savefile)
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
noiseDensity=D;
L=D;
Dnoise=D;
noiseDensity=D;
Istats=-1*ones(n,2);
PlaserStats=-1*ones(n,2);
gammac=-1*ones(n,3);
gammap=inf*ones(n,3);

for i=1:n
    
    
    [dT, DX, DY, DZ,EB,I,Plaser] = MSD3D_EB(atraces(i,1),atraces(i,2),atraces(i,3));
    [D_fit, D_noise, gammavec_fit, L_accuracy, noiseD] = msdfit_EB_smart(dT, DX, DY, DZ,EB,0);
    
    idxs=find(isreal(D_fit) & L_accuracy<thres & D_fit>0);
    if not(isempty(idxs))
        atraces(i,4)=mean(D_fit(idxs));
    end
    D(i,:)=D_fit';
    gammac(i,:)=gammavec_fit(:,1)';
    gammap(i,:)=gammavec_fit(:,2)';
    L(i,:)=L_accuracy';
    Dnoise(i,:)=D_noise';
    noiseDensity(i,:)=noiseD';
    
    Istats(i,1)=mean(I); Istats(i,2)=var(I,1);
    PlaserStats(i,1)=mean(Plaser); PlaserStats(i,2)=var(Plaser,1);
    
    display(sprintf('%g : Trace %g out of %g, D=%g \n',toc,i,n,atraces(i,4)));
end
    
if nargin<3
    savefile='./analysis.mat';
end
if savemode==1 %%append
    if ~exist(savefile)
        save(savefile,'atraces','D','gammac','gammap','L','Dnoise','noiseDensity','Istats','PlaserStats');
    else
        u=load(savefile);
        currentTraces=u.atraces;
        atraces=cat(1,currentTraces(:,1:5),atraces);
        D=cat(1,u.D,D);
        noiseDensity=cat(1,u.noiseDensity,noiseDensity);
        gammac=cat(1,u.gammac,gammac);
        gammap=cat(1,u.gammap,gammap);
        L=cat(1,u.L,L);
        Dnoise=cat(1,u.Dnoise,Dnoise);
        save(savefile,'atraces','D','gammac','gammap','L','Dnoise','noiseDensity','Istats','PlaserStats');
    end
else if savemode==2 %%overwrite
        save(savefile,'atraces','D','gammac','gammap','L','Dnoise','noiseDensity','Istats','PlaserStats');
    end
end

fprintf(1,'Job completed in %g s', toc);

end



