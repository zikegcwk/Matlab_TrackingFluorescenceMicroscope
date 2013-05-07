function [atraces,D,noiseDensity,gammac,gammap,L,Dnoise,dimfit]=analyzeTraces_smart(traces,savemode)
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
dimfit=zeros(n,3);
gammac=-1*ones(n,3);
gammap=inf*ones(n,3);

for i=1:n
    correctIn=0;
    display(sprintf('Analyzing trace %g out of %g',i,n));
    [dT, DX, DY, DZ,EB] = MSD3D_EB(atraces(i,1),atraces(i,2),atraces(i,3));
    [D_fit, n_fit, gammavec_fit, L_accuracy, D_noise, nd, h] = msdfit_EB_smart(dT, DX, DY, DZ,EB);
    idxs=find(isreal(D_fit) & L_accuracy<thres & D_fit>0);
    if not(isempty(idxs))
        atraces(i,4)=mean(D_fit(idxs));
    end
    D(i,:)=D_fit';
    noiseDensity(i,:)=n_fit';
    gammac(i,:)=gammavec_fit(:,1)';
    gammap(i,:)=gammavec_fit(:,2)';
    L(i,:)=L_accuracy';
    Dnoise(i,:)=D_noise';
    dimfit(i,:)=nd';
    
    
    display(sprintf('Current diffusion coefficient: %g \n',atraces(i,4)));
    fprintf(1,'D=');
    fprintf(1,'%g,',D(i,:));
    fprintf(1,' ; noiseDensity=');
    fprintf(1,'%g,',noiseDensity(i,:));
    fprintf(1,' ; gammac=');
    fprintf(1,'%g,',gammac(i,:));
    fprintf(1,' ; gammap=');
    fprintf(1,'%g,',gammap(i,:));
    fprintf(1,' ; L=');
    fprintf(1,'%g,',L(i,:));
    fprintf(1,' ; Dnoise=');
    fprintf(1,'%g,',Dnoise(i,:));
    fprintf(1,'\n');
    
    while not(correctIn)
        [x,y,buttons] = ginput(1);
        switch buttons
            case 1
                atraces(i,4)=y;
                correctIn=1;
                display(sprintf('Diffusion coefficient selected=%g',y));
            case 8
                atraces(i,4)=-1;
                correctIn=1;
                display('Trace rejected');
            case 32
                correctIn=1;
                display(sprintf('Choosing default diffusion coefficient=%g',atraces(i,4)));
            otherwise
                sprintf('Wrong command');
                correctIn=0;
        end
    end
    close(h);
    ca_traces=atraces(1:i,:)
    
end

if savemode==1 %%append
    if ~exist('./analysis.mat')
        save analysis.mat atraces
    else
        u=load('analysis.mat');
        currentTraces=u.atraces;
        atraces=cat(1,currentTraces(:,1:5),atraces);
        save analysis.mat atraces
    end
else if savemode==2 %%overwrite
        save analysis.mat atraces
    end
end

end



