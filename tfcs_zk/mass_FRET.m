function fe=mass_FRET(tau,g2)
w=dir;
wname=struct2cell(w);

 for j=1:1:size(wname,2)
     temp{1,j}=wname{1,j};
 end
temp
 
y=input('Enter sequence for FRET determination: ');

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
    
    clear ti fx;
    for x=1:1:length(M)
        clear tags
        disp(sprintf('in %s, working on data_%g.mat...',subdir{1,ct},M(x)));
        fx(x)=FRET_e_by_tags(M(x));
        disp(sprintf('FRET E is: %g',fx(x)));
    end
    
    fe(ct).FRETe=mean(fx);
    fe(ct).stdFRETe=std(fx);
    fe(ct).allFRETe=fx;
    fe(ct).dir=dir_FCS{1,ct};
end

for k=1:1:length(dir_FCS)
    fret(k)=fe(k).FRETe;
    stdfret(k)=fe(k).stdFRETe;
end
fe(length(dir_FCS)+1).meanE=fret;
fe(length(dir_FCS)+1).stdE=stdfret;
figure(2011);clf;
errorbar(1:1:length(dir_FCS),fret,stdfret,'--or','MarkerSize',6,'MarkerFaceColor','r');
xlabel('Sample Index','FontSize',14);
ylabel('FRET Efficiency','FontSize',14);