function out=DrawPlots3Dselect(rng)
files=dir('data_*.mat');
filesnamesCell=struct2cell(files);
[a,n]=size(filesnamesCell);
M=zeros(n,1);
    for i=1:n
        cs=filesnamesCell{1,i};
        M(i)=str2num(cs(6:end-4));
    end
M=sort(M);
data2draw=[];    
siglist=[]; ndat = 0;
allq=[];

for i=1:length(rng)
    lastfile=(rng(i)-mod(rng(i),100))+100;
    x=find(M<lastfile & M>=rng);
    data2draw=cat(1,data2draw,M(x));
end
j=1; quitloop=-1; ll=[440   378   560   420];
while ((j<=length(data2draw))&&(quitloop<0)),
    DrawPlots3D(data2draw(j),'tfret'); thisfig = gcf; %set(thisfig,'Position',ll);
    load(sprintf('data_%g.mat',data2draw(j)));
    [I{2},t]=atime2bin(tags{2},1e-2);
    [I{1},t]=atime2bin(tags{1},1e-2);

    mchoice=0;
    while (mchoice<5),
        mchoice=menu('Options','Record from Fluor','Record from Stages','Record from Power','Erase last record','Next file','Previous file','Quit');
        if (mchoice==1),
            figure(thisfig); subplot(4,1,1:2);
            gg=get(gca,'Xlim');
            if (gg(1)<0),
                gg(1)=0;
            end;
            if (gg(2)>60),
                gg(2)=60;
            end;
            newsig = [data2draw(j) gg];
            newf=mean(I{1}(round(gg(1)*100):round(gg(2)*100)))...
                +mean(I{2}(round(gg(1)*100):round(gg(2)*100)));
            
            dyestr=input('dye number guess?','s');
            if strcmp(dyestr,'0')
                dyen=0;
            elseif strcmp(dyestr,'1')
                dyen=1;
            elseif strcmp(dyestr,'2')
                dyen=2;
            elseif strcmp(dyestr,'3')
                dyen=3;
            elseif strcmp(dyestr,'4')
                dyen=4
            elseif strcmp(dyestr,'5')
                dyen=5;
            end
            newq=[newf dyen]
            allq=[allq;newq];
            siglist = [siglist; newsig]; ndat = ndat+1;
            set(gca,'XLimMode','auto');
            set(gca,'YLimMode','auto');
        end;
        if (mchoice==2),

        end;
        if (mchoice==3),

        end;        
        if (mchoice==4),
            siglist = siglist(1:ndat-1,:);
        end;        
        allq,
    end;
    ll = get(thisfig,'Position'); close(thisfig);
    if (mchoice==6),
        j=j-1;
    elseif (mchoice==7),
        quitloop=1;
    else
        j=j+1;
    end;    
    out.siglist=siglist;
    out.q=allq;
end