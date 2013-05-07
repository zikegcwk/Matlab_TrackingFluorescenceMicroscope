function b=mass_bright(tau,g2)
w=dir;
wname=struct2cell(w);

 for j=1:1:size(wname,2)
     temp{1,j}=wname{1,j};
 end
temp
 
y=input('Enter sequence for brightness determination: ');

for j=1:1:size(y,2)
    subdir{1,j}=temp{1,y(j)};
end
disp('will work on:')
subdir
%salt=input('Enter salt sequence: ');
for j=1:1:length(subdir)
    dir_FCS{1,j}=strcat(cd,'\',subdir{1,j});   
end

for ct=1:1:length(dir_FCS)
    cd(dir_FCS{1,ct})
    clear files a n M w fit dt ti M ai stdi
    files=dir('data_*.mat');
    filesnamesCell=struct2cell(files);
    [a,n]=size(filesnamesCell);
    M=zeros(n,1);
    for kk=1:n
        cs=filesnamesCell{1,kk};
        M(kk)=str2num(cs(6:end-4));
    end
    M=sort(M);
    
    w=2;
    fit = FCS_diffusion_fit(tau,g2{ct,6},w,pi*w^2/0.633,[0 0],'general');
    dt=10e-3;
    clear ti;
    for x=1:1:length(M)
        clear tags
        disp(sprintf('in %s, working on data_%g.mat...',subdir{1,ct},M(x)));
        load(sprintf('data_%g.mat',M(x)));
        ti(x)=mean(atime2bin(tags{1},dt))+mean(atime2bin(tags{2},dt));
        disp(sprintf('f rate in this file is %g kHz',ti(x)/dt/1000));
    end

    %mean photon rate is ai in kHz.
    figure(1000+ct);clf;
    subplot(1,2,1);    
    plot(ti/dt/1000);xlabel('files');ylabel('Fluorescence Rate (kHz)');
    subplot(1,2,2);
    fplot(tau,g2,ct,1e-6);
    hold all;
    DD=fit.D;
    NN=fit.N;
    tt=logspace(-6,0,60);tt=tt(1:end-1);
    plot(log10(tt),FCS_openloop(tt,w,pi*w^2/0.633,NN,DD));
    ai=mean(ti)/dt/1000;
    stdi=std(ti/dt/1000);
    
    b(ct).bness=ai/fit.N;%brightness of dye
    b(ct).bstd=(stdi^2/fit.N^2+(ai^2/fit.N^4)*fit.stdN^2)^0.5;
    b(ct).ti=ti;
    b(ct).pr=ai;%average fluo rate.
    b(ct).stdpr=stdi;
    b(ct).rate=ti;%rate at all files.
    b(ct).N=fit.N;%number of molecules
    b(ct).D=fit.D;%diffusion coefficients.
    b(ct).thry=fit.thry;
    b(ct).tau=fit.tau;
end

for k=1:1:length(dir_FCS)
    brit(k)=getfield(b,{1,k},'bness')
    stdbrit(k)=getfield(b,{1,k},'bstd')
end

figure(2011);clf;
errorbar(1:1:length(dir_FCS),brit,stdbrit,'--or','MarkerSize',6,'MarkerFaceColor','r');
xlabel('Sample Index','FontSize',14);
ylabel('Dye Brightness (kHz)','FontSize',14);