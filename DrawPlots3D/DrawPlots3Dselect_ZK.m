function siglist=DrawPlots3Dselect_ZK(rng)
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
for i=1:length(rng)
    lastfile=(rng(i)-mod(rng(i),100))+100;
    x=find(M<lastfile & M>=rng);
    data2draw=cat(1,data2draw,M(x));
end
j=1; quitloop=-1; ll=[440   378   560   420];
while ((j<=length(data2draw))&&(quitloop<0)),
    DrawPlots3D(data2draw(j),'tfret'); thisfig = gcf; %set(thisfig,'Position',ll);
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
            siglist = [siglist; newsig]; ndat = ndat+1;
            set(gca,'XLimMode','auto');
            set(gca,'YLimMode','auto');
            msd3d(newsig(1,1),newsig(1,2),newsig(1,3));
            FCS_ZK(newsig(1,1),newsig(1,1),newsig(1,2),newsig(1,3),-5,0,100);
        end;
        if (mchoice==2),
            figure(thisfig); subplot(4,1,3);
            gg=get(gca,'Xlim');
            if (gg(1)<0),
                gg(1)=0;
            end;
            if (gg(2)>60),
                gg(2)=60;
            end;
            newsig = [data2draw(j) gg];
            siglist = [siglist; newsig]; ndat = ndat+1;
            set(gca,'XLimMode','auto');
            set(gca,'YLimMode','auto');
            msd3d(newsig(1,1),newsig(1,2),newsig(1,3));
            FCS_ZK(newsig(1,1),newsig(1,1),newsig(1,2),newsig(1,3),-5,0,100);

        end;
        if (mchoice==3),
            figure(thisfig); subplot(4,1,4);
            gg=get(gca,'Xlim');
            if (gg(1)<0),
                gg(1)=0;
            end;
            if (gg(2)>60),
                gg(2)=60;
            end;
            newsig = [data2draw(j) gg];
             siglist = [siglist; newsig]; ndat = ndat+1;
            set(gca,'XLimMode','auto');
           set(gca,'YLimMode','auto');
           msd3d(newsig(1,1),newsig(1,2),newsig(1,3));
           %FCS_ZK(newsig(1,1),newsig(1,1),newsig(1,2),newsig(1,3),-5,0,100);

        end;        
        if (mchoice==4),
            l_siglist=length(siglist);
            siglist(l_siglist,:)=[];
        end;        
        siglist
    end;
    ll = get(thisfig,'Position'); close(thisfig);
    if (mchoice==6),
        j=j-1;
    elseif (mchoice==7),
        quitloop=1;
    else
        j=j+1;
    end;    
end